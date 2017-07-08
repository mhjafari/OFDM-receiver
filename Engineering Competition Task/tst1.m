close all; clear; clc;

%load the given signal
load('Signal1.mat')


%size of the signal
sz = size(Signal);
% 
% %plot the signal
% x = 1:sz(2);
% %plot(x,abs(Signal))
% stem(x,abs(Signal))


% a1 = sqrt(2) + 1i*sqrt(2);
% a2 = -sqrt(2) + 1i*sqrt(2);
% a3 = -sqrt(2) - 1i*sqrt(2);
% a4 = sqrt(2) - 1i*sqrt(2);
% 
% b1 = '00';
% b2 = '01';
% b3 = '10';
% b4 = '11';
% 
% sym = [a1,a2,a3,a4];
% 
% tmp_str = strcat(b2,b2,b2,b1);
% k = bin2dec(tmp_str);
% char(k);

