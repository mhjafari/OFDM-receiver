function [message,dec_string] = sig_decoder(result_vect,mod_type)
str1 = blanks(1);

%string for bpsk
if(mod_type ==1)
    for x = 1:length(result_vect)
        if ( real(result_vect(x)) > 0)
            str1 = strcat(str1,'0');
        else
            str1 = strcat(str1,'1');
        end
    end
end
          
 %string for qpsk
 if (mod_type ==2)
     for x = 1:length(result_vect)
         if ( real(result_vect(x)) > 0)
             if ( imag( result_vect(x)) > 0 )
                 str1 = strcat(str1,'00');
             else
                 str1 = strcat(str1,'11');
             end
         elseif ( imag( result_vect(x) ) > 0)
              str1 = strcat(str1,'01');
         else
             str1 = strcat(str1,'10');
         end
     end
 end

 %string for 8psk
 if (mod_type ==3)
  for x = 1:length(result_vect)
    if ( (angle(result_vect(x)) < pi/8) && (angle(result_vect(x)) > -pi/8) ) 
        str1 = strcat(str1,'000');
    elseif ( (angle(result_vect(x)) > pi/8) &&  (angle(result_vect(x)) < 3*pi/8) )
        str1 = strcat(str1, '001');
    elseif ( (angle(result_vect(x)) > 3*pi/8) &&  (angle(result_vect(x)) < 5*pi/8) )
        str1 = strcat(str1, '010');
    elseif ( (angle(result_vect(x)) > 5*pi/8) &&  (angle(result_vect(x)) < 7*pi/8) )
        str1 = strcat(str1, '011');   
    elseif ( (angle(result_vect(x)) > 7*pi/8) ||  (angle(result_vect(x)) < -7*pi/8) )
        str1 = strcat(str1, '100');
    elseif ( (angle(result_vect(x)) > -7*pi/8) &&  (angle(result_vect(x)) < -5*pi/8) )
        str1 = strcat(str1, '101');
    elseif ( (angle(result_vect(x)) > -5*pi/8) &&  (angle(result_vect(x)) < -3*pi/8) )
        str1 = strcat(str1, '110');
    elseif ( (angle(result_vect(x)) > -3*pi/8) &&  (angle(result_vect(x)) < -pi/8) )
        str1 = strcat(str1, '111');
    end
  end
 end
 
 %converting string to decimal vector
 num_lettr = int64(length(str1)/8);
 %dec_string = zeros(1,num_lettr);
 dec_string = [];
 y_start = 1;
for y = 1:num_lettr
    temp_dec = bin2dec(strcat(str1(y_start:y_start+7)));
    dec_string = [dec_string,temp_dec];
    y_start = (y*8) +1;
end

message = char(dec_string);

%disp(message);
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

