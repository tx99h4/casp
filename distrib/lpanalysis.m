% synthesis.m 
% FIR synthesis function for integer data
% compute error based upon prediction coefficients
% syntax : [q,y] = lpanalysis(X, n)
%
%         X : block to analyse (int16 data)
%         n : FIR order
%         q : quantized lp (int16 data)
%         y : resulting block (int16 data)
%
% (c) copyright 2010, Muhiy-eddine Cherik
function [q,y] = lpanalysis(X, n)

    % find the best coefficients
    k = lpc(fix(double(X)), n);
    
    p = 128; % = 2^7
    
    % convert to PARCOR coefficients
    k = poly2rc(k);
    
    % compand k1 & k2
    k(1) = log((1+k(1))/(1-k(1)));
    k(2) = log((1+k(2))/(1-k(2)));
    
    % quantize
    q = short16(k*p);
    
    % inv quantize
    k = fix(double(q))/p;
    
    % expand k1 & k2
    k(1) = (exp(k(1)) - 1) / (exp(k(1)) + 1);
    k(2) = (exp(k(1)) - 1) / (exp(k(1)) + 1);
    
    % convert to lp coefficients
    k = rc2poly(k);
    k = k(2:end);
    
    % compute residue
    %y = X - short16(filter(-[0 k], 1, fix(double(X))));
    y = intfilter(1, k, X);
    %y = X - intfilter(-[0 k], 1, X);
end