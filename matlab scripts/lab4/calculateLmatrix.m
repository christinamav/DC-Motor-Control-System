function L = calculateLmatrix(l1,l2)
    km = 1/36;
    Tm = 0.48;
    kt = 0.00369;
    kM = 228.73;
    k0 = 0.229;    

    p1 = l1 + l2;
    p2 = l1*l2;

    L = [p1 - 1/Tm; -(p1 - 1/Tm)*kt/(km*k0*Tm) + p2*kt/(km*k0)];
    
end