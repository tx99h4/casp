% estimateorder.m 
% estimate data best fit order
%
% syntax : order = estimateorder(file, blksize)
%               file: filename
%               blksize: size of processed block (in bytes)
%               order: best fit order
%
% (c) copyright 2010, Muhiy-eddine Cherik
function order = estimateorder(file, blksize)

    prev_est = 1e23;
    maxorder = 23;
    prev_order = 1;
    blksize = blksize/2;
    
    incunit = (1*1024/16)*2; % increase rate difference = 64 B
    
    % fetch half quarter data to analyse (6'' for fs=44100)
    size = wavread(file, 'size');
    i = fix(size(1)*size(2)/8);
    data = fix(double(wavread(file, [fix(i*4/size(2)) fix(i*5/size(2))], 'native')));
    
    % if stereo data, then get average of the two channels
    if size(2) == 2
        data = fix((data(:,1) + data(:, 2))/2);
    end
    
    %ho = waitbar(0, 'Estimation de l''ordre...');
    %set(ho, 'windowstyle', 'modal');
    
    %% for each order (order=1 never used so keep compute time !)
    for order=2:maxorder
        
        % compute bitrate
        [~, varerr]  = lpc(data, order);
        est_byterate = round(log2(sqrt(varerr)) * blksize + log2(order));
        
        % stop when order no longer increase
        if abs(est_byterate - prev_est) <= incunit
            break;
        end
        
        % save last stat
        prev_order = order;
        prev_est = est_byterate;
        
        % update progession bar
        %waitbar(order/maxorder, ho);
        
    end
    
    order = prev_order;
     
    % close waitbar
    %delete(ho);
    
end

