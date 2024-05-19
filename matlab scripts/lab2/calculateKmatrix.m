function K = calculateKmatrix(zero)
    km = 1/36;
    Tm = 0.48;
    kt = 0.00369;
    kM = 228.73;
    k0 = 0.229; 

    doublepole = -zero - zero*sqrt(1 - 1/(zero*Tm));
    k2 = -(Tm*doublepole*(doublepole + 1/Tm))/(kM*kt*(doublepole + zero));
    k1 = (zero*k2*kt)/(km*k0);
    
    K = [k1 , k2];
end