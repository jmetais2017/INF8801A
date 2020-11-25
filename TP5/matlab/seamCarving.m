%BERNARD Clément et METAIS Julien
function [ dst ] = seamCarving( src, newHeight, newWidth )
%SEAMCARVING Redimensionne une image en préservant son contenu
%   Ne supprime que les pixels ne contenant pas d'information
%   Calcule d'abord la carte d'energie de l'image (contenu)
%   Puis calcule des 'seam' à enlever de l'image,
%   par programmation dynamique
%   Attention : src et dst peuvent avoir un nombre quelconque de canaux (4
%   ou plus, par exemple).

    % On redimensionne horizontalement
    dst = resizeH( src, newWidth );
    
    % On redimensionne verticalement
    dst = permute( dst,[2,1,3] ); % on tourne de 90deg
    dst = resizeH( dst, newHeight );
    dst = permute( dst,[2,1,3] );
end

% redimensionne horizontalement une image
function [ dst ] = resizeH( src, newWidth )

    % Choisit entre enlever ou ajouter des pixels
    if newWidth < size(src,2)
        dst = shrinkH( src, newWidth );
    else
        dst = enlargeH( src, newWidth );
    end
end

% Supprime des seams verticales
function dst = shrinkH( src, newWidth )

    % TODO : Question 3
    height = size(src,1);
    width = size(src,2);
    nb_seams = width - newWidth; %Calcul du nombre de seams à retirer
    
    dst = src;
    
    for k = 1:nb_seams
        new_dst = ones(height, size(dst,2) - 1, size(dst,3)); %Création d'une nouvelle image de taille réduite
        energy = getEnergy(dst); %Calcul de l'énergie de l'image courante
        costs = pathsCost(energy);
        seam = getSeam(costs); %Calcul du seam à retirer
        for i = 1:height %Retrait du seam ligne par ligne
            seam_id = seam(i);
            new_dst(i,:,:) = cat(2, dst(i,1:(seam_id-1),:), dst(i,(seam_id+1):size(dst,2),:)); 
        end
        dst = new_dst; %Mise à jour de l'image courante
    end 
end

% Duplique les pixels de seams verticales
function dst = enlargeH( src, newWidth )

    % TODO : Question 4
    height = size(src,1);
    width = size(src,2);
    nb_seams = newWidth - width; %Calcul du nombre de seams à ajouter
    
    dst = src;
    energy = getEnergy(dst); %Calcul de l'énergie de l'image initiale
    
    for k = 1:nb_seams
        new_dst = ones(height, size(dst,2) + 1, size(dst,3)); %Création d'une nouvelle image de taille augmentée
        new_energy = ones(height, size(dst,2) + 1); %Carte d'énergie associée à la nouvelle image
        costs = pathsCost(energy);
        seam = getSeam(costs); %Calcul du seam à dupliquer
        for i = 1:height
            seam_id = seam(i);
            new_dst(i,:,:) = cat(2, dst(i,1:(seam_id),:), dst(i,(seam_id):size(dst,2),:)); %Duplication du seam dans la nouvelle image
            new_energy(i,:) = cat(2, energy(i,1:(seam_id - 1),:), 1.5*transpose([energy(i,seam_id); energy(i,seam_id)]), energy(i,(seam_id + 1):size(dst,2),:)); %Modification de la carte d'énergie
        end
        dst = new_dst; %Mise à jour de l'image courante
        energy = new_energy;
    end     
end