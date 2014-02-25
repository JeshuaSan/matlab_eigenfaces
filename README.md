<html><head></head>

<body><div class="content"><h1>Detecci&oacute;n de caras por medio del An&aacute;lisis por Componentes Principales (PCA)</h1>

 <h2>Contenido</h2>
  <div>
    <ul>
      <li><a href="#2">Imagenes de entrenamiento</a></li>
      <li><a href="#5">Imagenes de prueba</a></li>
      <li><a href="#8">Imagenes Escaladas</a></li>
      <li><a href="#13">An&aacute;lisis por Componentes Principales</a></li>
      <li><a href="#18">Cara Promedio</a></li>
      <li><a href="#19">Imagen de prueba</a></li>
      <li><a href="#23">Error m&iacute;nimo</a></li>
      <li><a href="#31">Recuadro</a></li>
    </ul>
  </div>
  <pre class="codeinput">
  clc
  clear <span class="string">all</span>;
</pre><h2>Imagenes de entrenamiento<a name="2"></a></h2><pre class="codeinput">Im=[];
<span class="keyword">for</span> i=1:38
    str=strcat(<span class="string">'../YaleCropped/yale_'</span>,int2str(i),<span class="string">'.pgm'</span>);
    eval(<span class="string">'img=im2double(imread(str));'</span>);
    Im(:,:,i)=img;
<span class="keyword">end</span>
</pre><p>Se hace una ecualizaci&oacute;n del histograma a las im&aacute;genes de entrenamiento</p><pre class="codeinput"><span class="keyword">for</span> i=1:38
    Im(:,:,i) = histeq(Im(:,:,i),256);
<span class="keyword">end</span>
</pre><h2>Imagenes de prueba<a name="5"></a></h2><pre class="codeinput">Im_p = [];
numIm = 80;
<span class="keyword">for</span> i=1:1:numIm
    str = strcat(<span class="string">'C:\Users\Jesus\Pictures\Images_DataBases\BioID\BioID_'</span>,sprintf(<span class="string">'%.4d'</span>,i),<span class="string">'.pgm'</span>);
    eval(<span class="string">'Im_p(:,:,i)=im2double(imread(str));'</span>)
<span class="keyword">end</span>
</pre><p>De igual forma las im&aacute;genes de prueba son ecualizadas</p><pre class="codeinput"><span class="keyword">for</span> i=1:numIm
    Im_p(:,:,i) = histeq(Im_p(:,:,i),256);
<span class="keyword">end</span>
</pre><h2>Imagenes Escaladas<a name="8"></a></h2><p>Se hace primero la reducci&oacute;n de las im&aacute;genes de prueba a un 20% de su tama&ntilde;o original, de 286x384 a 58x77</p><pre class="codeinput">escala = 0.2;

Im_p_m = [];
<span class="keyword">for</span> i=1:numIm
    Im_p_m(:,:,i) = imresize(Im_p(:,:,i),escala);
<span class="keyword">end</span>

[I,J,L] = size(Im_p_m);
</pre><p>Tres diferentes tama&ntilde;os de las im&aacute;genes de entrenamiento dependiendo de la escala de las im&aacute;genes de prueba. Se hicieron mediciones de tres im&aacute;genes diferentes y se encontr&oacute; un aproximado de la proporci&oacute;n de la cara con el resto de la imagen para escoger la escala.</p><pre class="codeinput">Im_m = [];
[col, fil] = size(Im_p_m(:,:,1));


<span class="comment">% % Imagen 37</span>
<span class="comment">% for i=1:38</span>
<span class="comment">%     Im_m(:,:,i) = imresize(Im(:,:,i),[fil/3.2, col/3.6]);</span>
<span class="comment">% end</span>

<span class="comment">% Imagen 16</span>
<span class="keyword">for</span> i=1:38
    Im_m(:,:,i) = imresize(Im(:,:,i),[fil/3.2, col/2.7]);
<span class="keyword">end</span>

<span class="comment">% % Imagen 70</span>
<span class="comment">% for i=1:38</span>
<span class="comment">%     Im_m(:,:,i) = imresize(Im(:,:,i),[fil/2.6, col/1.8]);</span>
<span class="comment">% end</span>
</pre><h2>An&aacute;lisis por Componentes Principales<a name="13"></a></h2><p>Para ahorrar espacio en el c&oacute;digo se hicieron dos funciones para el an&aacute;lisis por componentes principales, la primera tiene como prototipo:</p><p><b><tt>[eigValues, eigVectors, avFace, eigFaces, media, weights] = PCA(Imagen,K)</tt></b></p><p>donde:</p><div><ul><li><b><tt>eigValues</tt></b>: Eigen Valores</li><li><b><tt>eigVectors</tt></b>: Eigen Vectores</li><li><b><tt>avFace</tt></b>: Cara Media</li><li><b><tt>eigFaces</tt></b>: Eigen Caras</li><li><b><tt>media</tt></b>: Media</li><li><b><tt>weights</tt></b>: Pesos</li><li><b><tt>Imagen</tt></b>: Imagenes de entrenamiento</li><li><b><tt>K</tt></b>: N&uacute;mero de Autovectores a usar</li></ul></div><p>De pruebas anteriores se obtuvo que al usar 25 eigen vectores, se utiliza el 90% de la informaci&oacute;n necesaria para la reconstrucci&oacute;n de las im&aacute;genes.</p><pre class="codeinput">K = 25;     <span class="comment">% Numero de Eigenvectors</span>
</pre><pre class="codeinput">[eigValues, eigVectors, avFace, eigFaces, media, weights] = PCA(Im_m,K);
</pre><pre class="codeinput">[J,I] = size(avFace);
tamano = (size(Im_p_m(:,:,1))-size(Im_m(:,:,1)));
N = tamano(1);
M = tamano(2);
</pre><h2>Cara Promedio<a name="18"></a></h2><pre class="codeinput">figure(1)
imshow(avFace,<span class="string">'InitialMagnification'</span>,900)
</pre><img vspace="5" hspace="5" src="script/html/Eigenfaces_escala_01.png" alt=""> <h2>Imagen de prueba<a name="19"></a></h2><p>Anteriormente se cargaron varias im&aacute;genes de prueba, para mostrar el funcionamiento de este programa se elige una imagen de prueba de la cual se obtuvo uno de los valores de escala, por ejemplo la imagen n&uacute;mero 16</p><pre class="codeinput">imagen = 16;
</pre><p>Se obtienen (N-J)*(M-I) segmentos de la imagen original de tama&ntilde;o J x I, donde: [N x M] es el tama&ntilde;o de la imagen de prueba  y [J x I] es el tama&ntilde;o de las imagenes de entrenamiento. Es decir, para esta escala en particular se obtuvieron 33*55 = 1815 im&aacute;genes cada una de tama&ntilde;o 25x22</p><pre class="codeinput">Im_p_R = [];
tic;    <span class="comment">% Inicia el reloj</span>
i=1;
<span class="keyword">for</span> m=1:M
    <span class="keyword">for</span> n=1:N
       Im_p_R(:,:,i) = Im_p_m(n:J+n-1,m:I+m-1,imagen);
       i=i+1;
    <span class="keyword">end</span>
<span class="keyword">end</span>
</pre><h2>Error m&iacute;nimo<a name="23"></a></h2><p>Una vez obtenidas todos los segmentos de la imagen de prueba, se pocede a hacer la reconstrucci&oacute;n de cada una para obtener el segmento con el error m&iacute;nimo el cual, idealmente, correspondr&aacute; a la cara detectada. Este proceso se realiza con la segunda funci&oacute;n hecha:</p><p><b><tt>[error] = PCA_error(Segmentos, eigVectors, K, media, wights)</tt></b></p><p>donde:</p><div><ul><li><b><tt>error</tt></b>: Error m&iacute;nimo con respecto al conjunto de eigen caras</li><li><b><tt>Segmentos</tt></b>: Segmentos de la imagen de prueba</li><li><b><tt>K</tt></b>: N&uacute;mero de Autovectores a usar</li><li><b><tt>media</tt></b>: Media</li><li><b><tt>weights</tt></b>: Pesos</li></ul></div><pre class="codeinput"><span class="keyword">for</span> i=1:M*N
    e(i) = PCA_error(Im_p_R(:,:,i),eigVectors, K, media, weights);
<span class="keyword">end</span>
</pre><p>El vector <b><tt>e</tt></b> contiene el error m&iacute;nimo de cada uno de los segmentos probados, es decir este vector es de tama&ntilde;no (N-J)*(M-I), para este ejemplo el vector de errores es de tama&ntilde;o 1815</p><p>Por &uacute;ltimo, se encuentra el valor m&iacute;nimo del vector de errores el cual ser&aacute; el correspondiente al segmento de la imagen original que contiene la cara. La funci&oacute;n <tt>[x,y]=min(e)</tt> devuelve el valor del error m&iacute;nimo (<b><tt>x</tt></b>) y la posic&oacute;n (<b><tt>y</tt></b>) de ese valor en el vector <tt>e</tt>, de esta forma es f&aacute;cil conocer el segmento de la imagen que nos intereza.</p><pre class="codeinput">[x,y] = min(e);
</pre><pre class="codeinput">disp(<span class="string">'El minimo error fue de'</span>);disp(x);
segundos = toc;     <span class="comment">% Paro del reloj</span>
Tiempo = segundos/60
disp(<span class="string">'Minutos'</span>)
</pre><pre class="codeoutput">El minimo error fue de
    4.2101


Tiempo =

    0.3031

Minutos
</pre><p>Se midi&oacute; el tiempo de procesamiento a partir de la obtenci&oacute;n de los segmentos de la imagen original hasta la obtenci&oacute;n del error m&iacute;nimo.</p><h2>Recuadro<a name="31"></a></h2><p>Teniendo la informaci&oacute;n de la posici&oacute;n de la cara encontrada, se dibuja un recuadro al rededor de &eacute;sta con la funci&oacute;n <tt>patch</tt>. El recadro fue dibujado sobre la imagen de prueba escalada, pero puede dibujarse tambi&eacute;n sobre la imagen de prueba original con las cuentas apropiadas que en &eacute;ste c&oacute;digo aparecen como comentarios.</p><pre class="codeinput">figure(2)
imshow(Im_p_m(:,:,imagen),<span class="string">'InitialMagnification'</span>,800)

<span class="comment">% P = I/escala;</span>
<span class="comment">% Q = J/escala;</span>

a = floor(y/N);
b = (y-a*N);

<span class="comment">% a = a/escala;</span>
<span class="comment">% b = b/escala;</span>

<span class="comment">% Vertices</span>
verts = [a b; a+I b;  a+I b+J; a b+J];

<span class="comment">% Cuadro</span>
faces = [ 1 2 3 4];

<span class="comment">% Propiedades del recuadro</span>
caraEncontrada.Vertices = verts;
caraEncontrada.Faces = faces;
caraEncontrada.FaceColor = <span class="string">'none'</span>;
caraEncontrada.LineStyle = <span class="string">'--'</span>;
caraEncontrada.Edgecolor = <span class="string">'red'</span>;
caraEncontrada.LineWidth = 2;

patch(caraEncontrada);
</pre><img vspace="5" hspace="5" src="script/html/Eigenfaces_escala_02.png" alt=""> <p class="footer"><br>
</body></html>
