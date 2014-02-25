function [eigValues, eigVectors, avFace, eigFaces, mx, w] = PCA(Im, numVectors)


[I,J] = size(Im(:,:,1));

%% Nueva X
Feq = im2double(Im);
for i=1:38
    X(:,i)=reshape(Im(:,:,i),(I*J),1);
end

[N,M] = size(X);

%% Numero de Autovectores
K = numVectors;

%% Media (Average Face Vector)
mx = mean(X,2);                 % Media Columnas
avFace = reshape(mx(:,1),I,J);

%% Imagen - media
for i=1:M,
    Xm(:,i) = X(:,i) - mx;
end

%% Matriz de covarianza Cx
Cx=Xm'*Xm/(M-1);


%% Autovalores y Autovectores
[V,S]   = eig(Cx);
eigval  = diag(S);
[Y,ind] = sort(abs(eigval));
eigval  = eigval(flipud(ind));  % Autovalores en orden decreciente
V       = V(:,flipud(ind));    % Matriz de autovectores ordenada

%% Autovectores de A*A'
u = Xm*V;
for i=1:K
    u(:,i) = u(:,i)/norm(u(:,i));   % Normalizaci?n de los Eigenvectores
end

%% Eigenfaces
EigF = zeros(I,J,M);
for i=1:K
    EigF(:,:,i) = reshape(u(:,i),I,J);
end

EigF = double(EigF);

%% Gr?fica de eigenvalores
%plot(eigval);                       % Grafica eigenvalores

%% Intervalo de autovectores a usar
u = u(:,1:K);

%% Pesos (w)
w = u'* Xm;     % Transformada de Hotelling

%%
eigValues = eigval;
eigVectors = u;
eigFaces = EigF;

end