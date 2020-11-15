%BERNARD Clément et METAIS Julien
function [ energy ] = getEnergy( img )
%GETENERGY Retourne la carte d'énergie des pixels d'une image
%   Diverses possibilités : Norme L1, L2, L2^2 du gradient, Saillance,
%   Détecteur de Harris, Détection de visage, entropie, etc...
%   La fonction doit pouvoir fonctionner avec un nombre indéfini de canaux !

	% TODO : Question 1
%     energy = ones(size(img,1),size(img,2));
    
      % Calcul du gradient 
      [Fx,Fy] = gradient(img);
      % Norme L2 
      energy = sqrt(Fx.^2 + Fy.^2); 
      % Somme sur tous les channels 
      energy = sum(energy , 3 );
    
    
    
end

