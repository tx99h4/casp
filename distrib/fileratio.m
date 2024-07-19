function ratio = fileratio(file)

    % open compressed file
    fp = fopen(file, 'rb');
    
    % read header
    headr = int8(fread(fp, 57, 'int8'));
    
    % close file
    fclose(fp);
    
    % return uncompressed size
    wavsize  = double(typecast(headr(7:10), 'int32'));
    
    % return compression ratio
    fileinfo = dir(file);
    ratio = fix((1 - fileinfo.bytes/wavsize)*1000)/10;

end