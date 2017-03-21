function varargout = fig(varargin)
% FIG MATLAB code for fig.fig
%      FIG, by itself, creates a new FIG or raises the existing
%      singleton*.
%
%      H = FIG returns the handle to a new FIG or the handle to
%      the existing singleton*.
%
%      FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIG.M with the given input arguments.
%
%      FIG('Property','Value',...) creates a new FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fig

% Last Modified by GUIDE v2.5 27-Oct-2016 09:57:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fig_OpeningFcn, ...
                   'gui_OutputFcn',  @fig_OutputFcn, ...
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


% --- Executes just before fig is made visible.
function fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fig (see VARARGIN)

% Choose default command line output for fig
handles.output = hObject;
rosshutdown();
logo = imread ('logo.jpg');
set(handles.logo, 'CData', logo);
guidata(hObject, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in speed.
function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global speed
     speed = get (hObject, 'Value');

% Hint: get(hObject,'Value') returns toggle state of speed


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in cam_effect.
function cam_effect_Callback(hObject, eventdata, handles)
% hObject    handle to cam_effect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global effect
     effect = cellstr(get(hObject, 'String'));
     effect = effect{get(hObject, 'Value')};
% Hints: contents = cellstr(get(hObject,'String')) returns cam_effect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cam_effect


% --- Executes during object creation, after setting all properties.
function cam_effect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cam_effect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cam_validate.
function cam_validate_Callback(hObject, eventdata, handles)
% hObject    handle to cam_validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global cam_timer
    cam_timer = timer('TimerFcn',@cam_timer_callback,...
        'ExecutionMode','fixedRate','Period',0.01,...
        'BusyMode', 'drop', 'UserData', handles);
    start(cam_timer);
    
function cam_timer_callback(tim_obj, event)
 global effect cam_sub depth_cam_sub
    timerdata = get(tim_obj, 'UserData');

    depth_cam_msg = receive (depth_cam_sub);
    depth_image = readImage (depth_cam_msg);
    axes (timerdata.cam_stream);
    imshow (depth_image);
    
    cam_msg = receive (cam_sub);
    image = readImage (cam_msg);
    %axes (timerdata.cam_stream);
    %imshow (image);
    axes (timerdata.cam_view);
    if strcmp(effect, 'normal')
        imshow(image);
    elseif strcmp (effect, 'grayscale')
        image = rgb2gray (image);
        imshow(image);
    elseif strcmp (effect, 'black&white')
        image = im2bw (image, .30);
        imshow(image);
    elseif strcmp (effect, 'histogram')
        imhist (rgb2gray(image));
    elseif strcmp (effect, 'complement')
        imshow(imcomplement(image));
    elseif strcmp (effect, 'red')
        image(:,:,2:3) = 0;
        imshow(image)
    elseif strcmp (effect, 'green')
        image(:,:,1:1) = 0;
        image(:,:,3:3) = 0;
        imshow(image)
    elseif strcmp (effect, 'blue')
        image(:,:,1:2) = 0;
        imshow(image);
    elseif strcmp (effect, 'edge_prewitt')
        imshow(edge(rgb2gray (image),'prewitt'));
    elseif strcmp (effect, 'edge_canny')
        imshow(edge(rgb2gray (image),'canny'));
    end


% --- Executes on button press in reverse.
function reverse_Callback(hObject, eventdata, handles)
% hObject    handle to reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reverse
    reverse = get(hObject, 'Value');

% Hint: get(hObject,'Value') returns toggle state of reverse


% --- Executes on button press in connect.
function connect_Callback(hObject, eventdata, handles)
% hObject    handle to connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global driver_pub driver_msg cam_sub effect depth_cam_sub
    set(handles.status, 'String', 'Please wait...');
    pause(0.1);
    address= get(handles.edit1,'String'); %edit1 being Tag of ur edit box
    if isempty(address)
    fprintf('Error: Enter robot IP address first\n');
    else
   % Write code for computation you want to do 
    end
    %rosinit('192.168.0.201', 11311);
    rosinit(address, 11311);
    % needed ros subscriber and publisher
    cam_sub = rossubscriber ('/usb_cam/image_raw');
    depth_cam_sub = rossubscriber ('/camera/depth/image');
    driver_pub = rospublisher ('/cmd_vel');
    driver_msg = rosmessage (driver_pub);
    effect = 'normal';
    set(handles.status, 'String', 'ON');
    pause(0.1);
    cam_validate_Callback(hObject, eventdata, handles);
    

% --- Executes on button press in disconnect.
function disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam_timer driver_timer
    %stop(cam_timer);
    %stop(driver_timer);
    delete(cam_timer);
    delete(driver_timer);
    set(handles.status, 'String', 'OFF');
    clear;
    rosshutdown();


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.status, 'String', 'WAIT...');
    clear;
    rosshutdown();
    pause(0.5);
    close();


% --- Executes on button press in logo.
function logo_Callback(hObject, eventdata, handles)
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web ('http://enovarobotics.com', '-browser');


% --- Executes when selected object is changed in driver.
function driver_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in driver 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global driver_pub driver_msg speed reverse driver_timer 
    if reverse == 1
        speed = -speed;
    end
        
    switch get(eventdata.NewValue, 'Tag')
        case 'forward'
            driver_msg.Linear.X = speed;
            driver_msg.Angular.Z = 0;
            %send(driver_pub, driver_msg);
        case 'left'
            driver_msg.Linear.X = speed;
            driver_msg.Angular.Z = 0.3;
            %send(driver_pub, driver_msg);
        case 'right'
            driver_msg.Linear.X = speed;
            driver_msg.Angular.Z = -0.3;
            %send(driver_pub, driver_msg);
        case 'rotate_left'
            driver_msg.Linear.X = 0;
            driver_msg.Angular.Z = 0.5;
            %send(driver_pub, driver_msg);
        case 'rotate_right'
            driver_msg.Linear.X = 0;
            driver_msg.Angular.Z = -0.5;
            %send(driver_pub, driver_msg);
        case 'stop'
            driver_msg.Linear.X = 0;
            driver_msg.Angular.Z = 0;
            %send(driver_pub, driver_msg);
    end; 
        
    driver_timer = timer('TimerFcn',@driver_timer_callback,...
                   'ExecutionMode','fixedRate','Period',1);
    start(driver_timer);
    
function driver_timer_callback(tim_obj, event)
 global driver_pub driver_msg 
     send(driver_pub, driver_msg);



function edit1_Callback(hObject, eventdata, handles)
address= get(handles.edit1,'String'); %edit1 being Tag of ur edit box
 if isempty(address)
   fprintf('Error: Enter Text first\n');
 else
   % Write code for computation you want to do 
 end
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stop


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
