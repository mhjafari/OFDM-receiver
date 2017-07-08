close all; clear; clc;

load('Signal5.mat')
N = 64;
big_sym_t = N+16;
sym_num = (size(Signal,2)-18)/(N+16);
signal_matrix = [];
result = [];
sample = zeros(1,20);
pilot_sample = [];
pilot_ind = [5 13 21 29 37 45 53 61];
coeff = [];

%% Detection of the Start of Signal
% for n = 1:3926
%     sample(n) = max(abs(xcorr(Signal(n+5:n+10),Signal(n+N+5:n+N+10))));
% end
Signal(1:18) = [];
%% Carrier Frequency Offset Compensation
m = length(Signal);
Signal = Signal.*exp(-1i*2*pi*(0:m-1)*(-0.002614832978));

%% Divide signal
for m = 1:sym_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+1:(m*big_sym_t))];
end

%% Carrier Frequency Offset Calculation and Evaluation
A = mean(mean(angle(signal_matrix(:,1:16)./signal_matrix(:,65:80))));
offset1 = (A)/(2*pi*64); % Initial calculation and/or validation
offset2 = (pi-A)/(2*pi*64); % Second possible value
offset3 = (2*pi-A)/(2*pi*64); % Third possible value

%% Removing Cyclic Prefix
sym_matrix = signal_matrix(:,end-N+1:end);

%% Taking FFT
for m = 1:sym_num
    result = [result; fft(sym_matrix(m,:),N)];
end

%% Shifting the FFT result
result = [result(:,N/2+2:end) result(:,1:N/2+1)];

%% Channel Magnitude Estimation
H = mean(abs(result));
H(1:4) = 0;
H(33) = 0;
H(62:64) = 0;

%% Extracting Pilot Samples
for m = 1:size(pilot_ind,2)
    pilot_sample = [pilot_sample result(:,pilot_ind(m))];
end

%% Calculation of Sampling Frequency Offset
for m = 1:size(pilot_sample,1)
    coeff = [coeff ; polyfit(pilot_ind,angle(pilot_sample(m,:)),1)];
    if coeff(m,1) < 0
        coeff(m,:) = polyfit(pilot_ind,wrapTo2Pi(angle(pilot_sample(m,:))),1);
    end
end
coeff(49,:) = polyfit(pilot_ind(1:5),wrapTo2Pi(angle(pilot_sample(m,1:5))),1);
temp = polyfit(pilot_ind(3:8),wrapTo2Pi(angle(pilot_sample(m,3:8))),1);
coeff(50,1) = temp(1);
coeff(50,2) = 2.5145;
s_offset = [];
for m = 2 : size(coeff,1)
    s_offset = [s_offset ; coeff(m,1)-coeff(m-1,1)];
end
s_offset = mean(s_offset);
%% Sampling Frequency Offset Compensation
for m = 1:size(result,1)
    result(m,:) = result(m,:).* exp(-1i*(coeff(m,1)*(0:63)+coeff(m,2)));
end
pilot_sample = [];
for m = 1:size(pilot_ind,2)
    pilot_sample = [pilot_sample result(:,pilot_ind(m))];
end
const_phase = [];
for m = 1:size(pilot_sample,1)
    const_phase = [const_phase;mean(angle(pilot_sample(m,:)))];
end
for m = 1:size(result,1)
    result(m,:) = result(m,:).* exp(-1i*const_phase(m));
end
pilot_sample = [];
for m = 1:size(pilot_ind,2)
    pilot_sample = [pilot_sample result(:,pilot_ind(m))];
end

%% Compute SNR
pilot_ind1 = [61 53 45 37 29 21 13 5];
SNR = SNR_5(result,pilot_sample,pilot_ind1);

%% Signal5 decoding
result_n = [];
pgd = [64 63 62 61 53 45 37 33 29 21 13 5 4 3 2 1];
for m = 1:size(pgd,2)
    result(:,pgd(m)) = [];
end
for m = 1:size(result,1)
    result_n = [result_n result(m,:)];
end
message = sig_decoder(result_n,3);
