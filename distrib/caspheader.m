% caspheader.m 
% Construct compressed file header
%   return also original file samples
% (c) copyright 2010, Muhiy-eddine Cherik
function [hdr, nsample] = caspheader(wvfilename)

    % MAGIC number '%CASP%'
    magic = int8('%CASP%')';
    
    % WAV file size (MAXIMUM FILE SIZE = 4GB)
    size = wavread(wvfilename, 'size');
    fsize = int32(size(1)*size(2)*2 + 44);
    
    % compute needed number of sample
    % to be used in wavread
    if size(2) == 2
        nsample = size(1);   % number of samples per channel
    else
        nsample = size(1)*2; % total number of samples
    end
    
    % block size (in bytes)
    blksize = typecast(int16(4096), 'int8')';
    
    % estimate prediction order
    order = int8(estimateorder(wvfilename, double(typecast(blksize, 'int16'))));
    
    % get WAV header
    fin = fopen(wvfilename, 'rb');
    wavhdr = int8(fread(fin, 44, 'int8'));
    fclose(fin);
    
    % return compressed header file
    hdr = [magic;typecast(fsize, 'int8')';blksize;order;wavhdr];

end
