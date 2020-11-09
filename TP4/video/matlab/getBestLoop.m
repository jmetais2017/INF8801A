%BERNARD Clément et METAIS Julien


function [ startFrame, endFrame ] = getBestLoop( src, minLength )
%GETBESTLOOP Calcule la paire de frames la plus ressemblante
%   minLength correspond à la taille minimale de la boucle vidéo
%   src correspond à une tableau 4D des pixels de la vidéo (w,h,col,frames)

    % TODO : Question 1
    
%   Nombre de frames 
    n_frames = size(src, 4);
%   Matrice des distances entre deux frames 
    distance = zeros(n_frames, n_frames);
    
    for i = 1 : n_frames 
        
        for j = 1 : n_frames 
            
            diff = src(:,:,:,i) - src(:,:,:,j);
            diff = single((mean(diff, 3)*255.0));
%           Distance l2 entre Ii et Ij 
            distance(i,j) = norm(diff,2);
      
        end 
        
    end 
        
    
%   Controle le nombre de frames consecutifs considérés  
    m = max(10, minLength);
%   Coefficients pour mettre le mouvement plus coherent    
   w = linspace(10, 0 , 2*m);

%   Matrice avec le calcul des nouvelles distances   
    distance_ = distance; 
    
    for i = 1 : n_frames 
        
        for j = 1 : n_frames 
            
            new_d = 0 ;
            for k = -m : m-1
               
%                 Regler les problemes des bords 
                    if i+k < 1  
                        index_i = 1 ;
                    elseif i+k > n_frames 
                        index_i = n_frames;
                    else 
                        index_i = i+k;  
                    end
                    if j+k < 1 
                        index_j = 1;
                    elseif j+k > n_frames 
                        index_j = n_frames;
                    else 
                        index_j = j+k;
                    end 
                    
                    new_d = new_d + w(1, k+m+1 ) * distance(index_i, index_j); 
            end
            distance_(i,j) = new_d;
%           Si la distance est plus petite que minLength, on met une
%           distance tres grande 
            if abs(i-j) < minLength 
               distance_(i,j) = 1e20; 
            end
        end 
        
    end 
    
%   Calcul de l'argmin 
    distance_(1,:),
%   On initialise a i = 1 et j = 5 (arbitraire)
    min_distance = distance_(1,5);
    startFrame = 1;
    endFrame = 5 ;
    
    for i = 1 : n_frames 
        
        for j = 1 : n_frames 
            
            if distance_(i,j) < min_distance 
               startFrame = i;
               endFrame = j;
               min_distance = distance_(i,j);
            end
        
        end 
        
    end
    
    
end

