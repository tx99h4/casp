% lpsynthesis.m 
% FIR synthesis function for integer data
% compute error based upon prediction coefficients
% syntax : [q,y] = lpanalysis(X, n)
%
%         X : block to analyse (int16 data)
%         q : quantized lp (int16 data)
%         y : WAV data block (int16 data)
%
% (c) copyright 2010, Muhiy-eddine Cherik

function y = lpsynthesis(X, q)

%     lenx = length(X);
%     lenc = length(q);
%     z = lenc-1;   
%     tmp = zeros(1, lenc)';
%     y   = short16(zeros(1, lenx))'; 
    
    p = 128; % 2^7
    
    % inverse quantize lp coefficients
    k = double(q')/p;
    
    % compand k1 & k2
    k(1) = (exp(k(1)) - 1) / (exp(k(1)) + 1);
    k(2) = (exp(k(1)) - 1) / (exp(k(1)) + 1);
    
    % convert to lp coefficients
    k = rc2poly(k);
    %k = k(2:end);

    % compute WAV data
%     for i=1:lenx
%         y(i) = X(i) - short16(k * tmp);
%         tmp(2:end) = tmp(1:z);
%         tmp(1) = double(y(i));
%     end
     y = intfilter(1, k, X);
end