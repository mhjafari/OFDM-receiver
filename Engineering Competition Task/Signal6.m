close all; clear; clc;

load('Signal6.mat')
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
xx = [];
for j = 1:8
    xx = [xx ; abs(result(j,:))./H];
end

% % Signal3 decoding
% result_n = result;
% result_n(:,33) = [];
% result_n(:,1:4) = [];
% result_n(:,end-2:end) = [];
% Result = result_n;
% 
% for m = 1:size(result_n,1)
%      for n = 1: size(result_n,2)
%          if abs(result_n(m,n)) > 0.2
%              if angle(result_n(m,n)) < pi/8 && angle(result_n(m,n)) > -pi/8
%                  Result(m,n) = 0;
%              elseif angle(result_n(m,n)) < 3*pi/8 && angle(result_n(m,n)) > pi/8
%                  Result(m,n) = 1;
%              elseif angle(result_n(m,n)) < 5*pi/8 && angle(result_n(m,n)) > 3*pi/8
%                  Result(m,n) = 2;
%              elseif angle(result_n(m,n)) < 7*pi/8 && angle(result_n(m,n)) > 5*pi/8
%                  Result(m,n) = 3;
%              elseif angle(result_n(m,n)) < -7*pi/8 || angle(result_n(m,n)) > 7*pi/8
%                  Result(m,n) = 4;
%              elseif angle(result_n(m,n)) < -5*pi/8 && angle(result_n(m,n)) > -7*pi/8
%                  Result(m,n) = 5;
%              elseif angle(result_n(m,n)) < -3*pi/8 && angle(result_n(m,n)) > -5*pi/8
%                  Result(m,n) = 6;
%              elseif angle(result_n(m,n)) < -pi/8 && angle(result_n(m,n)) > -3*pi/8
%                  Result(m,n) = 7;
%              end
%          end
%      end
% end
% 
% 
% string = [];
% Result_2 = [];
% for m = 1:pilot_num
%     Result_1 = dec2bin(Result(m,:));
% end
% 
% for m = 1:max(size(Result_1))
%     Result_2 = strcat(Result_2,Result_1(m,:));
% end
% 
% for m = 1:size(Result_2,2)/8
%     string = [string ; Result_2(1,8*m-7:8*m)];
% end
% 
% message = [];
% string = char(bin2dec(string));
% for m= 1:size(string,1)
%     message = horzcat(message,string(m));
% end
% 
