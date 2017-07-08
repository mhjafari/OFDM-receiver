close all; clear; clc;

load('Signal3.mat')
N = 64;
big_sym_t = N+16;
sym_num = size(Signal,2)/(N+16);
signal_matrix = [];
result = [];
pilot_sample = [];
pilot_ind = [61 53 45 37 29 21 13 5];
pgd = [64 63 62 61 53 45 37 33 29 21 13 5 4 3 2 1];

%% Divide signal
for m = 1:sym_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+1:(m*big_sym_t))];
end

%% Removing Cyclic Prefix
sym_matrix = signal_matrix(:,end-N+1:end);

%% Taking FFT
for m = 1:sym_num
    result = [result; fft(sym_matrix(m,:),N)];
end

%% Shifting the FFT result
result = [result(:,N/2+1:end) result(:,1:N/2)];

%% Channel Magnitude Estimation
H = mean(abs(result));
H(1:4) = 0;
H(33) = 0;
H(62:64) = 0;

%% Extracting Pilot Samples
for m = 1:size(pilot_ind,2)
    pilot_sample = [pilot_sample result(:,pilot_ind(m))];
end

%% Compute SNR
SNR = SNR_3(result,pilot_sample,pilot_ind);

%% Signal3 decoding
result_n = result;
for m = 1:size(pgd,2)
    result_n(:,pgd(m)) = [];
end
Result = [];
for m = 1:size(result_n,1)
    Result = [Result result_n(m,:)];
end
message = sig_decoder(Result,2);

