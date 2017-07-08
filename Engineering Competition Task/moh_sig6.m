close all; clear; clc;

load('Signal6.mat')
N = 128;
CP = 32;
big_sym_t = N+32;

signal_matrix = [];
result = [];
Signal(1:44) = [];
coeff = [];

sym_num = (size(Signal,2))/(big_sym_t);
pilot = [4 13 21 30];

m = length(Signal);
Signal = Signal.*exp(-1i*2*pi*(0:m-1)*(-0.001552545962187));

for m = 1:sym_num
    signal_matrix = [signal_matrix; Signal(((m-1)*big_sym_t)+1:(m*big_sym_t))];
end
%%
A = mean(mean(angle(signal_matrix(:,1:CP)./signal_matrix(:,N+1:N+CP))));
%A1= mean(mean(angle(pilot_matrix(:,5:10)./pilot_matrix(:,69:74))));
%A2 = mean([A A1]);
offset = A/(2*pi*128);
%%
sym_matrix = signal_matrix(:,end-N+1:end);
for m = 1:sym_num
    result = [result; fft(sym_matrix(m,:),N)];
end
result = [result(:,end-18:end) result(:,1:end-19)];
result(:,33:end) = [];
pilot_sample = [];

for m = 1:size(pilot,2)
    pilot_sample = [pilot_sample result(:,pilot(m))];
end
for m = 1:size(pilot_sample,1)
    coeff = [coeff ; polyfit(pilot,angle(pilot_sample(m,:)),1)];
    if coeff(m,1) > 0
        coeff(m,:) = polyfit(pilot,wrapTo2Pi(angle(pilot_sample(m,:))),1);
    end
end

for m = 1:size(result,1)
    result(m,:) = result(m,:).* exp(-1i*(coeff(m,1)*(0:31)+coeff(m,2)));
end
pilot_sample = [];
for m = 1:size(pilot,2)
    pilot_sample = [pilot_sample result(:,pilot(m))];
end

const_phase = [];
for m = 1:size(pilot_sample,1)
    const_phase = [const_phase;mean(angle(pilot_sample(m,:)))];
end
for m = 1:size(result,1)
    result(m,:) = result(m,:).* exp(-1i*const_phase(m));
end
pilot_sample = [];
for m = 1:size(pilot,2)
    pilot_sample = [pilot_sample result(:,pilot(m))];
end
%%
alpha = [];
beta = [];
alpha = (pilot_sample(1,3)*1+pilot_sample(1,4)*1);

result_n = result;


% Signal6 decoding

pgd = [32 31 30 21 17 13 4 3 2 1];
for m = 1:size(pgd,2)
    result_n(:,pgd(m)) = [];
end
B = reshape(result_n,52*22,1);
B1 = reshape(result,52*32,1);
 message = sig_decoder(reshape(result_n,52*22,1),2);
% Result = result_n;