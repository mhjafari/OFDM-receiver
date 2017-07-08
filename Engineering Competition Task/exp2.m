close all; clear; clc;

%determine the value of N
        % store the start of the signal
load('Signal2.mat')
%initialize the start index
N_start = 1;                        %initialize the start of the index to 0
N_set=[32,64,128];                  %possible value of ofdm symbol without cyclic prefix(cp)
N_cp = N_set .*(1/4);               %length of cyclic prefix
flg_start = false;
N_fft = 0;
corr_thrshold = 0.9;

while(~(flg_start))
    %check for N = 32
    if(~(flg_start))
        sig_temp1 = real(Signal(1,N_start:N_start+N_cp(1)-1));
        sig_temp2 = real(Signal(1,N_start+N_set(1):N_start+N_set(1)+N_cp(1)-1));
        energy = (sig_temp1*transpose(sig_temp1));
        correlation = (sig_temp1 * transpose(sig_temp2));
        %sim = (sig_temp1*ctranspose(sig_temp1))-(sig_temp1 * ctranspose(sig_temp2));
        %if((sig_temp1 * ctranspose(sig_temp2)) >= sig_temp1*ctranspose(sig_temp1))
        if((energy >= correlation) && (correlation >= corr_thrshold * energy))
            flg_start = true;
            N_fft = 32;
        end 
    end

    %check for N = 64
    if(~(flg_start))
        sig_temp1 = real(Signal(1,N_start:N_start+N_cp(2)-1));
        sig_temp2 = real(Signal(1,N_start+N_set(2):N_start+N_set(2)+N_cp(2)-1));
        energy = (sig_temp1*transpose(sig_temp1));
        correlation = (sig_temp1 * transpose(sig_temp2));
        %sim = (sig_temp1*ctranspose(sig_temp1))-(sig_temp1 * ctranspose(sig_temp2));
        %if((sig_temp1 * ctranspose(sig_temp2)) >= sig_temp1*ctranspose(sig_temp1)*.99)
        if((energy >= correlation) && (correlation >= corr_thrshold * energy))
            flg_start = true;
            N_fft = 64;
        end
    end
        
        %check for N = 128
    if(~(flg_start))
        sig_temp1 = real(Signal(1,N_start:N_start+N_cp(3)-1));
        sig_temp2 = real(Signal(1,N_start+N_set(3):N_start+N_set(3)+N_cp(3)-1));
        energy = (sig_temp1*ctranspose(sig_temp1));
        correlation = (sig_temp1 * ctranspose(sig_temp2));
        %sim = (sig_temp1*ctranspose(sig_temp1))-(sig_temp1 * ctranspose(sig_temp2));
        %if((sig_temp1 * ctranspose(sig_temp2)) >= sig_temp1*ctranspose(sig_temp1)*.99)
        if((energy >= correlation) && (correlation >= corr_thrshold * energy))
            flg_start = true;
            N_fft = 128;
        else
             N_start = N_start+1;
        end
    end
    % to confirm the N_fft
   if(flg_start == true)
           for m = 1:5
             if (flg_start == true)
               temp_cp = N_fft/4;
               cycle = N_fft + temp_cp;
               temp_start = N_start+m*cycle;
               sig_temp3 = real(Signal(1,temp_start:temp_start+temp_cp-1));
               sig_temp4 = real(Signal(1,temp_start+N_fft:temp_start+N_fft+temp_cp-1));
               temp_energy = (sig_temp3 * transpose(sig_temp3));
               temp_correlation = (sig_temp3 * transpose(sig_temp4));
               if ((temp_energy>=temp_correlation) && (temp_correlation >= corr_thrshold * temp_energy))
                  flg_start = true;
               else
                  flg_start = false;
               end
             end
           end
        if(flg_start == false)
            N_start = N_start + 1;
        end
   end

       
    
%     for m = 1:5
%         temp_cp = N_fft/4;
%         cycle = N_fft + temp_cp;
%         temp_start = N_start+m*cycle;
%         sig_temp3 = Signal(1,temp_start:temp_start+temp_cp-1);
%         sig_temp4 = Signal(1,temp_start+N_fft:temp_start+N_fft+temp_cp-1);
%         temp_energy = real(sig_temp3 * ctranspose(sig_temp3));
%         temp_correlation = real(sig_temp3 * ctranspose(sig_temp4));
%         if ((temp_energy>=temp_correlation) && (temp_correlation >= 0.6 * temp_energy))
%             flg_start = true;
%         else
%             flg_start = false;
%         end
   
end
    
        
    

%determine the modulation


%use the pilot planning


% store the useful infomation- concatenating