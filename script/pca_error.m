function [e] = PCA_error(Im, eigVectors, numEig, mean, weights)

    u = eigVectors;
    mx = mean;
    K = numEig;
    w = weights;
    % Imagen de prueba
    [I, J] = size(Im);
    Xp = zeros(I*J,1);
    Xp(:,1) = reshape(Im',1,I*J);

    %% Normalizar
    Xpm(:,1) = Xp(:,1) - mx;

    %% Pesos (w)
    wp = u'* Xpm;

    %% Distancia (Euclidiana)
    d=zeros(K:1);
    for i=1:K
    D(i) = pdist([w(:,i)'; wp']);
    end

    e = min(D);

end