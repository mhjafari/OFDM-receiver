function [SNR] = SNR_2(result,result_pilot)

result_all = [result ; result_pilot];
result_n = result_all;
%% Channel estimation base on pilots
H_estimated = mean(result_pilot);
H_estimated(:,1:4) = 0;
H_estimated(:,33) = 0;
H_estimated(:,62:64) = 0;

%% Compensating the result signal by removing channel effect
for m = 1:size(result_all,1)
    result_all(m,:) = result_all(m,:) ./H_estimated;
end

%% Start shaping the ideal received signal A
G_DC = [64 63 62 33 4 3 2 1];
for m = 1:size(G_DC,2)
    result_n(:,G_DC(m)) = [];
    result_all(:,G_DC(m))   = [];
end
A = result_n;
for m = 1:size(result_n,1)
     for n = 1: size(result_n,2)
         if abs(result_n(m,n)) > 0.2
             if angle(result_n(m,n)) < pi/8 && angle(result_n(m,n)) > -pi/8
                 A(m,n) = 1;
             elseif angle(result_n(m,n)) < 3*pi/8 && angle(result_n(m,n)) > pi/8
                 A(m,n) = sqrt(2)/2+sqrt(2)/2*1i;
             elseif angle(result_n(m,n)) < 5*pi/8 && angle(result_n(m,n)) > 3*pi/8
                 A(m,n) = 1i;
             elseif angle(result_n(m,n)) < 7*pi/8 && angle(result_n(m,n)) > 5*pi/8
                 A(m,n) = -sqrt(2)/2+sqrt(2)/2*1i;
             elseif angle(result_n(m,n)) < -7*pi/8 || angle(result_n(m,n)) > 7*pi/8
                 A(m,n) = -1;
             elseif angle(result_n(m,n)) < -5*pi/8 && angle(result_n(m,n)) > -7*pi/8
                 A(m,n) = -sqrt(2)/2-sqrt(2)/2*1i;
             elseif angle(result_n(m,n)) < -3*pi/8 && angle(result_n(m,n)) > -5*pi/8
                 A(m,n) = -1i;
             elseif angle(result_n(m,n)) < -pi/8 && angle(result_n(m,n)) > -3*pi/8
                 A(m,n) = sqrt(2)/2-sqrt(2)/2*1i;
             end
         end
     end
end

%% Computing the SNR
Noise = A - result_all;
A_2 = abs(A).^2;
Noise_2 = abs(Noise).^2;
SNR = sum(sum(A_2))/sum(sum(Noise_2));
end