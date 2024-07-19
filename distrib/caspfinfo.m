% caspfinfo.m 
% Verify valid header informations in CASP file
% return also number of channels
% syntax : [y,c] = caspfinfo(file)
%
%         file : filename
%         y : result of magic test
%         c : number of channels
%
% (c) copyright 2010, Muhiy-eddine Cherik
function [y,c] = caspfinfo(file)
    try
        % open compressed file
        fp = fopen(file, 'rb');
    
        % read header
        headr = int8(fread(fp, 57, 'int8'));
        
        fclose(fp);

        % get CASP ID
        magic = char(headr(1:6))';
        
        % get channel number
        c = typecast(headr(36:37), 'int16');
        
        % typecast(headr(38:41), 'int32'); --- fs
        
        % test CASP file ID
        if strcmpi(magic, '%CASP%') == 1
            y = 1;
        else
            y = '';
        end
        
    catch MEXCP
         h = warndlg('Erreur I/O sur le fichier', 'Oups!');
         jframe=get(h,'javaframe');
         jIcon=javax.swing.ImageIcon('bassclef.png');
         jframe.setFigureIcon(jIcon);   
         
         y = '';
         c = 0;
    end

end