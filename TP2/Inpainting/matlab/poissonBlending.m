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
    A=[-1 -1 -1; -1 8 -1; -1 -1 -1];
    lap = imfilter(double(target), A);
        
    %Pour l'initialisation, on colle directement la cible dans l'image
    alpha = double(repmat(alpha,[1,1,3]));
    alpha = alpha./max(alpha(:));    
    
    dst= double(src);
    
    N = 5000; %Le nombre d'itérations
    
   [x, y, c] = size(dst); 
   
   img = zeros(x, y, c); 
    %On propage itérativement le laplacien par méthode de Jacobi
    for n = 1:N
        
%          Chaque pixel est egal a la moyenne de ses voisins + laplacian
        img =1/9 *  (imfilter(dst, [1,1,1;1,1,1;1,1,1]) + lap);
       
%          On modifile l'image en consequence 
       dst = double(src) .* alpha + img .* (1-alpha);
        
    end 
       
%         prev_dst = dst; %On stocke l'image à l'itération précédente pour poursuivre la récursion

   
    dst = uint8(dst);
    
end

