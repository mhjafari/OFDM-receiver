close all; clear; clc;

load('Signal6.mat')
N = 128;
CP = 32;
big_sym_t = N+32;
signal_matrix = [];
result = [];
Signal(1:44) = [];
coeff = [];
sym_num = (size(Signal,2))/(big_sym_t);
pilot = [4 13 21 30];

%% Carrier Frequency Offset Compensation
m = length(Signal);
Signal = Signal.*exp(-1i*2*pi*(0:m-1)*(-0.001552545962187));

%% Divide signal
for m = 1:sym_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+1:(m*big_sym_t))];
end

%% Carrier Frequency Offset Calculation and Evaluation
A = mean(mean(angle(signal_matrix(:,1:CP)./signal_matrix(:,N+1:N+CP))));
offset = A/(2*pi*128);

%% Removing Cyclic Prefix
sym_matrix = signal_matrix(:,end-N+1:end);

%% Taking FFT
for m = 1:sym_num
    result = [result; fft(sym_matrix(m,:),N)];
end

%% Shifting the FFT result
result = [result(:,end-18:end) result(:,1:end-19)];

%% Extract Available Data
result(:,33:end) = [];

%% Channel Magnitude Estimation
H = mean(abs(result));
H(1:3) = 0;
H(17) = 0;
H(31:32) = 0;

%% Extracting Pilot Samples
pilot_sample = [];
for m = 1:size(pilot,2)
    pilot_sample = [pilot_sample result(:,pilot(m))];
end

%% Calculation of Sampling Frequency Offset
for m = 1:size(pilot_sample,1)
    coeff = [coeff ; polyfit(pilot,angle(pilot_sample(m,:)),1)];
    if coeff(m,1) > 0
        coeff(m,:) = polyfit(pilot,wrapTo2Pi(angle(pilot_sample(m,:))),1);
    end
end
s_offset = [];
for m = 2 : size(coeff,1)
    s_offset = [s_offset ; coeff(m,1)-coeff(m-1,1)];
end
s_offset = mean(s_offset);

%% Sampling Frequency Offset Compensation
for m = 1:size(result,1)
    result(m,:) = result(m,:).* exp(-1i*(coeff(m,1)*(0:31)+coeff(m,2)));
end
pilot_sample = [];
for m = 1:size(pilot,2)
    pilot_sample = [pilot_sample result(:,pilot(m))];
end

const_phase = [];
for m = 1:size(pilot_sample,1)
    const_phase = [const_phase;mean(angle(pilot_sample(m,:)))];
end
for m = 1:size(result,1)
    result(m,:) = result(m,:).* exp(-1i*const_phase(m));
end
pilot_sample = [];
for m = 1:size(pilot,2)
    pilot_sample = [pilot_sample result(:,pilot(m))];
end

%% Compute SNR
pilot_ind = [30 21 13 4];
SNR = SNR_6(result,pilot_sample,pilot_ind);

%% Signal6 decoding
result_n = result;
pgd = [32 31 30 21 17 13 4 3 2 1];
for m = 1:size(pgd,2)
    result_n(:,pgd(m)) = [];
end
Result = [];
for m = 1:size(result,1)
    Result = [Result result_n(m,:)];
end
message = sig_decoder(Result,2);
