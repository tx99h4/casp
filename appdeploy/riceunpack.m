% Uncompress data block using Rice coding scheme
% syntax: out = riceunpack(in, n, fblock)
%
%          in  : compressed block
%          n   : length of compressed block (in Bytes)
%          fblock: length of uncompressed block (in Bytes)
%          out : uncompressed block
%
% (c) copyright 2010, Muhiy-eddine Cherik

function out = riceunpack(in, n, fblock)

    %final uncompressed block chosen size (in Bytes)
    %fblock = 2048*2;
    
    % signed 16-bit integer format
    SINT16 = 3;
    
    out    = int16(zeros(1, fblock/2)');

    %% Prepare in/out function args pointers
    pin  = libpointer('int8Ptr', in);
    pout = libpointer('int16Ptr', out);

    %% uncompress buffer
    % be careful about n(input packed size in B
    %  and fblock(output packed size in B) and format (SINT16)
    calllib('rice','Rice_Uncompress', pin, pout, n, fblock, SINT16); %
    out  = get(pout, 'Value');
end