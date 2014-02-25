function varargout = EigenFaces_GUI(varargin)
% EIGENFACES_GUI MATLAB code for EigenFaces_GUI.fig
%      EIGENFACES_GUI, by itself, creates a new EIGENFACES_GUI or raises the existing
%      singleton*.
%
%      H = EIGENFACES_GUI returns the handle to a new EIGENFACES_GUI or the handle to
%      the existing singleton*.
%
%      EIGENFACES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EIGENFACES_GUI.M with the given input arguments.
%
%      EIGENFACES_GUI('Property','Value',...) creates a new EIGENFACES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EigenFaces_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EigenFaces_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EigenFaces_GUI

% Last Modified by GUIDE v2.5 12-Oct-2011 10:45:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EigenFaces_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @EigenFaces_GUI_OutputFcn, ...
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


% --- Executes just before EigenFaces_GUI is made visible.
function EigenFaces_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EigenFaces_GUI (see VARARGIN)



% % Imagenes de entrenamiento
% X=[];
% for i=1:38
%     str=strcat('YaleCropped/yale_',int2str(i),'.pgm');
%     eval('img=im2double(imread(str));');
%     [I J]=size(img);    % 
%     temp=reshape(img,(I*J),1);     %
%     X=[X temp];  
% end
% 
% [N,M]=size(X); % Numero de muestras
% 
% Imagenes originales
% Io = [];
% for i=1:M
%     Io(:,:,i) = reshape(X(:,i),I,J);
% end
% 
% for i=1:M
%     n = strcat('axes(handles.imagen_',int2str(i),'_axes);');
%     eval(n);
%     imshow(Io(:,:,i))
% end
% 
% Media (Average Face Vector)
% mx = mean(X,2);                 % Media Columnas
% avFace = reshape(mx(:,1),I,J);
% axes(handles.imagenMedia_axes)
% imshow(avFace)
% 
% handles
% handles.matrizImagenes = X;
% handles.imagenOriginal = Io;
% handles.numeroImagenes = M;
% handles.I = I;
% handles.J = J;
% handles.media = mx;


%%
% Choose default command line output for EigenFaces_GUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EigenFaces_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = EigenFaces_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_Imagenes.
function popupmenu_Imagenes_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Imagenes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Imagenes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Imagenes


% --- Executes during object creation, after setting all properties.
function popupmenu_Imagenes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Imagenes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imagen_button.
function imagen_button_Callback(hObject, eventdata, handles)
% hObject    handle to imagen_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[name path] = uigetfile({'*.pgm;*.jpg;*.tif;*.png;*.gif','All Image Files';...
'*.*','All Files' },'Imagen',...
'D:\Pictures');
file_name = [path name];
loadedFG = 0;

try
    im = imread(file_name);
    axes(handles.imagenCara_axes);
    
    P = im2double(im);
    [a b c] = size(P);

    if (c > 1)
        P = rgb2gray(P);
    end

    if (b > 168)
        P(:,169:end) = [];
    end
    
    imshow(P)
catch exception
    if loadedFG == 0
        noImageMsg = msgbox('No Images Loaded..!!');
    end
end;

% handles
handles.imagenPrueba = P;

%
set(handles.ecualizacionPrueba_button,'Enable','on')
guidata(hObject, handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over imagen_button.
function imagen_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to imagen_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function imagen_1_axes_CreateFcn(hObject, eventdata, handles)
% Hint: place code in OpeningFcn to populate imagen_1_axes



function eigenVectores_Callback(hObject, eventdata, handles)
% hObject    handle to eigenVectores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eigenVectores as text
%        str2double(get(hObject,'String')) returns contents of eigenVectores as a double


% --- Executes during object creation, after setting all properties.
function eigenVectores_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eigenVectores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eigenVectores_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eigenVectores_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eigenVectores_edit as text
%        str2double(get(hObject,'String')) returns contents of eigenVectores_edit as a double


% --- Executes during object creation, after setting all properties.
function eigenVectores_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eigenVectores_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in eigenFaces_button.
function eigenFaces_button_Callback(hObject, eventdata, handles)

% Autovectores
K = str2double(get(handles.eigenVectores_edit,'string'));
X = handles.matrizImagenes;
M = handles.numeroImagenes;
I = handles.I;
J = handles.J;
mx = handles.media;

% Imagen - media
for i=1:M, 
    Xm(:,i) = X(:,i) - mx; 
end 

% Matriz de covarianza Cx
Cx=Xm'*Xm/(M-1);


% Autovalores y Autovectores
[V,S]   = eig(Cx);
eigval  = diag(S);
[Y,ind] = sort(abs(eigval));
eigval  = eigval(flipud(ind));  % Autovalores en orden decreciente
V       = V(:,flipud(ind));    % Matriz de autovectores ordenada

% POrcentaje
eigTotal = sum(eigval);

% Autovectores de A*A'
u = Xm*V;
for i=1:K
    u(:,i) = u(:,i)/norm(u(:,i));   % Normalizaci?n de los Eigenvectores
end

% Eigenfaces
EigF = [];
for i=1:K
    EigF(:,:,i) = reshape(u(:,i),I,J);
end

EigF = double(EigF);

% Intervalo de autovectores a usar
u = u(:,1:K);

% Intervalo de autovalores a usar
eigCortado = eigval(1:K);
sumEigCortado = sum(eigCortado);

% Porcentaje
porcentaje = (sumEigCortado / eigTotal)*100;

set(handles.variacion_edit,'string',num2str(porcentaje));
set(handles.umbral_button,'enable','on');
% Pesos (w)
w = u'* Xm;     % Transformada de Hotelling

% Reconstruccion de datos
Mx = repmat(mx,1,M);
XX = u*w+Mx;

%% Reconstrucci?n de matrices (imagenes originales)
Ir = [];
for i=1:M
    Ir(:,:,i) = reshape(XX(:,i),I,J);
end

% handles
handles.covarianza = Cx;
handles.eigenVectores = u;
handles.eigenFaces = EigF;
handles.numeroEigenVectores = K;
handles.pesos = w;
handles.imagenesReconstruidas = Ir;

%
guidata(hObject, handles);

EigenFaces_show

set(handles.imReconstruidas_button,'Enable','on')


% --- Executes on button press in imReconstruidas_button.
function imReconstruidas_button_Callback(hObject, eventdata, handles)
EigenFaces_reconstruidas


% --- Executes on button press in cara_button.
function cara_button_Callback(hObject, eventdata, handles)

%% - Reconociemiento ------------------------------------------------------
% Imagen de prueba
P = handles.imagenPrueba;
mx = handles.media;
w = handles.pesos;
u = handles.eigenVectores;
K = handles.numeroEigenVectores;
I = handles.I;
J = handles.J;
T = handles.umbral;

% P = im2double(P);
% 
% [a b c] = size(P);
% 
% if (c > 1)
%     P = rgb2gray(P);
% end
% 
% if (b > 168)
%     P(:,169:end) = [];
% end

Xp = zeros(I*J,1);
Xp(:,1) = reshape(P',1,I*J);

% Normalizar
Xpm(:,1) = Xp(:,1) - mx;

% Pesos (w)
wp = u'* Xpm;

% Distancia (Euclidiana)
d=zeros(K:1);
for i=1:K
    d(i) = sqrt(sum(abs(wp-w(:,i)).^2));
end
e = min(d);

% Clasificacion
%T = 35;          % Umbral
disp('El minimo error fue de');disp(e);

if (e <= T)
    msgbox(' CARA ');
else
    msgbox(' NO CARA ')
end


% --- Executes on button press in equalizacion_button.
function equalizacion_button_Callback(hObject, eventdata, handles)
Io = handles.imagenOriginal;
M = handles.numeroImagenes;
I = handles.I;
J = handles.J;

Feq = uint8(zeros(I,J,M));
for im=1:M
    
    f = im2uint8(Io(:,:,im));
    
    L = 256; %numero de niveles de gris
    H = zeros(1,L);
    HEq = zeros(1,L);

    [m,n] = size(f);

    % Histograma
    for i=1:1:m
        for j=1:1:n
          H(f(i,j)+1) = H(f(i,j)+1) + 1;  
        end
    end

    % Probabilidad
    p = H/(m*n);

    % Probabilidad acumulada
    P = zeros(1,L);
    for i=1:1:L
        if i == 1
            P(i) = p(i);
        else
            P(i) = P(i-1) + p(i);
        end 
    end

    % Funcion de distribucion
    gmax = 255; gmin = 0;
    F=zeros(256,1);
    for i=1:1:L
      F(i) = round((gmax - gmin)*P(i) + gmin);
    end

    % Imagen Ecualizada
    for i=1:m
        for j=1:n
            Feq(i,j,im) = F(f(i,j)+1);
        end
    end

    % Histograma ecualizado
    for i=1:1:m
        for j=1:1:n
          HEq(Feq(i,j,im)+1) = HEq(Feq(i,j,im)+1) + 1;  
        end
    end
    
end

%% Nueva X
Feq = im2double(Feq);
for i=1:38
    X(:,i)=reshape(Feq(:,:,i),(I*J),1);
end

%% Actualizacion de imagenes
for i=1:M
    n = strcat('axes(handles.imagen_',int2str(i),'_axes);');
    eval(n);
    imshow(Feq(:,:,i))
end

% Media (Average Face Vector)
mx = mean(X,2);                 % Media Columnas
avFace = reshape(mx(:,1),I,J);
axes(handles.imagenMedia_axes)
imshow(avFace)

% handles
handles.matrizImagenes = X;
handles.imagenOriginal = Feq;
handles.media = mx;

%
set(handles.imReconstruidas_button,'Enable','off')
set(handles.cara_button,'Enable','off')
set(handles.eigenVectores_edit,'string','25')

guidata(hObject, handles);


% --- Executes on button press in ecualizacionPrueba_button.
function ecualizacionPrueba_button_Callback(hObject, eventdata, handles)
P = handles.imagenPrueba;
P = histeq(P,255);

axes(handles.imagenCara_axes);
imshow(P)

% handles
handles.imagenPrueba = P;
set(handles.cara_button,'Enable','on')

guidata(hObject, handles);


% --- Executes on button press in entrenamiento_button.
function entrenamiento_button_Callback(hObject, eventdata, handles)

%% Imagenes de entrenamiento
X=[];
for i=1:38
    str=strcat('YaleCropped/yale_',int2str(i),'.pgm');
    eval('img=im2double(imread(str));');
    [I J]=size(img);    % 
    temp=reshape(img,(I*J),1);     %
    X=[X temp];  
end

[N,M]=size(X); % Numero de muestras

% Imagenes originales
Io = [];
for i=1:M
    Io(:,:,i) = reshape(X(:,i),I,J);
end

for i=1:M
    n = strcat('axes(handles.imagen_',int2str(i),'_axes);');
    eval(n);
    imshow(Io(:,:,i))
end

% Media (Average Face Vector)
mx = mean(X,2);                 % Media Columnas
avFace = reshape(mx(:,1),I,J);
axes(handles.imagenMedia_axes)
imshow(avFace)

% handles
handles.matrizImagenes = X;
handles.imagenOriginal = Io;
handles.numeroImagenes = M;
handles.I = I;
handles.J = J;
handles.media = mx;

%
set(handles.equalizacion_button,'Enable','on')
set(handles.eigenFaces_button,'Enable','on')

% Update handles structure
guidata(hObject, handles);



function variacion_edit_Callback(hObject, eventdata, handles)
% hObject    handle to variacion_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of variacion_edit as text
%        str2double(get(hObject,'String')) returns contents of variacion_edit as a double


% --- Executes during object creation, after setting all properties.
function variacion_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variacion_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in umbral_button.
function umbral_button_Callback(hObject, eventdata, handles)

% handles
mx = handles.media;
w = handles.pesos;
u = handles.eigenVectores;
K = handles.numeroEigenVectores;
I = handles.I;
J = handles.J;

% directorio de imagenes de prueba
path = uigetdir('C:\Users\Jesus\Documents\MATLAB\Computer Vision\Eigenfaces\','Directorio de imágenes')

loadedFG = 0;

try
    e = zeros(100,1);
    for i=1:2
        
        str=strcat(path,'\imagen_',int2str(i),'.jpg')
        eval('P=im2double(imread(str));');

        [a b c] = size(P);
        
         if (c > 1)
            P = rgb2gray(P);
        end
        if (a > 192)
            P(193:end,:) = [];
        end
        if (b > 168)
            P(:,169:end) = [];
        end       
               
        P = histeq(P,255);
        
        Xp = zeros(I*J,1);
        Xp(:,1) = reshape(P',1,I*J);
        
        % Normalizar
        Xpm(:,1) = Xp(:,1) - mx;

        % Pesos (w)
        wp = u'* Xpm;

        % Distancia (Euclidiana)
        d=zeros(K:1);
        for j=1:K
            d(j) = sqrt(sum(abs(wp-w(:,j)).^2));
        end

        e(i) = min(d);

    end
    T = max(e);

    
catch exception
    if loadedFG == 0
        noImageMsg = msgbox('No se seleccionó ningún directorio');
    end
end;

set(handles.umbral_edit,'string',num2str(T));
% handles
handles.umbral = T;
set(handles.imagen_button,'Enable','on')

% Update handles structure
guidata(hObject, handles);



function umbral_edit_Callback(hObject, eventdata, handles)
% hObject    handle to umbral_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of umbral_edit as text
%        str2double(get(hObject,'String')) returns contents of umbral_edit as a double


% --- Executes during object creation, after setting all properties.
function umbral_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to umbral_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
