close all; clear; clc;

load('Signal5.mat')
N = 64;
big_sym_t = N+16;
sym_num = (size(Signal,2)-18)/(N+16);
signal_matrix = [];
result = [];

for m = 1:size(Signal,2)
    Signal(m) = Signal(m) * exp(-1i*2*pi/64*(m-1)*(-0.1670));
end

for m = 1:sym_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+19:(m*big_sym_t)+18)];
end
phase = [];
phase = 1/(2*pi)*angle(mean(conj(signal_matrix(1,1:16)) .* signal_matrix(1,end-15:end)));

sym_matrix = signal_matrix(:,end-N+1:end);

for m = 1:sym_num
    result = [result; fft(sym_matrix(m,:),N)];
end
result = [result(:,N/2+2:end) result(:,1:N/2+1)];


% % Signal5 decoding
result_n = result;
pgd = [64 63 62 61 53 45 37 33 29 21 13 5 4 3 2 1];
for m = 1:size(pgd,2)
    result_n(:,pgd(m)) = [];
end
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
