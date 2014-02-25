function varargout = EigenFaces_show(varargin)
% EIGENFACES_SHOW MATLAB code for EigenFaces_show.fig
%      EIGENFACES_SHOW, by itself, creates a new EIGENFACES_SHOW or raises the existing
%      singleton*.
%
%      H = EIGENFACES_SHOW returns the handle to a new EIGENFACES_SHOW or the handle to
%      the existing singleton*.
%
%      EIGENFACES_SHOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EIGENFACES_SHOW.M with the given input arguments.
%
%      EIGENFACES_SHOW('Property','Value',...) creates a new EIGENFACES_SHOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EigenFaces_show_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EigenFaces_show_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EigenFaces_show

% Last Modified by GUIDE v2.5 07-Oct-2011 18:25:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EigenFaces_show_OpeningFcn, ...
                   'gui_OutputFcn',  @EigenFaces_show_OutputFcn, ...
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


% --- Executes just before EigenFaces_show is made visible.
function EigenFaces_show_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EigenFaces_show (see VARARGIN)

eigenFacesFigureHandle  = EigenFaces_GUI; 

eigenFacesData = guidata(eigenFacesFigureHandle); 

eigenFaces = eigenFacesData.eigenFaces;
K = eigenFacesData.numeroEigenVectores;

for i=1:K
    n = strcat('axes(handles.imagen_',int2str(i),'_axes);');
    eval(n);
    imagesc(eigenFaces(:,:,i))
    axis off
    colormap('gray')
end


% Choose default command line output for EigenFaces_show
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EigenFaces_show wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EigenFaces_show_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
