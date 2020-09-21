classdef descZernike
    %DESCZERNIKE Descripteur de forme de Zernike
    %   Utilise les moments de Zernike :
    %   on convolue la forme avec chaque polynôme    
    
    properties (Constant = true) % variables statiques
        
        resolution = 256; % resolution en pixels des polynômes
        maxOrder = 10; % ordre maximal des polynômes
        % tableau contenant tous les polynômes de zernike
        polynoms = descZernike.getPolynoms();
        descSize = size(descZernike.polynoms,3); % nombre de valuers de moments
    end
    
    methods (Static = true)
        
        % retourne le polynôme de zernike d'ordres suivants :
        % n -> ordre radial
        % m -> order angulaire
        function polynom = getPolynom( m, n )
            
            w = descZernike.resolution;
           
            % TODO Question 2 :
            polynom = zeros(w,w);
            
            
            for x= 1:w 
                
                for y =1 : w
                    
%                   Distance Euclidienne entre l'origine de l'image et le
%                   pixel
                    r = sqrt(power(x, 2) + power(y,2));
%                     Angle entre l'axe (Ox) et le pixel
                    theta = atan(y/x);
                    
                    % Calcul de la composante radiale 
                    radial = 0 ;
            
        %             Verifie que m-n est pair, m>0, 0<=n<=m
                    if mod(m-n,2) == 0 && m>0 && n>=0 && n<=m   
                
                    for k = (m-abs(n))/2
        %                 Fraction avec les factorielles 
                        fraction = factorial(m-k) / (factorial(k) * factorial((m+abs(n))/2-k) * factorial((m-abs(n))/2-k  ) );
                        radial = radial + (-1)^k * fraction * r^(m-2*k);
            
                    end
                    i,
                    radial * exp(i * n * theta),
                    
                    polynom(r,theta) = radial * exp(i * n * theta);
                    
                    end
                   
                end 
            
            end 
            
       
        end
        
        % calcule tout un set de polynômes de Zernike
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
             dst = imresize(dst,size(shape));
        end
    end
    
    properties
       values; % réponses aux polynômes de Zernike
    end
    
    methods
        
         % constructeur (à partir d'une image blanche sur noire)
         function dst = descZernike(shape)
             
             % TODO Question 2 :
             dst.values = zeros(1,descZernike.descSize);
         end
         
        % distance entre deux descripteurs
        function d = distance(desc1, desc2)
            d = mean(abs(desc1.values - desc2.values));
        end
    end
end

