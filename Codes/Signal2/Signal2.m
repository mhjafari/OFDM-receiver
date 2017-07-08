close all; clear; clc;

load('Signal2.mat')
N = 64;
pilot_num = 0;
signal_matrix = [];
result = [];
result_pilot = [];
result_n = [];

%% Find the number of pilots
for m = 1:max(size(Signal))
    if abs(Signal(m)) > 0.6
        pilot_num = pilot_num +1;
    end
end

big_sym_t = max(size(Signal))/pilot_num;

%% Divide signal into concatenated pilot and data
for m = 1:pilot_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+1:(m*big_sym_t))];
end

%% Removing Cyclic Prefix and seperate pilot from data
sym_matrix = signal_matrix(:,end-N+1:end);
pilot_matrix = signal_matrix(:,17:80);

%% Taking FFT from pilots and symbol matrix
for m = 1:pilot_num
    result = [result; fft(sym_matrix(m,:),N)];
end

for m = 1:pilot_num
    result_pilot = [result_pilot; fft(pilot_matrix(m,:),N)];
end

%% Shifting the FFT result
result = [result(:,N/2+1:end) result(:,1:N/2)];
result_pilot = [result_pilot(:,N/2+1:end) result_pilot(:,1:N/2)];

%% Channel Magnitude Estimation
result_all = [result; result_pilot];
H = mean(abs(result_all));
H(1:4) = 0;
H(33) = 0;
H(62:64) = 0;

%% Compute SNR
SNR = SNR_2(result,result_pilot);

%% Signal2 decoding
result(:,33) = [];
result(:,1:4) = [];
result(:,end-2:end) = [];
for m = 1:size(result,1)
    result_n = [result_n result(m,:)];
end
message = sig_decoder(result_n,3);

