%a = arduino('COM3');

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR 
analogWrite(a,6,0);
analogWrite(a,9,0);

km = 1/36;
Tm = 0.48;
kt = 0.00369;
kM = 228.73;
k0 = 0.229;    

V_7805 = 5.3;
Vref_arduino = 4.91;

L = calculateLmatrix(25, 28);
A = [0 km*k0/kt; 0 -1/Tm];
C = [1 0];
B = [0; kM*kt/Tm];
estimErrorMatrix = A - L*C;

positionData = [];
velocityData = [];
estimatedPositionData = [];
estimatedVelocityData = [];
outputData = [];
inputData = [];
timeData = [];


t=0;
n = 0; %sampling variable

% CLOSE ALL PREVIOUS FIGURES FROM SCREEN

close all

%START CLOCK
tic

while(t<5)
    n = n + 1;

    u = 7;
    analogWrite(a,6,0);
    analogWrite(a,9,min(round(u/2*255/Vref_arduino), 255));

    
    velocity=analogRead(a,3);
    position=analogRead(a,5);

    x1=3*Vref_arduino*position/1024;

    x2=2*(2*velocity*Vref_arduino/1024- V_7805);
    
    sysOutput = x1;
    sysInput = 7;

    Dt = toc - t;
    transitionMatrix = expm(estimErrorMatrix*Dt); 
    
    if n==1
        estimatedStateVariables = inv(estimErrorMatrix)*(transitionMatrix - eye(2))*(B*sysInput + L*sysOutput);
    else
        estimatedStateVariables = transitionMatrix*[estimatedPositionData(n-1) ; estimatedVelocityData(n-1)] + inv(estimErrorMatrix)*(transitionMatrix - eye(2))*(B*sysInput + L*sysOutput);
    end

    t=toc;
    
    timeData = [timeData t];
    positionData = [positionData x1];
    velocityData = [velocityData x2];
    outputData = [outputData sysOutput];
    estimatedPositionData = [estimatedPositionData estimatedStateVariables(1)];
    estimatedVelocityData = [estimatedVelocityData estimatedStateVariables(2)];


end

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR
analogWrite(a,6,0);
analogWrite(a,9,0);


figure
plot(timeData,positionData, timeData, estimatedPositionData);

title('position')

figure
plot(timeData,velocityData, timeData, estimatedVelocityData);
title('velocity')

