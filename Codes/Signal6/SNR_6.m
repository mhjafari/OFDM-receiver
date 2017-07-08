function [SNR] = SNR_6(result,pilot_sample,pilot_ind)

H_estimated = [];
result_n = result;

%% Interpolation of channel estimation base on pilots
for m = 1:size(pilot_sample,1)
    H_estimated = [H_estimated ; interp1(pilot_ind,pilot_sample(m,:),1:32,'spline')];
end
H_estimated(:,1:3) = 0;
H_estimated(:,17) = 0;
H_estimated(:,31:32) = 0;
H_estimated = mean(H_estimated);

%% Compensating the result signal by removing channel effect
for m = 1:size(result,1)
    result(m,:) = result(m,:) ./H_estimated;
end

%% Start shaping the ideal received signal A
A = result_n;
a = sqrt(2)/2;
for m = 1:size(result_n,1)
     for n = 1: size(result_n,2)
         if real(result_n(m,n)) < 0
             if imag(result_n(m,n)) < 0
                 A(m,n) = -a-a*1i;
             elseif imag(result_n(m,n)) > 0
                 A(m,n) = -a+a*1i;
             end
         elseif real(result_n(m,n)) > 0
             if imag(result_n(m,n)) < 0
                 A(m,n) = a-a*1i;
             elseif imag(result_n(m,n)) > 0
                 A(m,n) = a+a*1i;
             end
         else
             A(m,n) = 1;
         end
     end
end

for m = 1:size(pilot_ind,2)
    A(:,pilot_ind(m)) = 1;
end

G_DC = [32 31 17 3 2 1];
for m = 1:size(G_DC,2)
    A(:,G_DC(m)) = [];
    result(:,G_DC(m))   = [];
end
%% Computing the SNR
Noise = A - result;
A_2 = abs(A).^2;
Noise_2 = abs(Noise).^2;
SNR = sum(sum(A_2))/sum(sum(Noise_2));
end
