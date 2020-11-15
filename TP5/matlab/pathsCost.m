%BERNARD Clément et METAIS Julien
function [ costs ] = pathsCost( energy )
%PATHCOST Retourne le tableau avec l'énergie cumulée minimale pour 
%   atteindre le bord du haut (avec une seam) en partant de chacun des 
%   pixels. Obtenue par programmation dynamique (du haut vers le bas).

    % TODO : Question 2
    costs = zeros(size(energy));
    
    % On initialise la premiere ligne comme etant l energie 
    costs(1,:) = energy(1,:);
    
    % Nombre de lignes de l'energy
    n = size(energy,1);
    % Nombre de colomnes de l'energy
    m = size(energy, 2);
    % Boucle sur les lignes 
    for i = 2 : n 
        % Boucle sur les colonnes 
        for j = 1 : m  
            
            if j == m 
                % L'indice j+1 n est pas atteignable 
                costs(i,j) = energy(i,j) + min(  costs(i-1, j-1),  costs(i-1,j) ) ;
                
            elseif j == 1 
                % L'indice j-1 n'est pas atteignable
                costs(i,j) = energy(i,j) + min(  costs(i-1,j)  , costs(i-1, j+1) );
            else 
                
                costs(i,j) = energy(i,j) + min(  min(costs(i-1, j-1),  costs(i-1,j) ) , costs(i-1, j+1) );
                
            end
            
            
        end 
        
    end 
    
    
    
    
    
    
    
    
    
    

end

