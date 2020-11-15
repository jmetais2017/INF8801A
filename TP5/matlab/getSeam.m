%BERNARD Clément et METAIS Julien
function [ seam ] = getSeam( costs )
%GETSEAM Retourne la seam verticale (un indice par ligne) de coût minimal
%   Remonte les coûts calculés pas la fonction "pathsCost"

    % TODO : Question 2
    h = size(costs,1);
    seam = ones(h,1);
    % Nombre des colonnes 
    k = size(costs,2);
    % Compteur pour savoir ou est le current min 
    indice = 0;
    % Boucle sur les lignes en commencant par le bas 
    for i = h :-1: 2
        
        if i == h
            % On choisit la seam qui minimise le cout minimal 
            [M , indice] = min(costs(i,:));
            seam(i) = indice;
           
        else 
           
            % On evite de depasser les bords de l'image 
            if indice == k 
                indice = indice -1 ;
            elseif indice == 1 
                indice = indice+1;
            end 

           % On choisit l'indice voisin qui minimise la distance             
           propos = [  costs( i-1, indice-1  ), costs(i-1, indice), costs(i-1, indice+1)]; 
           [M, index] = min(propos);
           if index == 1 
                indice = indice-1;
           elseif index == 3
                indice = indice+1;
           end
           
           seam(i) = indice;
                  
        end 
        
        
    end 
    
    
end

