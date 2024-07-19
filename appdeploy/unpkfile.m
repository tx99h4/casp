% unpkfile.m 
% [MONO VERSION]
% Uncompress file using prediction and Rice coding scheme
%   syntax : unpkfile(filename, fname)
%            filename -> file name with its folder location
%            fname    -> only file name (w/o extension!)
%
% (c) copyright 2010, Muhiy-eddine Cherik

function unpkfile(filename, fname)

    i = 0;
    
    % open compressed file
    fp = fopen(filename, 'rb');
    
    % read header
    headr = int8(fread(fp, 57, 'int8'));

    % Get original WAV size and residue blocksize
    size  = double(typecast(headr(7:10), 'int32'));
    blocksz = double(typecast(headr(11:12), 'int16'));
 
    % Get number of samples
    nsample = size - 44;
    
    % get filter order
    order = double(typecast(headr(13), 'int8'));
    
    % next index ord (for speed only!)
    bridx = order + 1;
    
    % total size of uncompressed data
    fblock = blocksz + order*2; % <- because lp are coded with 16-bit
    
    % get original WAV header
    wvhdr = headr(14:end);
    
    % open uncompressed file    
    fo = fopen(strcat(fname, '.wav'), 'wb');

    % show waitbar
    he = waitbar(0, 'Décompression en cours...');
    set(he, 'WindowStyle', 'modal');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe = get(he, 'javaframe');
    jIcon  = javax.swing.ImageIcon('bassclef.png');
    jframe.setFigureIcon(jIcon);
    
    % write WAV header
    fwrite(fo, wvhdr, 'int8');
    
    % get number of block and last block size
    nblocks  = fix(nsample / blocksz);
    szlblock = rem(nsample, blocksz);

    %% uncompress data
    for k=1:nblocks
        
        % read current block size (stored in 16-bits)
        blksz = fread(fp, 1, 'uint16');

        % read entire compressed block
        inblk = int8(fread(fp, blksz, 'int8'));

        % uncompress
        outblk = riceunpack(inblk, blksz, fblock);
        
        % get quantized lp and residue
        qlp = typecast(outblk(1:order), 'int16');
        
        e = outblk(bridx:end);
        
        % synthesis
        destblk = lpsynthesis(e, qlp);

        % update progession bar
        i = i + blocksz;
        waitbar(i/size, he);
        
        % write back WAV samples
        fwrite(fo, destblk, 'int16');
        
    end
 
    %% compress and write last block data if exist
    if szlblock ~= 0
        
        % read current block size (stored in 16-bits)
        blksz = fread(fp, 1, 'uint16');

        % read entire compressed block
        inblk = int8(fread(fp, blksz, 'int8'));

        % uncompress
        outblk = riceunpack(inblk, blksz, fblock);
        
        % get quantized lp and residue
        qlp = typecast(outblk(1:order), 'int16');
        
        e = outblk(bridx:order+szlblock/2);
        
        % synthesis
        destblk = lpsynthesis(e, qlp);

        % update progession bar
        waitbar(1, he);       

        % write back WAV samples
        fwrite(fo, destblk, 'int16');
        
    end

    % close output
    fclose(fp);
    fclose(fo);
    
    % close waitbar
    delete(he);

    % show end process dialog
    h = msgbox('Décompression terminée !', 'CASP Soft', 'help', 'modal');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe = get(h, 'javaframe');
    jIcon  = javax.swing.ImageIcon('bassclef.png');
    jframe.setFigureIcon(jIcon);
end