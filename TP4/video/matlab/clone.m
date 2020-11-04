%BERNARD Clément et METAIS Julien


function [ loop ] = clone( src, nbClones )
%CLONE Clone les personnages d'une boucle
%   src : frames de la vidéo (w,h,col,frames)
%   nbClones : nombre de clones (=0 si aucun clonage)

    % arguments par défault
    if nargin < 2, nbClones = 2; end

    % TODO : Question 2
    minLength = 25; %Longueur minimale des boucles considérées
    
    h = size(src, 1) %Résolution de la séquence vidéo
    w = size(src, 2)
    
    dst = double(src) / 255.0;
    [startFrame, endFrame] = getBestLoop(src, minLength); %Extraction d'une boucle
    loop = dst(:,:,:,startFrame:endFrame-1);
    
    loopLength = endFrame - startFrame; %Longueur de la boucle extraite
    offset = uint8(loopLength/(nbClones+1)); %Calcul du déphasage entre 2 clones consécutifs (en considérant une distribution linéaire)
    
    background = median(loop, 4); %Extraction de l'arrière plan par calcul de médiane
    
    masks = zeros(h, w, loopLength); %Extraction de l'avant-plan
    for i = 1:loopLength
        diff = abs(loop(:, :, :, i) - background); %Différence avec l'arrière-plan (en valeur absolue)
        gray_diff = uint8(mean(diff, 3)*255.0); %Conversion en niveaux de gris
        masks(:,:,i) = imbinarize(gray_diff); %Seuillage pour obtenir un masque binaire
    end
    
    for n = 1:nbClones %Ajout des clones dans la séquence vidéo
        for i = (n*offset+1):loopLength %Images sur lesquels sera présent le clone n
            for c = 1:3
                currentIm = loop(:, :, c, i); %Image à compléter
                pastIm = loop(:, :, c, i-n*offset); %Image à partir de laquelle on copie l'objet d'intérêt
                mask = masks(:,:,i-n*offset) > 0;
                currentIm(mask) = pastIm(mask); %Complétion de l'image courante aux positions définies par le masque
                loop(:, :, c, i) = currentIm;
            end
        end
    end
    
        
end

