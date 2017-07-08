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


m = length(Signal);
Signal = Signal.*exp(-1i*2*pi*(0+6:m-1+6)*(0.01123873));
% Signal = Signal.*exp(-1i*2*pi*(0:m-1)*(-0.007198563349830)-1i*0.0088);

for m = 1:max(size(Signal))
    if abs(Signal(m)) > 0.6
        pilot_num = pilot_num +1;
        pilot_matrix = [pilot_matrix; Signal(m-16:m+63)];
        signal_matrix = [signal_matrix; Signal(m+64:m+143)];
    end
end

A = mean(mean(angle(signal_matrix(:,1:16)./signal_matrix(:,65:80))));
% A = angle(signal_matrix(:,1:16)./signal_matrix(:,65:80));�
% A1= mean(mean(angle(pilot_matrix(:,5:10)./pilot_matrix(:,69:74))));
% A2 = mean([A A1]);
offset = (A)/(2*pi*64);
CP = 16;
sh_dat = Signal((CP+1):64+CP);
for m=0:32
theta(m+1) = angle(sh_dat(17+m:32+m)*sh_dat(1+m:16+m)')/(2*pi);
end
theta = mean(theta);
f_off1 = (theta*4)/64;


for m = 1:pilot_num
    result = [result; fft(signal_matrix(m,17:80),N)];
    result_pilot = [result_pilot; fft(pilot_matrix(m,17:80),N)];
end
result = [result(:,N/2-1:end) result(:,1:N/2-2)];
% B = reshape(result,2048,1);
result_pilot = [result_pilot(:,N/2-1:end) result_pilot(:,1:N/2-2)];
% B1 = reshape(result_pilot,2048,1);
H = mean(abs(result));

% Signal4 decoding
result_n = result;
pgd = [64 63 62 33 4 3 2 1];
for m = 1:size(pgd,2)
    result_n(:,pgd(m)) = [];
end
B2 = reshape(result_n,1792,1);
% message = sig_decoder(reshape(result_n,1792,1),1);

for m = 1:size(result_n,1)
     for n = 1: size(result_n,2)
         if real(result_n(m,n)) < 0
                 Result(m,n) = 1;
         elseif real(result_n(m,n)) > 0
                 Result(m,n) = 0;
         end
     end
end

string = [];
message = [];
message_t = [];
Result_1 = dec2bin(Result);

for n = 1:max(size(Result_1))/8
    string = [string ; strcat(Result_1(8*n-7),Result_1(8*n-6),Result_1(8*n-5),Result_1(8*n-4),Result_1(8*n-3),Result_1(8*n-2),Result_1(8*n-1),Result_1(8*n))];
end
% Result_1 = [];
% Result_1 = string(:,8);
% string = [];
% for n = 1:max(size(Result_1))/8
%     string = [string ; strcat(Result_1(8*n-7),Result_1(8*n-6),Result_1(8*n-5),Result_1(8*n-4),Result_1(8*n-3),Result_1(8*n-2),Result_1(8*n-1),Result_1(8*n))];
% end
string = char(bin2dec(string));
for k = 1:size(string,1)
        message = horzcat(message ,string(k));
end

