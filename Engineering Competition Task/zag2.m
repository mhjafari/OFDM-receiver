clear; close all; clc;

%load the given signal
load('Signal2.mat')

N = 64;
N_cp = N/4;
result_pilot = [];
result_data = [];
dec_string = [];

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

%decoding into binary
str1 = blanks(1);

for x = 1:length(result_data)
    if ( (angle(result_data(x)) < pi/8) && (angle(result_data(x)) > -pi/8) ) 
        str1 = strcat(str1,'000');
    elseif ( (angle(result_data(x)) > pi/8) &&  (angle(result_data(x)) < 3*pi/8) )
        str1 = strcat(str1, '001');
    elseif ( (angle(result_data(x)) > 3*pi/8) &&  (angle(result_data(x)) < 5*pi/8) )
        str1 = strcat(str1, '010');
    elseif ( (angle(result_data(x)) > 5*pi/8) &&  (angle(result_data(x)) < 7*pi/8) )
        str1 = strcat(str1, '011');   
    elseif ( (angle(result_data(x)) > 7*pi/8) ||  (angle(result_data(x)) < -7*pi/8) )
        str1 = strcat(str1, '100');
    elseif ( (angle(result_data(x)) > -7*pi/8) &&  (angle(result_data(x)) < -5*pi/8) )
        str1 = strcat(str1, '101');
    elseif ( (angle(result_data(x)) > -5*pi/8) &&  (angle(result_data(x)) < -3*pi/8) )
        str1 = strcat(str1, '110');
    elseif ( (angle(result_data(x)) > -3*pi/8) &&  (angle(result_data(x)) < -pi/8) )
        str1 = strcat(str1, '111');
    end
end
 
%binay to text
num_lettr = length(str1)/8;

y_start = 1;
for y = 1:num_lettr
    temp_dec = bin2dec(strcat(str1(y_start:y_start+7)));
    dec_string = [dec_string,temp_dec];
    y_start = (y*8) +1;
end

message = sig_decoder(result_data,3);
    
% bin to decimal
% 97 102

    
    
    
    
    
    
    
    
    
    
    