function [ dst ] = poissonBlending( src, target, alpha )
%POISSONBLENDING Effectue un collage avec la méthode de Poisson
%   Remplit la zone de 'src' où 'alpha'=0 avec le laplacien de 'target'

    % Le problème de Poisson s'énonce par :
    % 'le laplacien de src est égal à celui de target là où alpha=0'
    % Pour résoudre ce problème, on utilise la méthode de Jacobi :
    % à chaque itération, un pixel est égal à la moyenne de ses voisins +
    % la valeur du laplacien cible
    
    % TODO Question 2 :
    
    %On calcule le laplacien de la cible
    A=[0 -1 0 ; -1 4 -1 ; 0 -1 0];
    lap = double(imfilter(target, A));
    
    h = size(src, 1)
    w = size(src, 2)
    
    %Pour l'initialisation, on colle directement la cible dans l'image
    alpha = double(repmat(alpha,[1,1,3]));
    alpha = alpha./max(alpha(:));    
    dst = double(src) .* alpha + double(target) .* (1-alpha);

    prev_dst = dst;
    
    N = 20; %Le nombre d'itérations
    
    %On propage itérativement le laplacien par méthode de Jacobi
    for n = 1:N
        for i = 1:h
            for j = 1:w
                if alpha(i,j)==0.0 %On ne traite que les pixels cilbés par le masque
                    dst(i, j,:) = 0.25 * lap(i, j,:); %Valeur du laplacien cible
                    if j>1
                        dst(i, j,:) = dst(i, j,:) + 0.25 * prev_dst(i, j-1,:); %Moyenne des voisins
                    end
                    if j<w
                        dst(i, j,:) = dst(i, j,:) + 0.25 * prev_dst(i, j+1,:);
                    end
                    if i>1
                        dst(i, j,:) = dst(i, j,:) + 0.25 * prev_dst(i-1, j,:);
                    end
                    if i<h
                        dst(i, j,:) = dst(i, j,:) + 0.25 * prev_dst(i+1, j,:);
                    end
                end
            end
        end
        prev_dst = dst; %On stocke l'image à l'itération précédente pour poursuivre la récursion
    end
    
    dst = uint8(dst);
    
end

