close all;  clear; clc;

load('Signal4.mat')
N = 64;
CP = 16;
pilot_num = 0;
signal_matrix = [];
pilot_matrix = [];
result = [];
result_pilot = [];
result_all = [];
Signal(1:23) = [];

%% Carrier Frequency Offset Compensation
m = length(Signal);
Signal = Signal.*exp(-1i*2*pi*(0+6:m-1+6)*(0.011238730060135));

%% Find the number of pilots
for m = 1:max(size(Signal))
    if abs(Signal(m)) > 0.6
        pilot_num = pilot_num +1;
        pilot_matrix = [pilot_matrix; Signal(m-16:m+63)];
        signal_matrix = [signal_matrix; Signal(m+64:m+143)];
    end
end

%% Carrier Frequency Offset Calculation and Evaluation
A = mean(mean(angle(signal_matrix(:,1:16)./signal_matrix(:,65:80))));
offset = (A)/(2*pi*64);

%% Taking FFT from pilots and symbol matrix
for m = 1:pilot_num
    result = [result; fft(signal_matrix(m,17:80),N)];
    result_pilot = [result_pilot; fft(pilot_matrix(m,17:80),N)];
end

%% Shifting the FFT result
result = [result(:,N/2-1:end) result(:,1:N/2-2)];
result_pilot = [result_pilot(:,N/2-1:end) result_pilot(:,1:N/2-2)];
result_all = [result; result_pilot];

%% Channel Magnitude Estimation
H = mean(abs(result_all));
H(:,1:4) = 0;
H(:,33) = 0;
H(:,62:64) = 0;

%% Compute SNR
SNR = SNR_4(result,result_pilot);

%% Signal4 decoding
result_n = [];
pgd = [64 63 62 33 4 3 2 1];
for m = 1:size(pgd,2)
    result(:,pgd(m)) = [];
end

for m = 1:size(result,1)
    result_n = [result_n result(m,:)];
end
[message,dec_string] = sig_decoder(result_n,1);
