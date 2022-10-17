function varargout = Convolucion(varargin)
% CONVOLUCION MATLAB code for Convolucion.fig
%      CONVOLUCION, by itself, creates a new CONVOLUCION or raises the existing
%      singleton*.
%
%      H = CONVOLUCION returns the handle to a new CONVOLUCION or the handle to
%      the existing singleton*.
%
%      CONVOLUCION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVOLUCION.M with the given input arguments.
%
%      CONVOLUCION('Property','Value',...) creates a new CONVOLUCION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Convolucion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Convolucion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Convolucion

% Last Modified by GUIDE v2.5 15-Nov-2016 20:46:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Convolucion_OpeningFcn, ...
                   'gui_OutputFcn',  @Convolucion_OutputFcn, ...
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


% --- Executes just before Convolucion is made visible.
function Convolucion_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Convolucion (see VARARGIN)

% Choose default command line output for Convolucion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Convolucion wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global tem Fs ri Fs1 nom
tem=3;  Fs=44100;
[ri,Fs1] = audioread('ir1_-_scoppioinferiore_new.wav');
nom='Scoppio inferiore';
tri=(0:length(ri)-1)/Fs1;
axes(handles.axes2);
plot(tri,ri);


% --- Outputs from this function are returned to the command line.
function varargout = Convolucion_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(~, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz Fs
if (isempty(voz))
    set(handles.text,'String','Can not play because there is no recording. Perform recording with voice recording.')
else
    set(handles.text,'String','Playing back the recorded voice')
    sound(voz,Fs);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ri Fs1 nom
if (isempty(ri))
    set(handles.text,'String','Can not play. No impulse response selected.')
else
    set(handles.text,'String',['Playing impulse response ',nom])
    sound(ri,Fs1);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(~, ~, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global con Fs
if (isempty(con))
    set(handles.text,'String','Can not play. It has not convoluted. Check recorded voice or play response.')
else
    set(handles.text,'String','Reproducing the convolution.')
    sound(con,Fs);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(~, ~, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tem Fs voz ri con
tem=str2double(get(handles.edit1,'String'));
Fs=str2double(get(handles.edit2,'String'));
recObj = audiorecorder(Fs,16,1);
set(handles.text,'String','Initiating voice recording');
recordblocking(recObj, tem);
voz = getaudiodata(recObj);
if get(handles.checkbox,'Value')==0
    for i=1:1:length(voz)
        if (voz(i)>0.05)
             break
         end
    end
    for f=length(voz):-1:1
        if (voz(f)>0.05)
            break
        end
    end
    voz=voz(i:f);
end
set(handles.text,'String',['The voice recording is over. With a duration of ',num2str(tem),' seconds and with a sampling frequency of ',num2str(Fs),' Hz.'])
t=(0:length(voz)-1)/Fs;
axes(handles.axes1);
plot(t,voz);
if(~isempty(ri))
    set(handles.text,'String','Initiating the convolution. Waiting...')
    con = conv(voz,ri);
    con=con/max(con);
    tc=(0:length(con)-1)/Fs;
    axes(handles.axes3);
    plot(tc,con);
    set(handles.text,'String','The convolution is over.')
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(~, ~, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz Fs
set(handles.text,'String','Choosing the file to import.')
[FileName, Path]=uigetfile({'*.mp3;*.wav'},'Escoger audio');
[voz,Fs] = audioread(strcat(Path,FileName));
if get(handles.checkbox,'Value')==0
    for i=1:1:length(voz)
        if (voz(i)>0.05)
            break
        end
    end
    for f=length(voz):-1:1
        if (voz(f)>0.05)
            break
        end
    end
    voz=voz(i:f);
end
set(handles.text,'String',['Has been imported ',FileName])
t=(0:length(voz)-1)/Fs;
axes(handles.axes1);
plot(t,voz);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, ~, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz con Fs Fs1 ri imp nom
if (isempty(imp))
    set(handles.seis,'String','Unknown')
else
    set(handles.seis,'String','Room')
end
if (hObject==handles.uno)
    [ri,Fs1] = audioread('ir1_-_scoppioinferiore_new.wav');
    nom=get(handles.uno,'String');
elseif (hObject==handles.dos)
    [ri,Fs1] = audioread('living_room_1.wav');
    nom=get(handles.dos,'String');
elseif (hObject==handles.tres)
    [ri,Fs1] = audioread('reactor nuclear.wav');
    nom=get(handles.tres,'String');
elseif (hObject==handles.cuatro)
    [ri,Fs1] = audioread('slinky_ir.wav');
    nom=get(handles.cuatro,'String');
elseif (hObject==handles.cinco)
    [ri,Fs1] = audioread('sportscentre_omni.wav');
    nom=get(handles.cinco,'String');
elseif (hObject==handles.seis)
    ri=imp;
    Fs1=Fs;
    nom=get(handles.seis,'String');
end
if get(handles.checkbox,'Value')==0
    for i=1:1:length(ri)
        if (ri(i)>0.05)
            break
        end
    end
    for f=length(ri):-1:1
        if (ri(f)>0.005)
            break
        end
    end
    ri=ri(i:f);
end
tri=(0:length(ri)-1)/Fs1;
axes(handles.axes2);
if(isempty(imp) && hObject==handles.seis)
    plot(0)
else
    plot(tri,ri);
end
if(isempty(voz))
    if(isempty(imp) && hObject==handles.seis)
        set(handles.text,'String','A voice recording and pulse recording must be performed')
    else
        set(handles.text,'String','A voice recording must be performed.')
    end
else
    set(handles.text,'String','Initiating the convolution. Waiting...')
    con = conv(voz,ri);
    con=con/max(con);
    tc=(0:length(con)-1)/Fs;
    axes(handles.axes3);
    plot(tc,con);
    set(handles.text,'String','The convolution is over.')
    if(isempty(imp) && hObject==handles.seis)
        set(handles.text,'String','A pulse recording must be performed')
    end
end


% --------------------------------------------------------------------
function Untitled_1_Callback(~, ~, ~)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(~, ~, ~)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(~, ~, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imp Fs
Fs=str2double(get(handles.edit2,'String'));
recObj = audiorecorder(Fs,16,1);
for s=3:-1:1
    set(handles.text,'String',['Starting recording the impulse response in ',num2str(s),'s'])
    pause(1)
end
set(handles.text,'String','Starting recording the impulse response now.')
recordblocking(recObj, 2);
set(handles.text,'String',['The recording of the impulse response has ended whit sampling frecuency ',num2str(Fs),' Hz.']);
imp = getaudiodata(recObj);


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(~, ~, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz imp con
voz=[];
imp=[];
con=[];
axes(handles.axes1);
plot(0);
axes(handles.axes3);
plot(0);
set(handles.text,'String','All data has been deleted.')
clc


function edit1_Callback(~, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(~, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox.
function checkbox_Callback(hObject, ~, handles)
% hObject    handle to checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox
if get(hObject,'Value')==1
    set(handles.text,'String','Editing of the signals has been enabled')
else
    set(handles.text,'String','Automatic signal editing')
end


% --------------------------------------------------------------------
function Untitled_9_Callback(~, ~, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz Fs ri Fs1 con
Lv=length(voz);
NFFTv = 2^nextpow2(Lv); % Next power of 2 from length of y
Yv = fft(voz,NFFTv)/Lv;
fv = Fs/2*linspace(0,1,NFFTv/2+1);
axes(handles.axes1)
plot(fv,2*abs(Yv(1:NFFTv/2+1)))

Lri=length(ri);
NFFTri = 2^nextpow2(Lri); % Next power of 2 from length of y
Yri = fft(ri,NFFTri)/Lri;
fri = Fs1/2*linspace(0,1,NFFTri/2+1);
axes(handles.axes2)
plot(fri,2*abs(Yri(1:NFFTri/2+1)))

Lc=length(con);
NFFTc = 2^nextpow2(Lc); % Next power of 2 from length of y
Yc = fft(con,NFFTc)/Lc;
fc = Fs/2*linspace(0,1,NFFTc/2+1);
axes(handles.axes3)
plot(fc,2*abs(Yc(1:NFFTc/2+1)))


% --------------------------------------------------------------------
function Untitled_10_Callback(~, ~, ~)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(~, ~, ~)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(~, ~, ~)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(~, ~, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz Fs con imp
if get(handles.checkbox,'Value')==1
    if ~isempty(con)
        set(handles.text,'String','Select the first breakpoint on the third graph');
        [x0,~] = ginput(1); %Punto inicial para recortar la señal
        set(handles.text,'String','Select the second breakpoint on the third graph');
        [x1,~] = ginput(1); %Punto final para recortar la señal
        set(handles.text,'String','The signal convolution has been edited in time and plotted in the third graph');
        x0=round(x0*Fs);
        x1=round(x1*Fs);
        con=con(x0:x1);
        t=(0:length(con)-1)/Fs;
        axes(handles.axes3);
        plot(t,con);
    else
        if isempty(voz)
            set(handles.text,'String','There is no convolution. A voice recording must be performed.')
        elseif isempty(imp)
            set(handles.text,'String','There is no convolution. A pulse recording must be performed.')
        end
    end
else
    set(handles.text,'String','Before editing you must enable manual editing box')
end


% --------------------------------------------------------------------
function Untitled_8_Callback(~, ~, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz ri con Fs Fs1
tv=(0:length(voz)-1)/Fs;
axes(handles.axes1);
plot(tv,voz);

tri=(0:length(ri)-1)/Fs1;
axes(handles.axes2);
plot(tri,ri);

tc=(0:length(con)-1)/Fs;
axes(handles.axes3);
plot(tc,con);


% --------------------------------------------------------------------
function Untitled_6_Callback(~, ~, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz Fs con ri Fs1
if get(handles.checkbox,'Value')==1
    if ~isempty(ri)
        set(handles.text,'String','Select the first breakpoint on the second graph');
%         [x0,~] = ginput(1); %Punto inicial para recortar la señal
%         set(handles.text,'String','Select the second breakpoint on the second graph');
        [x1,~] = ginput(1); %Punto final para recortar la señal
        set(handles.text,'String','The signal impulse response has been edited in time and plotted in the second graph');
%         x0=round(x0*Fs1);
        x1=round(x1*Fs1);
        ri=ri(1:x1);
        t=(0:length(ri)-1)/Fs1;
        axes(handles.axes2);
        plot(t,ri);
        if ~isempty(voz)
            set(handles.text,'String','Initiating the convolution. Waiting...')
            con = conv(voz,ri);
            con=con/max(con);
            tc=(0:length(con)-1)/Fs;
            axes(handles.axes3);
            plot(tc,con);
            set(handles.text,'String','The convolution is over.')
        else
            set(handles.text,'String','A voice recording must be performed.')
        end
    else
        set(handles.text,'String','You must make a pulse recording or import before editing')
    end
else
    set(handles.text,'String','Before editing you must enable manual editing box')
end


% --------------------------------------------------------------------
function Untitled_5_Callback(~, ~, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voz Fs con ri
if get(handles.checkbox,'Value')==1
    if ~isempty(voz)
        set(handles.text,'String','Select the first breakpoint on the first graph');
        [x0,~] = ginput(1); %Punto inicial para recortar la señal
        set(handles.text,'String','Select the second breakpoint on the first graph');
        [x1,~] = ginput(1); %Punto final para recortar la señal
        set(handles.text,'String','The signal to be convolved has been edited in time and plotted in the first graph');
        x0=round(x0*Fs);
        x1=round(x1*Fs);
        voz=voz(x0:x1);
        t=(0:length(voz)-1)/Fs;
        axes(handles.axes1);
        plot(t,voz);
        if ~isempty(ri)
            set(handles.text,'String','Initiating the convolution. Waiting...')
            con = conv(voz,ri);
            con=con/max(con);
            tc=(0:length(con)-1)/Fs;
            axes(handles.axes3);
            plot(tc,con);
            set(handles.text,'String','The convolution is over.')
        end
    else
        set(handles.text,'String','You must make a voice recording or import before editing')
    end
else
    set(handles.text,'String','Before editing you must enable manual editing box')
end


% --------------------------------------------------------------------
function uitoggletool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
