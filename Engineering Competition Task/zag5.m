clear; close all; clc;

%load the given signal
load('Signal5.mat')

N = 64;
N_cp = N/4;
result_guard = [];
result_pilot = [];
result_data = [];
dec_string = [];

signal = Signal;
signal(1:18) = [];

%size of the signal
sz = size(signal);
sym_len = 1.25*N;
total_ofdm_symbols = sz(2)/(1.25*N);

%offset
est_offset = -0.002641;
signal = signal.*exp(-1i*2*pi*est_offset*(0:length(signal)-1));
%total_ofdm_symbols
for x = 1:28
    temp_data = signal(1,x*sym_len-(N-1):x*sym_len);
    temp_symb = fft(temp_data,N);
    %store guard and dc
    result_guard = [result_guard,temp_symb(33:36),temp_symb(1),temp_symb(30:32)];
    %store pilot
    result_pilot = [result_pilot,temp_symb(37),temp_symb(45),temp_symb(53),temp_symb(61),temp_symb(5),temp_symb(13),temp_symb(21),temp_symb(29)];
    %store data
    result_data = [result_data,temp_symb(38:44),temp_symb(46:52),temp_symb(54:60),temp_symb(62:64),temp_symb(2:4),temp_symb(6:12),temp_symb(14:20),temp_symb(22:28)];
end
