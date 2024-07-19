% LLCSOFT M-file for llcsoft.fig
% Last Modified by GUIDE v2.5 24-Jun-2010 21:41:58
% (c) copyright 2010, Muhiy-eddine Cherik
function varargout = llcsoft(varargin)

% Begin initialization code

% try loading Rice compression library
try
    if ~libisloaded('rice')
        loadlibrary('rice', @riceHeader, 'alias', 'rice');
    end
catch MEXCP 
    % otherwise, close application !!
    hw = errordlg('le fichier rice.dll est manquant ou invalide !', 'Erreur fatale');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe = get(hw,'javaframe');
    jIcon  = javax.swing.ImageIcon('bassclef.png');
    jframe.setFigureIcon(jIcon);       
    return;
end

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @llcsoft_OpeningFcn, ...
                   'gui_OutputFcn',  @llcsoft_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% --- Executes just before llcsoft is made visible.
function llcsoft_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to llcsoft (see VARARGIN)
    
    % Choose default command line output for llcsoft
    handles.output = hObject;

    % Center frame
    movegui(hObject, 'center');

    % Update handles structure
    guidata(hObject, handles);

    % change caspsoft.exe figure icon
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(handles.output,'javaframe');
    jIcon=javax.swing.ImageIcon('bassclef.png');
    jframe.setFigureIcon(jIcon);

    % Initially all informations are hidden
    % and also pack & unpack button
    set(handles.btnUnpack, 'visible', 'off');
    set(handles.btnPack, 'visible', 'off');

    set(handles.lblFileSize, 'visible', 'off');
    set(handles.txtSize, 'visible', 'off');
    set(handles.lblKo, 'visible', 'off');

    set(handles.lblRatio, 'visible', 'off');
    set(handles.txtRatio, 'visible', 'off');
    set(handles.lblpercent, 'visible', 'off');

    set(handles.lblchannel, 'visible', 'off');

    global file fname;
    
    if ~isempty(varargin)
        
        file = char(varargin);
        
        fileName = dir(file);
        fileName = lower(fileName.name);

        % show file name
        set(handles.lblDFileName, 'string', fileName);

        % get name and extension
        [fname, ext] = strtok(fileName,'.'); 
        
        % get file size in KB
        filesize = dir(file);
        filesize = uint64(filesize.bytes/1024);
    
    % if file extension is WAV and file is really a WAV audio file
    if strcmpi(ext, '.wav') == 1 && ~isempty(wavfinfo(file))
     
        % get number of channel
        channel = wavread(file, 'size');
        
        % then activate Compress Button
        set(handles.btnUnpack, 'visible', 'off');
        set(handles.btnPack, 'visible', 'on');
        
        % show file size in KB
        set(handles.txtSize, 'string', num2str(filesize));   
        
        % hide file ratio information
        set(handles.lblRatio, 'visible', 'off');
        set(handles.lblpercent, 'visible', 'off');
        set(handles.txtRatio, 'visible', 'on');
        
        set(handles.lblFileSize, 'visible', 'on');
        set(handles.txtSize, 'visible', 'on');
        set(handles.lblKo, 'visible', 'on');
        
        set(handles.lblchannel, 'visible', 'on');
       
        % show adequate string according to the
        % number of channels
        switch channel(2) 
            case 1
                set(handles.txtRatio, 'string', 'mono');
            case 2
                set(handles.txtRatio, 'string', 'stéréo');
            otherwise
                set(handles.txtRatio, 'string', '???');
        end   
        
    % if file extension is CASP and file is really a CASP audio file
    else if strcmpi(ext, '.casp') == 1  && ~isempty(caspfinfo(file))
            
        % or deactivate Uncompress Button
        set(handles.btnUnpack, 'visible', 'on');
        set(handles.btnPack, 'visible', 'off');
        
        % show file ratio information
        set(handles.lblFileSize, 'visible', 'on');
        set(handles.txtSize, 'visible', 'on');
        set(handles.lblKo, 'visible', 'on');
        
        set(handles.lblRatio, 'visible', 'on');
        set(handles.lblpercent, 'visible', 'on');
        set(handles.txtRatio, 'visible', 'on');
        
        set(handles.lblchannel, 'visible', 'off');
        set(handles.lblchannel, 'visible', 'off');
        
        % Extract ratio
        ratio = fileratio(file);
           
        % show size and compression ratio
        set(handles.txtRatio, 'string', num2str(ratio));
        set(handles.txtSize, 'string', num2str(filesize));

        else

           % clear filename label
           set(handles.lblDFileName, 'string', '');

           % if cancel button w/o file selection
           if isempty(file)              
                set(handles.btnUnpack, 'visible', 'off');
                set(handles.btnPack, 'visible', 'off');
               
                set(handles.lblFileSize, 'visible', 'off');
                set(handles.txtSize, 'visible', 'off');
                set(handles.lblKo, 'visible', 'off');

                set(handles.lblRatio, 'visible', 'off');
                set(handles.txtRatio, 'visible', 'off');
                set(handles.lblpercent, 'visible', 'off');

                set(handles.lblchannel, 'visible', 'off');
           else
                h = warndlg('Veuillez choisir un fichier WAV ou bien un fichier CASP', 'Fichier invalide');
                warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
                jframe = get(h, 'javaframe');
                jIcon = javax.swing.ImageIcon('bassclef.png');
                jframe.setFigureIcon(jIcon);       

           end
        end
    end    
end

% --- Outputs from this function are returned to the command line.
function varargout = llcsoft_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function lblDFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lblDFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global file  fname;
    
    % open file dialog
    [fileName, folder] = uigetfile('*.wav; *.casp');
    file = strcat(folder,fileName);
    
    % show file name
    set(handles.lblDFileName, 'string', fileName);

    % get name and extension
    [fname, ext] = strtok(fileName,'.');
    
    % get file size in KB
    if ~isempty(file)
        filesize = dir(file);
        filesize = uint64(filesize.bytes/1024);
    end
    
    % if file extension is WAV and file is really a WAV audio file
    if strcmpi(ext, '.wav') == 1 && ~isempty(wavfinfo(file))
     
        % get number of channel
        channel = wavread(file, 'size');
        
        % then activate Compress Button
        set(handles.btnUnpack, 'visible', 'off');
        set(handles.btnPack, 'visible', 'on');
        
        % show file size in KB
        set(handles.txtSize, 'string', num2str(filesize));   
        
        % hide file ratio information
        set(handles.lblRatio, 'visible', 'off');
        set(handles.lblpercent, 'visible', 'off');
        set(handles.txtRatio, 'visible', 'on');

        set(handles.lblFileSize, 'visible', 'on');
        set(handles.txtSize, 'visible', 'on');
        set(handles.lblKo, 'visible', 'on');
        
        set(handles.lblchannel, 'visible', 'on');
       
        % show adequate string according to the
        % number of channels
        switch channel(2) 
            case 1
                set(handles.txtRatio, 'string', 'mono');
            case 2
                set(handles.txtRatio, 'string', 'stéréo');
            otherwise
                set(handles.txtRatio, 'string', '???');
        end
        
    % if file extension is CASP and file is really a CASP audio file
    else if strcmpi(ext, '.casp') == 1  && ~isempty(caspfinfo(file))

        % or deactivate Uncompress Button
        set(handles.btnUnpack, 'visible', 'on');
        set(handles.btnPack, 'visible', 'off');
        
        % show file ratio information
        set(handles.lblFileSize, 'visible', 'on');
        set(handles.txtSize, 'visible', 'on');
        set(handles.lblKo, 'visible', 'on');
        
        set(handles.lblRatio, 'visible', 'on');
        set(handles.lblpercent, 'visible', 'on');
        set(handles.txtRatio, 'visible', 'on');
        
        set(handles.lblchannel, 'visible', 'off');
        set(handles.lblchannel, 'visible', 'off');
        
        % Extract ratio
        ratio = fileratio(file);
           
        % show size and compression ratio
        set(handles.txtRatio, 'string', num2str(ratio));
        set(handles.txtSize, 'string', num2str(filesize));
        
    else
            
       % clear filename label
       set(handles.lblDFileName, 'string', '');
       
       % if cancel button w/o file selection
       if isempty(file)
            set(handles.btnUnpack, 'visible', 'off');
            set(handles.btnPack, 'visible', 'off');
            
            set(handles.lblFileSize, 'visible', 'off');
            set(handles.txtSize, 'visible', 'off');
            set(handles.lblKo, 'visible', 'off');

            set(handles.lblRatio, 'visible', 'off');
            set(handles.txtRatio, 'visible', 'off');
            set(handles.lblpercent, 'visible', 'off');

            set(handles.lblchannel, 'visible', 'off');
       else
            hw = warndlg('Veuillez choisir un fichier WAV ou bien un fichier CASP', 'Fichier invalide');
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
            jframe = get(hw,'javaframe');
            jIcon  = javax.swing.ImageIcon('bassclef.png');
            jframe.setFigureIcon(jIcon);            
       end
    end
end

% --- Executes on button press in btnPack.
function btnPack_Callback(hObject, eventdata, handles)
% hObject    handle to btnPack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global file  fname;

    % get number of channel
    channel = wavread(file, 'size');
    
    % do all the stuff !
    if channel(2) == 2      
        pkfilestereo(file, fname);
    else if channel(2) == 1
        pkfile(file, fname);
        else
            h = warndlg('Ne peut traiter un fichier multicanal !', 'Oops!');
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
            jframe = get(h,'javaframe');
            jIcon  = javax.swing.ImageIcon('bassclef.png');
            jframe.setFigureIcon(jIcon);                   
        end  
    end
    
    
% --- Executes on button press in btnUnpack.
function btnUnpack_Callback(hObject, eventdata, handles)
% hObject    handle to btnUnpack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global file  fname;
    
    % get number of channels
    [~, channel] = caspfinfo(file);
    
    % do all the stuff also !
    % it can a be legen.. wait for it.. DARY !!!
    if channel == 2
        unpkfilestereo(file, fname);
    else if channel == 1    
        unpkfile(file, fname);
        else
            h = warndlg('Ne peut traiter un fichier multicanal !', 'Oops!');
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
            jframe = get(h,'javaframe');
            jIcon  = javax.swing.ImageIcon('bassclef.png');
            jframe.setFigureIcon(jIcon);             
        end  
    end

% --- Executes on button press in btnExit.
function btnExit_Callback(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

unloadlibrary('rice');
close(handles.frmCasp);
