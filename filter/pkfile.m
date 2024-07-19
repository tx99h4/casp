% pkfile.m 
% [MONO VERSION]
% Compress file using prediction and Rice coding scheme
%   syntax : pkfile(filename, fname)
%            filename -> file name with its folder location
%            fname    -> only file name (w/o extension!)
%
% (c) copyright 2010, Muhiy-eddine Cherik

function pkfile(filename, fname)

    he = waitbar(0, 'Estimation de l''ordre...');
    
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe = get(he,'javaframe');
    jIcon  = javax.swing.ImageIcon('bassclef.png');
    jframe.setFigureIcon(jIcon);    
    
    set(he, 'WindowStyle', 'modal');
    
    % Construct CASP header and get WAV file size
    [hdr, fsize] = caspheader(filename);
    
    % block size in bytes
    szblock = double(typecast(hdr(11:12), 'int16'));
    
    % create compressed file
    fp = fopen(strcat(fname, '.casp'), 'wb');
    
    % get number of block and last block size
    nblocks  = fix(fsize / szblock);
    szlblock = rem(fsize, szblock);
    
    % begin & end index bounding block 
    bidx = 1;
    eidx = szblock/2;
    
    % prediction order
    order = double(hdr(13));
    
    % write WAV header in compressed file
    fwrite(fp, hdr, 'int8');
    
    waitbar(0, he, 'Compression en cours...');    
    
    %% compress data and write output to file
    for i=1:nblocks

        % read current block
        inblk = wavread(filename, [bidx eidx], 'native');
        
        % do prediction
        [qpa, pblk] = lpanalysis(inblk, order);    
        leblk = [qpa;pblk];
        
        % compress
        [outblk, packed] = ricepack(leblk);
        
        % write to file
        fwrite(fp, packed, 'uint16'); % block size
        fwrite(fp, outblk, 'int8');   % compressed block data
        
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
        [qpa, pblk] = lpanalysis(inblk, order);    
        leblk = [qpa;pblk];
        
        % compress and write to file
        [outblk, packed] = ricepack(leblk);
        fwrite(fp, packed, 'uint16');
        fwrite(fp, outblk, 'int8');
        
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
   