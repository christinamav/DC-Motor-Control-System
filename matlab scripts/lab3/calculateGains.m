function [k1, k2, ki] = calculateGains(l1, l2, l3)
    km = 1/36;
    Tm = 0.48;
    kt = 0.00369;
    kM = 228.73;
    k0 = 0.229;

    p1 = l1 + l2 +l3;
    p2 = l1*l2 + l2*l3 + l1*l3;
    p3 = l1*l2*l3;

    k1 = (Tm*p2)/(km*kM*k0);
    k2 = (Tm*p1-1)/(kM*kt);
    ki = (Tm*p3)/(kM*km*k0);

end

