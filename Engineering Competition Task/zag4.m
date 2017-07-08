clear; close all; clc;

%load the given signal
load('Signal4.mat')
signal = Signal;
signal (1:23) = [];
%N_offset = 23;
N = 64;
N_cp = N/4;
result_guard = [];
result_pilot = [];
result_data = [];
dec_string = [];

%size of the signal
sz = size(signal);
sym_len = 1.25*N;
total_ofdm_symbols =  int64(sz(2)/(1.25*N));
%est_offset_vect = zeros(1,total_ofdm_symbols);
est_offset_vect = [];
k = 0;

% for x = 1:2:29
%     r_k = signal(1,x*sym_len-(N-1):x*sym_len);
%     r_jk = signal(1,(x+1)*sym_len-(N-1):(x+1)*sym_len);
%     est_offset_vect = [est_offset_vect,angle((r_k/r_jk))/(2*pi*160)];
% end
        
    

%carrier frequency estimation
% for x = 1:total_ofdm_symbols
%         r_k = signal(1,(x-1)*sym_len+1:x*sym_len-N);
%         r_jk = signal(1,x*sym_len-(N_cp-1):x*sym_len);
%         %est_offset_vect(x) = angle((r_k/r_jk))/(2*pi*64);
%     
%         est_offset_vect(x) = angle(r_k * (conj(r_jk))')/(2*pi*N);
% end
%fft of the ofdm symbol
%est_offset = mean(est_offset_vect);
est_offset = 0.01123;
signal = signal.*exp(-1i*2*pi*est_offset*(0:length(signal)-1));

for x= 1:total_ofdm_symbols
    temp_data = signal(1,x*sym_len-(N-1):x*sym_len); %.* exp(-1i*2*pi*est_offset_vect(x)*(23+:63));  
    temp_symb = fft(temp_data,N);
    %check for pilot symbol
    if(mod(x,2)==1)
        result_pilot = [result_pilot,temp_symb];
    else
%         data1 = temp_symb(37:64);
%         data2 = temp_symb(2:29);
          data2 = temp_symb(64);
          data3 = temp_symb(1:27);
          data1 = temp_symb(35:62);
        result_data = [result_data,data1,data2,data3];
    end
end

[message,str1] = sig_decoder(result_data,1);











% %fft of the ofdm symbol
% for x= 1:total_ofdm_symbols
%     temp_data1 = Signal(1,(N_offset+(x*sym_len))-(N-1):(N_offset+(x*sym_len)));
%     %to calculate carrier offset
%     temp_cp = Signal(1,(N_offset+(x*sym_len))-(sym_len-1):(N_offset+(x*sym_len))-N);
%     temp_cp_copy = Signal(1,(N_offset+(x*sym_len))-(N_cp-1):(N_offset+(x*sym_len)));
%     temp_beta = angle(conj(temp_cp).*temp_cp_copy);
%     for y = 1:N_cp
%         if (temp_beta(y) < 0)
%             temp_beta(y) = temp_beta(y)+2*pi;
%         end
%     end
%     estimate_beta = mean(temp_beta)/(2*pi);
%     temp_data = temp_data1 .* exp(-1i*2*pi*estimate_beta*(1:N));
%     temp_symb = fft(temp_data,N);
%     %check for pilot symbol
%     if(mod(x,2)==1)
%         result_pilot = [result_pilot,temp_symb];
%     else
%         data1 = temp_symb(37:64);
%         data2 = temp_symb(2:29);
%         result_data = [result_data,data1,data2];
%     end
% end

%scatterplot(result_data);
%scatterplot(result_pilot);
%plot the signal
% x = 1:sz(2);
% plot(x,abs(Signal));