close all; clear; clc;

load('Signal3.mat')
N = 64;
big_sym_t = N+16;
sym_num = size(Signal,2)/(N+16);
signal_matrix = [];
result = [];

for m = 1:sym_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+1:(m*big_sym_t))];
end

sym_matrix = signal_matrix(:,end-N+1:end);

for m = 1:sym_num
    result = [result; fft(sym_matrix(m,:),N)];
end
result = [result(:,N/2+1:end) result(:,1:N/2)];

H = mean(abs(result));
H(1:4) = 0;
H(33) = 0;
H(62:64) = 0;


% % Signal3 decoding
result_n = result;
pgd = [64 63 62 61 53 45 37 33 29 21 13 5 4 3 2 1];
for m = 1:size(pgd,2)
    result_n(:,pgd(m)) = [];
end
Result = result_n;

for m = 1:size(result_n,1)
     for n = 1: size(result_n,2)
         if real(result_n(m,n)) < 0
             if imag(result_n(m,n)) < 0
                 Result(m,n) = 2;
             elseif imag(result_n(m,n)) > 0
                 Result(m,n) = 1;
             end
         elseif real(result_n(m,n)) > 0
             if imag(result_n(m,n)) < 0
                 Result(m,n) = 3;
             elseif imag(result_n(m,n)) > 0
                 Result(m,n) = 0;
             end
         end
     end
end



string = [];
message = [];
message_t = [];

for m = 1:sym_num
    Result_1 = dec2bin(Result(m,:));
    for n = 1:max(size(Result_1))/4
        string = [string ; strcat(Result_1(4*n-3,:),Result_1(4*n-2,:),Result_1(4*n-1,:),Result_1(4*n,:))];
    end
end

string = char(bin2dec(string));
for k = 1:size(string,1)
        message = horzcat(message ,string(k));
end
