close all; clear; clc;

load('Signal1.mat')
N = 64;
pilot_num = 0;
signal_matrix = [];
result = [];
result_pilot = [];

for m = 1:max(size(Signal))
    if abs(Signal(m)) > 0.6
        pilot_num = pilot_num +1;
    end
end


big_sym_t = max(size(Signal))/pilot_num;


for m = 1:pilot_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+1:(m*big_sym_t))];
end


sym_matrix = signal_matrix(:,end-N+1:end);
pilot_matrix = signal_matrix(:,1:64);
for m = 1:pilot_num
    result = [result; fft(sym_matrix(m,:),N)];
end
for m = 1:pilot_num
    result_pilot = [result_pilot; fft(pilot_matrix(m,:),N)];
end
result = [result(:,N/2+1:end) result(:,1:N/2)];
result_pilot = [result_pilot(:,N/2+1:end) result_pilot(:,1:N/2)];

% Signal1 decoding
Result = result;
for m = 1:size(result,1)
     for n = 1: size(result,2)
         if real(result(m,n)) < -0.5
             if imag(result(m,n)) < -0.5
                 Result(m,n) = 2;
             elseif imag(result(m,n)) > 0.5
                 Result(m,n) = 1;
             end
         elseif real(result(m,n)) > 0.5
             if imag(result(m,n)) < -0.5
                 Result(m,n) = 3;
             elseif imag(result(m,n)) > 0.5
                 Result(m,n) = 0;
             end
         end
     end
end

Result(:,33) = [];
Result(:,1:4) = [];
Result(:,end-2:end) = [];
string = [];
message = [];
message_t = [];

for m = 1:pilot_num
    Result_1 = dec2bin(Result(m,:));
    for n = 1:max(size(Result_1))/4
        string = [string ; strcat(Result_1(4*n-3,:),Result_1(4*n-2,:),Result_1(4*n-1,:),Result_1(4*n,:))];
    end
end

string = char(bin2dec(string));
for k = 1:size(string,1)
        message = horzcat(message ,string(k));
end


