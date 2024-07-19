% wvtesteq.m 
% Checker for two WAV files
% (c) copyright 2010, Muhiy-eddine Cherik
function wvtesteq(file)
    folder1 = 'C:\Users\Computerman\Documents\MATLAB\';
    folder2 = 'C:\Users\Computerman\Documents\MATLAB\gui\';
    file = strcat(file, '.wav');

    a = wavread(strcat(folder1, file), 'native');
    b = wavread(strcat(folder2, file), 'native');

    m = 1;
    n = 2048; bk = 2048;
    N = length(a)/bk;
    nbnoteq = 0;

    for s=0:N-bk
        if isequal(a(m:n), b(m:n))
            fprintf('%d: [%d..%d]\n', s, m, n);
        else
            fprintf('%d: [%d..%d] <*******NOTEQUAL********\n', s, m, n);
            nbnoteq = nbnoteq + 1;
        end
        m=n+1;
        n = m+bk;    
    end

    n= length(a);

    if ~isequal(a(m:n), b(m:n))
        fprintf('%d: [%d..%d] <*******NOTEQUAL********\n', s, m, n);
    else
        fprintf('%d: [%d..%d]\n', s, m, n);
    end

    fprintf('NOTEQUAL BLOCK --> %d\n', nbnoteq);
end
