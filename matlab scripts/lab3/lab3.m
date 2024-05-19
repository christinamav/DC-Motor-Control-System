%a = arduino('COM3');

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);

V_7805 = 5.3;
Vref_arduino = 4.91;

[k1,k2, ki] = calculateGains(4, 5, 6);

setpos = 5;

positionData = [];
velocityData = [];
zData = [];
timeData = [];


t=0;
n = 0; %sampling variable


% CLOSE ALL PREVIOUS FIGURES FROM SCREEN

close all

%START CLOCK
tic

while(t<5)
    n = n + 1;
    velocity=analogRead(a,3);
    position=analogRead(a,5);

    x1=3*Vref_arduino*position/1024;

    x2=2*(2*velocity*Vref_arduino/1024- V_7805);
    
    z_dot = x1 - setpos;

    if n == 1
        zData(n) = 0;
    else
        Dt = toc - t;
        zData(n) = zData(n-1) + Dt*z_dot;
    end
    
    z = zData(n);
    u = -k1*x1 - k2*x2 -ki*z;

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
plot(timeData,positionData);

title('position')

figure
plot(timeData,velocityData);
title('velocity')

    
