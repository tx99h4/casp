% pkfile.m 
% Compress file using Rice coding scheme
% (c) copyright 2010, Muhiy-eddine Cherik

% FASTER COMPRESSION >>
% buffwav = wavread 8 MB chunk of data
% blockbuff = buffer(buffwav, 2048)
% sbuff = size(blockbuff)
% for i=1..sbuff(2) compute stuff
% wbuff = reshape(blockbuff, 1, sbuff(2)*2048)
% write wbuff

function prfile()

    filename = 'lvb.wav';
    fname = 'lvb';

    % Construct CASP header and get WAV file size
    fsize = wavread(filename, 'size');
    fsize = fsize(1);
    
    % block size in bytes
    szblock = 4096;
    
    % create compressed file
    fp = fopen(strcat(fname, '.casp'), 'wb');
    
    % get number of block and last block size
    nblocks  = fix(fsize / szblock);
    szlblock = rem(fsize, szblock);
    
    % begin & end index bounding block 
    bidx = 1;
    eidx = szblock/2;
    
    % prediction order
    order = 5;
    
    he = waitbar(0, 'Compression en cours...');
    %set(he, 'windowstyle', 'modal');
    
    %% compress data and write output to file
    % (loop 'number of block' minus one times to scan all
    % full block of data)
    for i=1:nblocks
        
        % read current block
        inblk = wavread(filename, [bidx eidx], 'native');
               
        % do prediction
         a = lpc(double(inblk), order);
         q = int16(a*2^5);
         [q,y] = lpanalysis(inblk, order);
        %y = intfilter(1, a, inblk);
        %y = intfilter(a, 1, inblk);
 
        fwrite(fp, q, 'int16');   % compressed block data
        fwrite(fp, y, 'int16');   % compressed block data
        
        % get next begin and end block indices
        bidx = eidx + 1;
        eidx = eidx + szblock/2;
        
        % update progession bar
        waitbar(i/nblocks, he);
        
    end
    
    %% compress and write last block data if exist
    if szlblock ~= 0
        inblk = wavread(filename, [bidx fsize/2], 'native');
        
        % do prediction
         a = lpc(double(inblk), order);
         pblk = intfilter(1, a, inblk);        
         %pblk = intfilter(a, 1, inblk); 
 
        fwrite(fp, pblk, 'int8');   % compressed block data  
        
        % update progession bar
        waitbar(1, he);
    end

    %% close waitbar
    delete(he);
    
    % close output
    fclose(fp);
end
   