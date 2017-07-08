clear; close all; clc;

%load the given signal
load('Signal3.mat')

N = 64;
N_cp = N/4;
result_guard = [];
result_pilot = [];
result_data = [];
dec_string = [];

%size of the signal
sz = size(Signal);
sym_len = 1.25*N;
total_ofdm_symbols = sz(2)/(1.25*N);

%qpsk symbols
b1 = '00';
b2 = '01';
b3 = '10';
b4 = '11';

%fft 
for x = 1:total_ofdm_symbols
    temp_data = Signal(1,x*sym_len-(N-1):x*sym_len);
    temp_symb = fft(temp_data,N);
    %store guard and dc
    result_guard = [result_guard,temp_symb(33:36),temp_symb(1),temp_symb(30:32)];
    %store pilot
    result_pilot = [result_pilot,temp_symb(37),temp_symb(45),temp_symb(53),temp_symb(61),temp_symb(5),temp_symb(13),temp_symb(21),temp_symb(29)];
    %store data
    result_data = [result_data,temp_symb(38:44),temp_symb(46:52),temp_symb(54:60),temp_symb(62:64),temp_symb(2:4),temp_symb(6:12),temp_symb(14:20),temp_symb(22:28)];
end

str1 = blanks(1);
% %decoding
for y = 1:length(result_data)
    if ( real(result_data(y)) > 0)
        if(imag(result_data(y)) > 0)
            str1 = strcat(str1,b1);
        else
            str1 = strcat(str1,b4);
        end
    elseif ( imag(result_data(y)) > 0)
        str1 = strcat(str1,b2);
    else
        str1 = strcat(str1,b3);
    end
   
    if(mod(y,4)==0)
        temp_dec = bin2dec(strcat(str1));
        dec_string = [dec_string,temp_dec];
        str1 = blanks(1);
    end
        
end
message = sig_decoder(result_data,2);

%plot the signal
%  x = 1:sz(2);
%  plot(x,Signal);