close all; clear; clc;

load('Signal2.mat')
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
result_all = [result; result_pilot];
H = mean(abs(result_all));
H(1:4) = 0;
H(33) = 0;
H(62:64) = 0;

% Signal2 decoding
result_n = result;
result_n(:,33) = [];
result_n(:,1:4) = [];
result_n(:,end-2:end) = [];
Result = result_n;

for m = 1:size(result_n,1)
     for n = 1: size(result_n,2)
         if abs(result_n(m,n)) > 0.1
             if angle(result_n(m,n)) < pi/8 && angle(result_n(m,n)) > -pi/8
                 Result(m,n) = 0;
             elseif angle(result_n(m,n)) < 3*pi/8 && angle(result_n(m,n)) > pi/8
                 Result(m,n) = 1;
             elseif angle(result_n(m,n)) < 5*pi/8 && angle(result_n(m,n)) > 3*pi/8
                 Result(m,n) = 2;
             elseif angle(result_n(m,n)) < 7*pi/8 && angle(result_n(m,n)) > 5*pi/8
                 Result(m,n) = 3;
             elseif angle(result_n(m,n)) < -7*pi/8 || angle(result_n(m,n)) > 7*pi/8
                 Result(m,n) = 4;
             elseif angle(result_n(m,n)) < -5*pi/8 && angle(result_n(m,n)) > -7*pi/8
                 Result(m,n) = 5;
             elseif angle(result_n(m,n)) < -3*pi/8 && angle(result_n(m,n)) > -5*pi/8
                 Result(m,n) = 6;
             elseif angle(result_n(m,n)) < -pi/8 && angle(result_n(m,n)) > -3*pi/8
                 Result(m,n) = 7;
             end
         end
     end
end


string = [];
Result_t2 = [];
Result_t1 = [];
for m = 1:size(Result,1)
    Result_t1 = [Result_t1 ;dec2bin(Result(m,:))];
end
for m = 1:size(Result_t1,1)/2
    Result_t2 = [Result_t2 ; strcat(Result_t1(2*m-1,:),Result_t1(2*m,:))];
end

Result_t1 = [];
for m = 1:size(Result_t2,1)/4
    Result_t1 = [Result_t1 ; strcat(Result_t2(4*m-3,:),Result_t2(4*m-2,:),Result_t2(4*m-1,:),Result_t2(4*m,:))];
end
Result_t2 = [];
for m = 1:size(Result_t1,1)
    Result_t2 = [Result_t2 ;Result_t1(m,1:8) ; Result_t1(m,9:16);Result_t1(m,17:24)];
end
% for m = 1:size(Result_2,2)/8
%     string = [string ; Result_2(1,8*m-7:8*m)];
% end
% 
message = [];
string = char(bin2dec(Result_t2));
for k = 1:size(string,1)
        message = horzcat(message ,string(k));
end
