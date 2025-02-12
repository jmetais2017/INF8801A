classdef descZernike
    %DESCZERNIKE Descripteur de forme de Zernike
    %   Utilise les moments de Zernike :
    %   on convolue la forme avec chaque polyn�me    
    
    properties (Constant = true) % variables statiques
        
        resolution = 256; % resolution en pixels des polyn�mes
        maxOrder = 10; % ordre maximal des polyn�mes
        % tableau contenant tous les polyn�mes de zernike
        polynoms = descZernike.getPolynoms();
        descSize = size(descZernike.polynoms,3); % nombre de valuers de moments
    end
    
    methods (Static = true)
        
        % retourne le polyn�me de zernike d'ordres suivants :
        % n -> ordre radial
        % m -> order angulaire
        function polynom = getPolynom( m, n )
            
            w = descZernike.resolution;
           
%             Initialisation du polynome 
            polynom = zeros(w,w);            
%             Valeurs centr�es entre [-1,1]
            x = linspace(-1,1,w);
            
            [X,Y] = meshgrid(x,x);
%             Calcul de rho 
            rhos = sqrt(X^2 + Y^2);
%             Calcul de theta
            thetas = atan2(Y,X);
           
             for p=1:w 
                 
                 for l=1:w
                     
 %                   Distance Euclidienne entre l'origine de l'image et le
 %                   pixel
                     r = rhos(p,l);
 %                     Angle entre l'axe (Ox) et le pixel
                     theta = thetas(p,l);
                     
                     % Calcul de la composante radiale 
                     radial = 0 ;
                              
                     for k = (m-abs(n))/2
         %                 Fraction avec les factorielles 
                         fraction = factorial(m-k) / (factorial(k) * factorial((m+abs(n))/2-k) * factorial((m-abs(n))/2-k  ) );
                         radial = radial + (-1)^k * fraction * r^(m-2*k);
             
                     end
%                       Polynome 
                     polynom(p,l) = radial * exp(i * m * theta);
                    
                 end 
             
             end 
             
      
        end
        
        % calcule tout un set de polyn�mes de Zernike
        function polynoms = getPolynoms()
           
            polynoms = descZernike.getPolynom(0,0);
            for m = 1:descZernike.maxOrder
                for n = m:-2:0
                   polynom = descZernike.getPolynom( m, n );
                   polynoms(:,:,end+1) = polynom;
                end
            end
        end
        
        % redimensionne et translate une forme sur le disque unitaire
        function dst = rescale(shape)
             
             shape = double(shape);
             
             h = size(shape,1);
             w = size(shape,2);
             
             % on calcule le centre de la forme
             yCoords = repmat(linspace(1,h,h)',[1 w]);
             xCoords = repmat(linspace(1,w,w),[h 1]);
             % barycentre
             yCenter = round(mean(mean(shape.*yCoords))/mean(mean(shape)));
             xCenter = round(mean(mean(shape.*xCoords))/mean(mean(shape)));
             
             % on calcule le rayon maximal de la forme
             xCoords = xCoords-xCenter; yCoords = yCoords-yCenter;
             rCoords = (xCoords.*xCoords + yCoords.*yCoords).^0.5;
             rValues = rCoords.*(shape./max(shape(:)));
             rMax = floor(max(rValues(:)));
             
             % on recentre et redimensionne la forme
             dst = shape( max(1,yCenter-rMax) : min(yCenter+rMax,h), ...
                 max(1,xCenter-rMax) : min(xCenter+rMax,w) );
             dst = imre(dst,size(shape));
        end
    end
    
    properties
       values; % r�ponses aux polyn�mes de Zernike
    end
    
    methods
        
         % constructeur (� partir d'une image blanche sur noire)
         function dst = descZernike(shape)
             
             % TODO Question 2 :


               [w,w,degre] = size(descZernike.polynoms);
%              Initialisation 
               dst.values = zeros(1,degre);
%                 On redimensionne la forme afin qu'elle occupe tout le
%                 disque unitaire 
                new_shape = rescale(shape);
%               Boucle sur les degr�s
                for i=1:degre 
                    
%                    On multiplie la forme avec le polynome 
                    somme = new_shape .* descZernike.polynoms(:,:,i) ;                    
                    
%                     Somme le tout 
                    dst.values(i) = abs(sum(somme(:))) ;
                end
                
         end
         
        % distance entre deux descripteurs
        function d = distance(desc1, desc2)
            d = mean(abs(desc1.values - desc2.values));
        end
    end
end

