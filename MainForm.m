function varargout = MainForm(varargin)
% MAINFORM MATLAB code for MainForm.fig
%      MAINFORM, by itself, creates a new MAINFORM or raises the existing
%      singleton*.
%
%      H = MAINFORM returns the handle to a new MAINFORM or the handle to
%      the existing singleton*.
%
%      MAINFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINFORM.M with the given input arguments.
%
%      MAINFORM('Property','Value',...) creates a new MAINFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainForm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainForm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainForm

% Last Modified by GUIDE v2.5 19-Jul-2020 16:27:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainForm_OpeningFcn, ...
    'gui_OutputFcn',  @MainForm_OutputFcn, ...
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

function InitAxes(handles)
clc;
axes(handles.axes1); cla reset; axis on; box on;
set(gca, 'XTickLabel', '', 'YTickLabel', '');
axes(handles.axes2); cla reset; axis on; box on;
set(gca, 'XTickLabel', '', 'YTickLabel', '');
axes(handles.axes3); cla reset; axis on; box on;
set(gca, 'XTickLabel', '', 'YTickLabel', '');
axes(handles.axes4); cla reset; axis on; box on;
set(gca, 'XTickLabel', '', 'YTickLabel', '');
axes(handles.axes5); cla reset; axis on; box on;
set(gca, 'XTickLabel', '', 'YTickLabel', '');


% --- Executes just before MainForm is made visible.
function MainForm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainForm (see VARARGIN)

% Choose default command line output for MainForm
handles.output = hObject;
InitAxes(handles)
handles.I = 0;
handles.mask1 = 0;
handles.mask2 = 0;
handles.qy1 = 0;
handles.qy2 = 0;
handles.qy3 = 0;
handles.qy4 = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainForm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainForm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function filePath = OpenImageFile(imgfilePath)
% 打开文件
% 输出参数：
% filePath——文件路径

if nargin < 1
    imgfilePath = fullfile(pwd, 'images/1J-2-10X.jpg');
end
% 读取文件
[filename, pathname, ~] = uigetfile( ...
    { '*.bmp;*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*',  '所有文件 (*.*)'}, ...
    '选择文件', ...
    'MultiSelect', 'off', ...
    imgfilePath);
filePath = 0;
if isequal(filename, 0) || isequal(pathname, 0)
    return;
end
filePath = fullfile(pathname, filename);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filePath = OpenImageFile();
if isequal(filePath, 0)
    return;
end
I = imread(filePath);
axes(handles.axes1);
imshow(I, []);
handles.I2 = remove_bg(I);
handles.I = I;
handles.filename = filePath;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.I, 0)
    return;
end
mask = get_seg_1(handles.I);
handles.mask1 = mask;
% 填充
mask = imdilate(mask, strel('disk', 50));
im = handles.I2;
im_r = im(:,:,1); im_r(~mask) = 255;
im_g = im(:,:,2); im_g(~mask) = 255;
im_b = im(:,:,3); im_b(~mask) = 255;
im2 = cat(3, im_r, im_g, im_b);
axes(handles.axes2);
imshow(im2, []); title('区域1');
handles.qy1 = im2;
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.mask1, 0)
    return;
end
mask2 = get_seg_2(handles.I, handles.mask1);
handles.mask2 = mask2;
% 填充
mask2 = imdilate(mask2, strel('disk', 30));
im = handles.I2;
im_r = im(:,:,1); im_r(~mask2) = 255;
im_g = im(:,:,2); im_g(~mask2) = 255;
im_b = im(:,:,3); im_b(~mask2) = 255;
im2 = cat(3, im_r, im_g, im_b);
axes(handles.axes3);
imshow(im2, []); title('区域2');
handles.qy2 = im2;
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.mask2, 0)
    return;
end
mask3 = get_seg_3(handles.I, handles.mask1, handles.mask2);
handles.mask3 = mask3;
% 填充
mask3 = imdilate(mask3, strel('disk', 30));
im = handles.I2;
im_r = im(:,:,1); im_r(~mask3) = 255;
im_g = im(:,:,2); im_g(~mask3) = 255;
im_b = im(:,:,3); im_b(~mask3) = 255;
im2 = cat(3, im_r, im_g, im_b);
axes(handles.axes4);
imshow(im2, []); title('区域3');
mask1 = imdilate(handles.mask1, strel('disk', 30));
mask1 = imfill(mask1, 'holes');
mask2 = imdilate(handles.mask2, strel('disk', 30));
mask3 = imdilate(handles.mask3, strel('disk', 30));
label = zeros(size(handles.I,1), size(handles.I,2));
label(mask1) = 1;
label(mask2) = 2;
label(mask3) = 3;
rgb = label2rgb(label,'jet',[.5 .5 .5]);
% axes(handles.axes5);
% imshow(rgb,'InitialMagnification','fit')
% title('区域分割蒙版')
handles.qy3 = im2;
guidata(hObject, handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InitAxes(handles)

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fd = fullfile(pwd, 'result');
if ~exist(fd, 'dir')
    mkdir(fd);
end
[FileName,PathName,~] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'保存',...
          fullfile(fd, 'im.jpg'));
if isequal(FileName, 0) || isequal(PathName, 0)
    return;
end
fn = fullfile(PathName, FileName);
[pn, name, ext] = fileparts(fn);
if ~isequal(handles.qy1, 0)
    imwrite(mat2gray(handles.qy1), fullfile(pn, sprintf('%s-区域1%s', name, ext)));
end
if ~isequal(handles.qy2, 0)
    imwrite(mat2gray(handles.qy2), fullfile(pn, sprintf('%s-区域2%s', name, ext)));
end
if ~isequal(handles.qy3, 0)
    imwrite(mat2gray(handles.qy3), fullfile(pn, sprintf('%s-区域3%s', name, ext)));
end
if ~isequal(handles.qy4, 0)
    imwrite(mat2gray(handles.qy4), fullfile(pn, sprintf('%s-区域4%s', name, ext)));
end
questdlg('完毕！', ...
    '提示', ...
    '确定','确定');

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('确定要退出?', ...
    '退出', ...
    '确定','取消','取消');
switch choice
    case '确定'
        close;
    case '取消'
        return;
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v = get(handles.popupmenu1, 'Value');
% 数据检查
if v == 1
    if isequal(handles.qy1, 0)
        return;
    end
    qy = handles.qy1;
end
if v == 2
    if isequal(handles.qy2, 0)
        return;
    end
    qy = handles.qy2;
end
if v == 3
    if isequal(handles.qy3, 0)
        return;
    end
    qy = handles.qy3;
end
if v == 4
    if isequal(handles.qy4, 0)
        return;
    end
    qy = handles.qy4;
end
hf = figure(10); clf; imshow(qy, []);
title('请选择待擦除区域，双击结束！');
[bw,~,~] = roipoly();
img_1 = qy(:,:,1); img_1(bw) = 255;
img_2 = qy(:,:,2); img_2(bw) = 255;
img_3 = qy(:,:,3); img_3(bw) = 255;
im2 = cat(3, img_1, img_2, img_3);
if v == 1
    axes(handles.axes2);
    imshow(im2, []); title('区域1');
    handles.qy1 = im2;
    guidata(hObject, handles);
    close(hf);
end
if v == 2
    axes(handles.axes3);
    imshow(im2, []); title('区域2');
    handles.qy2 = im2;
    guidata(hObject, handles);
    close(hf);
end
if v == 3
    axes(handles.axes4);
    imshow(im2, []); title('区域3');
    handles.qy3 = im2;
    guidata(hObject, handles);
    close(hf);
end
if v == 4
    axes(handles.axes5);
    imshow(im2, []); title('区域4');
    handles.qy4 = im2;
    guidata(hObject, handles);
    close(hf);
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.qy3, 0)
    return;
end
axes(handles.axes5);
imshow(handles.I2, []); title('区域4');
handles.qy4 = handles.I2;
guidata(hObject, handles);
