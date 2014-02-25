%% Detecci?n de caras por medio del An?lisis por Componentes Principales (PCA)


%%
clc
clear all;

%% Imagenes de entrenamiento

Im=[];
for i=1:38
    str=strcat('../YaleCropped/yale_',int2str(i),'.pgm');
    eval('img=im2double(imread(str));');
    Im(:,:,i)=img;  
end

%%
% Se hace una ecualizaci?n del histograma a las im?genes de entrenamiento
%%

for i=1:38
    Im(:,:,i) = histeq(Im(:,:,i),256);
end

%% Imagenes de prueba
Im_p = [];
numIm = 100;
for i=1:1:numIm
    str = strcat('C:\Users\Jesus\Pictures\Images_DataBases\BioID\BioID_',sprintf('%.4d',i),'.pgm');
    eval('Im_p(:,:,i)=im2double(imread(str));')
end

%%
% De igual forma las im?genes de prueba son ecualizadas
%%

for i=1:numIm
    Im_p(:,:,i) = histeq(Im_p(:,:,i),256);
end


%% Imagenes Escaladas

%%
% Se hace primero la reducci?n de las im?genes de prueba a un 20% de su
% tama?o original, de 286x384 a 58x77
%%
escala = 0.2;

Im_p_m = [];
for i=1:numIm
    Im_p_m(:,:,i) = imresize(Im_p(:,:,i),escala);
end

[I,J,L] = size(Im_p_m);


%%
% Tres diferentes tama?os de las im?genes de
% entrenamiento dependiendo de la escala de las im?genes de prueba. Se
% hicieron mediciones de tres im?genes diferentes y se encontr? un
% aproximado de la proporci?n de la cara con el resto de la imagen para
% escoger la escala.

%%
Im_m = [];
[col, fil] = size(Im_p_m(:,:,1));


% % Imagen 37
% for i=1:38
%     Im_m(:,:,i) = imresize(Im(:,:,i),[fil/3.2, col/3.6]);
% end

% Imagen 16
% for i=1:38
%     Im_m(:,:,i) = imresize(Im(:,:,i),[fil/3.2, col/2.7]);
% end

% Imagen 90
for i=1:38
    Im_m(:,:,i) = imresize(Im(:,:,i),[fil/3.8, col/2]);
end

% Imagen 5
% for i=1:38
%     Im_m(:,:,i) = imresize(Im(:,:,i),[fil/2.96, col/2.2]);
% end


%% An?lisis por Componentes Principales
% Para ahorrar espacio en el c?digo se hicieron dos funciones para el
% an?lisis por componentes principales, la primera tiene como prototipo:
%
% *|[eigValues, eigVectors, avFace, eigFaces, media, weights] = PCA(Imagen,K)|*
%
% donde:
%
% * *|eigValues|*: Eigen Valores
% * *|eigVectors|*: Eigen Vectores
% * *|avFace|*: Cara Media
% * *|eigFaces|*: Eigen Caras
% * *|media|*: Media
% * *|weights|*: Pesos
% * *|Imagen|*: Imagenes de entrenamiento
% * *|K|*: N?mero de Autovectores a usar

%%
% De pruebas anteriores se obtuvo que al usar 25 eigen vectores, se utiliza
% el 90% de la informaci?n necesaria para la reconstrucci?n de las im?genes.
%%
K = 25;     % Numero de Eigenvectors

%%
[eigValues, eigVectors, avFace, eigFaces, media, weights] = PCA(Im_m,K);
%%
[J,I] = size(avFace); 
tamano = (size(Im_p_m(:,:,1))-size(Im_m(:,:,1)));
N = tamano(1);
M = tamano(2);

%% Cara Promedio
figure(1)
imshow(avFace,'InitialMagnification',900)

%% Imagen de prueba
% Anteriormente se cargaron varias im?genes de prueba, para mostrar el
% funcionamiento de este programa se elige una imagen de prueba de la cual
% se obtuvo uno de los valores de escala, por ejemplo la imagen n?mero 16
%%
imagen = 90;
%%
% Se obtienen (N-J)*(M-I) segmentos de la imagen original de tama?o J x I,
% donde: [N x M] es el tama?o de la imagen de prueba  y [J x I] es el
% tama?o de las imagenes de entrenamiento. Es decir, para esta escala en
% particular se obtuvieron 33*55 = 1815 im?genes cada una de tama?o 25x22
%%
Im_p_R = [];    
tic;    % Inicia el reloj
i=1;
for m=1:M
    for n=1:N
       Im_p_R(:,:,i) = Im_p_m(n:J+n-1,m:I+m-1,imagen);
       i=i+1;
    end
end

%% Error m?nimo
% Una vez obtenidas todos los segmentos de la imagen de prueba, se pocede a
% hacer la reconstrucci?n de cada una para obtener el segmento con el error
% m?nimo el cual, idealmente, correspondr? a la cara dcaraEncontradaetectada.
% Este proceso se realiza con la segunda funci?n hecha:
%
% *|[error] = pca_error(Segmentos, eigVectors, K, media, wights)|*
%
% donde:
%
% * *|error|*: Error m?nimo con respecto al conjunto de eigen caras
% * *|Segmentos|*: Segmentos de la imagen de prueba
% * *|K|*: N?mero de Autovectores a usar
% * *|media|*: Media
% * *|weights|*: Pesos

%%
for i=1:M*N
    e(i) = pca_error(Im_p_R(:,:,i),eigVectors, K, media, weights);
end

%%
% El vector *|e|* contiene el error m?nimo de cada uno de los segmentos
% probados, es decir este vector es de tama?no (N-J)*(M-I), para este
% ejemplo el vector de errores es de tama?o 1815
%%
% Por ?ltimo, se encuentra el valor m?nimo del vector de errores el cual
% ser? el correspondiente al segmento de la imagen original que contiene la
% cara. 
% La funci?n |[x,y]=min(e)| devuelve el valor del error m?nimo (*|x|*) y la
% posic?n (*|y|*) de ese valor en el vector |e|, de esta forma es f?cil
% conocer el segmento de la imagen que nos intereza.
%%
[x,y] = min(e);
%%
clc
disp('El minimo error fue de');disp(x);
segundos = toc;     % Paro del reloj
Tiempo = segundos/60
disp('Minutos')
%%
% Se midi? el tiempo de procesamiento a partir de la obtenci?n de los
% segmentos de la imagen original hasta la obtenci?n del error m?nimo.
%%
%% Recuadro
% Teniendo la informaci?n de la posici?n de la cara encontrada, se dibuja
% un recuadro al rededor de ?sta con la funci?n |patch|. El recadro fue
% dibujado sobre la imagen de prueba escalada, pero puede dibujarse tambi?n
% sobre la imagen de prueba original con las cuentas apropiadas que en ?ste
% c?digo aparecen como comentarios.
%%

figure(2)
imshow(Im_p_m(:,:,imagen),'InitialMagnification',800)

T = 10;
if (x < T)
    % P = I/escala;
    % Q = J/escala;

    a = floor(y/N);
    b = (y-a*N);

    % a = a/escala;
    % b = b/escala;

    % Vertices
    verts = [a b; a+I b;  a+I b+J; a b+J];

    % Cuadro
    faces = [ 1 2 3 4];

    % Propiedades del recuadro
    caraEncontrada.Vertices = verts;
    caraEncontrada.Faces = faces;
    caraEncontrada.FaceColor = 'none';
    caraEncontrada.LineStyle = '--';
    caraEncontrada.Edgecolor = 'red';
    caraEncontrada.LineWidth = 2;

    patch(caraEncontrada);
else
    disp('No se encontr? cara')
end


