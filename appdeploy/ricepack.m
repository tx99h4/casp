% Compress data block using Rice coding scheme
% syntax : [out, spacked] = ricepack(in)
%
%         in : block to compress (int16 data)
%         out: compressed block
%     spacked: size of compressed data (in Bytes)
%
% warning: compress losslessly up to 64 KB block
% (c) copyright 2010, Muhiy-eddine Cherik

function [out, spacked] = ricepack(in)

    SINT16 = 3; % signed 16-bit integer format
    
    n   = length(in) * 2; 
    out = int8(zeros(1, n+1))';
    
    %% Prepare in/out function args pointers
    pin  = libpointer('int16Ptr', in);
    pout = libpointer('int8Ptr', out);
    
    %% compress buffer (return size of compressed data in 'bytes')
    spacked = int16(calllib('rice','Rice_Compress', pin, pout, n, SINT16));

    % get pointed data
    out = get(pout, 'Value');

    % keep interesting data
    out = out(1:spacked); % <-- here was the problem !! :)
    
end