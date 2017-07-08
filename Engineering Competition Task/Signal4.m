close all; clear; clc;

load('Signal4.mat')
N = 64;

pilot_num = 0;
signal_matrix = [];
pilot_matrix = [];
result = [];
result_pilot = [];
result_all = [];

for m = 1:size(Signal,2)
    Signal(m) = Signal(m) * exp(-1i*2*pi/64*(m-1)*(-0.279593));
end

for m = 1:max(size(Signal))
    if abs(Signal(m)) > 0.6
        pilot_num = pilot_num +1;
        pilot_matrix = [pilot_matrix; Signal(m-15:m+48)];
        signal_matrix = [signal_matrix; Signal(m+64:m+143)];
    end
end


phase = [];
for n = 1:size(signal_matrix,1)
    phase = [phase 1/(2*pi)*angle(mean(conj(signal_matrix(n,1:16)) .* signal_matrix(n,end-15:end)))];
end
phase = mean(phase);

for m = 1:pilot_num
    result = [result; fft(signal_matrix(m,:),N)];
    result_pilot = [result_pilot; fft(pilot_matrix(m,:),N)];
end
result = [result(:,N/2:end) result(:,1:N/2-1)];

% result_pilot = [result_pilot(:,N/2+1:end) result_pilot(:,1:N/2)];

% H = mean(abs(result));

% Signal4 decoding
result_n = result;
pgd = [64 63 62 33 4 3 2 1];
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
