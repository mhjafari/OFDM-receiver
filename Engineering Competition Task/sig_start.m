clear; close all; clc;

%load the given signal
load('Signal4.mat')

N = 64;
N_cp = N/4;

n_analysis = 2*N+N_cp;
n_corr = n_analysis-N-N_cp+1;
corr_result = zeros(1,n_corr);

for x = 1:n_corr
    temp1 = Signal(x:x+N_cp-1);
    temp2 = Signal(x+N:x+N+N_cp-1);
    corr_result(x) = temp1*conj(temp2)';
end

y= 1:n_corr;