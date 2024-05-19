%a = arduino('COM3');

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR
analogWrite(a,6,0);
analogWrite(a,9,0);

V_7805 = 5.3;
Vref_arduino = 4.91;


K = calculateKmatrix(3);
k1 = K(1);
k2 = K(2);
kr = k1;

setpos = 5;

positionData = [];
velocityData = [];
timeData = [];

t=0;

% CLOSE ALL PREVIOUS FIGURES FROM SCREEN

close all

%START CLOCK
tic

while(t<10)
    velocity=analogRead(a,3);
    position=analogRead(a,5);

    x1=3*Vref_arduino*position/1024;

    x2=2*(2*velocity*Vref_arduino/1024- V_7805);

   
    u = -k1*x1 - k2*x2 + kr*setpos;

    if u > 0
        if u < 1.1
            u = 1.1;
        end
        analogWrite(a,6,0);
        analogWrite(a,9,min(round(u/2*255/Vref_arduino), 255));
    else
        if u > -1.1
            u = -1.1;
        end
        analogWrite(a,9,0);
        analogWrite(a,6,min(round(-u/2*255/Vref_arduino), 255));
    end

    t=toc;
    
    timeData = [timeData t];
    positionData = [positionData x1];
    velocityData = [velocityData x2];

end

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR 
analogWrite(a,6,0);
analogWrite(a,9,0);


figure
plot(timeData,positionData, timeData, desiredPositionData);

title('position')

figure
plot(timeData,velocityData);
title('velocity')

    
