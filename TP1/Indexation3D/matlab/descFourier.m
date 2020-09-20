classdef descFourier
    %DESCFOURIER Descripteur de forme de Fourier
    %   calcule le contour de la forme, et retourne
    %   sa transformée de Fourier normalisée
    
    properties (Constant = true)
        nbPoints = 128; % nombre de points du contour
        descSize = 16; % fréquences du spectre à conserver
    end
    
    properties
       values; % spectre du contour (taille 'nbFreq') 
    end
    
    methods
         % constructeur (à  partir d'une image blanche sur noire)
         function dst = descFourier(shape)
             
            % Vous pouvez utiliser les fonctions matlab :
            % bwtraceboundary, interp1, etc..
            
            % TODO Question 1 :

            h = size(shape,1);
            w = size(shape,2);
            
            
            %Recherche d'un point (x, y) du contour pour initialiser le calcul
            x = -1;
            y = -1;
            found = 0;

            i = 1;
            while i<h
                k = 1;
                while k<w-1 & ~found %On balaie toute l'image jusqu'à trouver un pixel noir suivi d'un pixel blanc
                    if shape(i, k) == 0 & shape(i, k+1) > 0
                        x = k+1;
                        y = i;
                        found = 1;
                    end
                    k = k+1;
                end
                i = i+1;
            end
            
            %Calcul du contour de la silouhette
            boundary = bwtraceboundary(shape,[y x],'E', 8);

            %On ré-échantillonne la bordure obtenue sur un nombre constant de points
            boundaryLength = size(boundary, 1);
            step = boundaryLength / dst.nbPoints;
            sample = zeros(dst.nbPoints, 1);

            %Conversion de la liste de points du contour en liste de nombres complexes
            for i = 1:dst.nbPoints
                sample(i, 1) = complex(boundary(floor(step*i), 2), boundary(floor(step*i),1));
            end

            %Calcul de la transformée de Fourier de l'échantillon de nombres complexes
            spectre = fft(sample);
            
            %On rend le spectre invariant aux rotations, translations et mises à l'échelle
            spectre_invariant = abs(spectre(2:dst.nbPoints)/abs(spectre(2)));
            
            %On conserve seulement les premiers coefficients
            dst.values = spectre_invariant(1:dst.descSize)
            
         end
         
         % distance entre deux descripteurs
        function d = distance(desc1, desc2)
           
            d = mean(abs(desc1.values - desc2.values));
        end
    end
    
end

