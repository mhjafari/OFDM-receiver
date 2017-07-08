clear; close all; clc;

%load the given signal
load('Signal1.mat')

N = 64;
N_cp = N/4;
result_pilot = [];
result_data = [];
dec_string = [];

b1 = '00';
b2 = '01';
b3 = '10';
b4 = '11';

%size of the signal
sz = size(Signal);
sym_len = 1.25*N;
total_ofdm_symbols = sz(2)/(1.25*N);



%fft of the ofdm symbol
for x= 1:total_ofdm_symbols
    temp_data = Signal(1,x*sym_len-(N-1):x*sym_len);
    temp_symb = fft(temp_data,N);
    %check for pilot symbol
    if(mod(x,2)==1)
        result_pilot = [result_pilot,temp_symb];
    else
        data1 = temp_symb(37:64);
        data2 = temp_symb(2:29);
        result_data = [result_data,data1,data2];
    end
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
% x = 1:sz(2);
% plot(x,Signal);