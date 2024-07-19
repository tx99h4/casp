function varargout = caspsoft(varargin)
% LLCSOFT M-file for caspsoft.fig
%      CASPSOFT, by itself, creates a new CASPSOFT or raises the existing
%      singleton*.
%
%      H = CASPSOFT returns the handle to a new CASPSOFT or the handle to
%      the existing singleton*.
%
%      CASPSOFT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CASPSOFT.M with the given input arguments.
%
%      CASPSOFT('Property','Value',...) creates a new CASPSOFT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before caspsoft_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to caspsoft_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help caspsoft

% Last Modified by GUIDE v2.5 24-Jun-2010 21:41:58


% Begin initialization code - DO NOT EDIT

%%%% try loading Rice compression library
% done before compile: loadlibrary('rice.dll', 'rice.h', 'mfilename',
% 'riceHeader.m');
try
    if ~libisloaded('rice')
        loadlibrary('rice', @riceHeader, 'alias', 'rice');
    end
catch MEXCP 
    % otherwise, close application !!
    warndlg('le fichier rice.dll est manquant ou invalide !', 'Erreur fatale');
    return;
end

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @caspsoft_OpeningFcn, ...
                   'gui_OutputFcn',  @caspsoft_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before caspsoft is made visible.
function caspsoft_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to caspsoft (see VARARGIN)
    
% Choose default command line output for caspsoft
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

% Initially Compress & Uncompress button are not visible
set(handles.btnUnpack, 'visible', 'off');
set(handles.btnPack, 'visible', 'off');

% UIWAIT makes caspsoft wait for user response (see UIRESUME)
% uiwait(handles.frmCasp);
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

            % then activate Compress Button
            set(handles.btnUnpack, 'visible', 'off');
            set(handles.btnPack, 'visible', 'on');

            % set ratio to 0%
            set(handles.txtRatio, 'string', '0');

            % show file size in KB
            set(handles.txtSize, 'string', num2str(filesize));      

        else if strcmpi(ext, '.casp') == 1
            % or deactivate Uncompress Button
            set(handles.btnUnpack, 'visible', 'on');
            set(handles.btnPack, 'visible', 'off');

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
                set(handles.txtSize, 'string', '');
                set(handles.txtRatio, 'string', '');
           else
                warndlg('Veuillez choisir un fichier WAV ou bien un fichier CASP', 'Fichier invalide');
           end
        end
    end    
end

% --- Outputs from this function are returned to the command line.
function varargout = caspsoft_OutputFcn(hObject, eventdata, handles) 
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

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global file  fname;

    [fileName, folder] = uigetfile('*.wav;*.casp');
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
     
        % then activate Compress Button
        set(handles.btnUnpack, 'visible', 'off');
        set(handles.btnPack, 'visible', 'on');
        
        % set ratio to 0%
        set(handles.txtRatio, 'string', '0');
        
        % show file size in KB
        set(handles.txtSize, 'string', num2str(filesize));      
        
    % if file extension is CASP and file is really a CASP audio file
    else if strcmpi(ext, '.casp') == 1  && ~isempty(caspfinfo(file))
        % or deactivate Uncompress Button
        set(handles.btnUnpack, 'visible', 'on');
        set(handles.btnPack, 'visible', 'off');
        
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
            set(handles.txtSize, 'string', '');
            set(handles.txtRatio, 'string', '');
       else
            warndlg('Veuillez choisir un fichier WAV ou bien un fichier CASP', 'Fichier invalide');
       end
    end
end

% --- Executes on button press in btnPack.
function btnPack_Callback(hObject, eventdata, handles)
% hObject    handle to btnPack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % open dialog
%     hbar = waitbar(step, 'Compression en cours...', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
%     set(hbar, 'windowstyle', 'modal');
%     setappdata(hbar, 'canceling', 0);

%         if getappdata(hbar, 'canceling') == 1 || step == 1
%            delete(hbar);
%            break; 
%         end

    global file  fname;

    channel = wavread(file, 'size');
    
    % do all the stuff !
    if channel(2) == 2      
        pkfilestereo(file, fname);
    else if channel(2) == 1
        pkfile(file, fname);
        else
            warndlg('Ne peut traiter un fichier multicanal !', 'Oops!');
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
            warndlg('Ne peut traiter un fichier multicanal !', 'Oops!');
        end  
    end

% --- Executes on button press in btnExit.
function btnExit_Callback(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

unloadlibrary('rice');
close(handles.frmCasp);
