clc;
A = result;
for m = 1:size(result,1)
     for n = 1: size(result,2)
         if abs(result(m,n)) > 0.2
             if angle(result(m,n)) < pi/8 && angle(result(m,n)) > -pi/8
                 A(m,n) = 1;
             elseif angle(result(m,n)) < 3*pi/8 && angle(result(m,n)) > pi/8
                 A(m,n) = sqrt(2)/2+sqrt(2)/2*1i;
             elseif angle(result(m,n)) < 5*pi/8 && angle(result(m,n)) > 3*pi/8
                 A(m,n) = 1i;
             elseif angle(result(m,n)) < 7*pi/8 && angle(result(m,n)) > 5*pi/8
                 A(m,n) = -sqrt(2)/2+sqrt(2)/2*1i;
             elseif angle(result(m,n)) < -7*pi/8 || angle(result(m,n)) > 7*pi/8
                 A(m,n) = -1;
             elseif angle(result(m,n)) < -5*pi/8 && angle(result(m,n)) > -7*pi/8
                 A(m,n) = -sqrt(2)/2-sqrt(2)/2*1i;
             elseif angle(result(m,n)) < -3*pi/8 && angle(result(m,n)) > -5*pi/8
                 A(m,n) = -1i;
             elseif angle(result(m,n)) < -pi/8 && angle(result(m,n)) > -3*pi/8
                 A(m,n) = sqrt(2)/2-sqrt(2)/2*1i;
             end
         else
             A(m,n) = 0;
         end
     end
end

Noise = A - result;
A_2 = abs(A).^2;
Noise_2 = abs(Noise).^2;
SNR_val = sum(sum(A_2))/sum(sum(Noise_2));

