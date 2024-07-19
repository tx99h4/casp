% pkfilestereo.m 
% [STEREO VERSION]
% Compress file using prediction and Rice coding scheme
%   syntax : pkfilestereo(filename, fname)
%            filename -> file name with its folder location
%            fname    -> only file name (w/o extension!)
%
% (c) copyright 2010, Muhiy-eddine Cherik

function pkfilestereo(filename, fname)

    he = waitbar(0, 'Estimation de l''ordre...');
    
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe = get(he,'javaframe');
    jIcon  = javax.swing.ImageIcon('bassclef.png');
    jframe.setFigureIcon(jIcon);
    
    set(he, 'WindowStyle', 'modal');

    % Construct CASP header and get WAV file size
    [hdr, nsample] = caspheader(filename);
    
    % block size (# of samples)
    szblock = double(typecast(hdr(11:12), 'int16'))/2;

    % create compressed file
    fp = fopen(strcat(fname, '.casp'), 'wb');
    
    % get number of block and last block size
    nblocks  = fix(nsample / szblock);
    szlblock = rem(nsample, szblock);
    
    % begin & end index bounding block 
    bidx = 1;
    eidx = szblock;
    
    % prediction order
    order = double(hdr(13));

    % write WAV header in compressed file
    fwrite(fp, hdr, 'int8');
    
    waitbar(0, he, 'Compression en cours...');
    
    %% compress data and write output to file
    for i=1:nblocks

        % read current block
        inblk = wavread(filename, [bidx eidx], 'native');    
        
        % do prediction [left channel]
        [qpal, pblkl] = lpanalysis(inblk(:, 1), order);    
        leblkl = [qpal;pblkl];
        
         % do prediction [right channel]
        [qpar, pblkr] = lpanalysis(inblk(:, 2), order);    
        leblkr = [qpar;pblkr];
        
        % align both channel
        leblk  = [leblkl;leblkr];
        
        % compress
        [outblk, packed] = ricepack(leblk);
        
        % write to file
        fwrite(fp, packed, 'uint16'); % block size
        fwrite(fp, outblk, 'int8');   % compressed block data
        
        % get next begin and end block indices
        bidx = eidx + 1;
        eidx = eidx + szblock;
        
        % update progession bar
        waitbar(i/nblocks, he);
        
    end
    
    %% compress and write last block data if exist
    if szlblock ~= 0
        inblk = wavread(filename, [bidx nsample], 'native');    
        
        % do prediction [left channel]
        [qpal, pblkl] = lpanalysis(inblk(:, 1), order);    
        leblkl = [qpal;pblkl];
        
         % do prediction [right channel]
        [qpar, pblkr] = lpanalysis(inblk(:, 2), order);    
        leblkr = [qpar;pblkr];
        
        % align both channel
        leblk  = [leblkl;leblkr];
        
        % compress
        [outblk, packed] = ricepack(leblk);
        
        % write to file
        fwrite(fp, packed, 'uint16'); % block size
        fwrite(fp, outblk, 'int8');   % compressed block data
        
        % update progession bar
        waitbar(1, he);
    end

    %% close waitbar
    delete(he);
    
    % close output
    fclose(fp);

    % show end process dialog
    h = msgbox('Compression terminée !', 'CASP Soft', 'help', 'modal');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe = get(h, 'javaframe');
    jIcon  = javax.swing.ImageIcon('bassclef.png');
    jframe.setFigureIcon(jIcon);
    
end
   