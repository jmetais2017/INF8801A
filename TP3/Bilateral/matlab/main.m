% Fonction principale du TP sur le filtre bilatéral

clc
clear all
close all

%% Denoising
% Il s'agit d'une simple application du filtre bilatéral.

noise = rgb2hsv(imread('../data/taj-rgb-noise.jpg'));
figure;
imshow(noise(:,:,3)); title('Image originale (bruitée)');


% TODO Question 1 :

%Application du filtre bilatéral
filtered = bilateralFilter(noise(:,:,3), [], 0, 1, 10, 0.2); %sigmaSpatial et sigmaRange déterminés expérimentalement

result = noise;
result(:,:,3) = filtered;
result = hsv2rgb(result); %Reconversion en RGB
figure;
imshow(result); title('Image filtrée');



%% Tone mapping
% Il s'agit de compresser la plage d'intensités d'une image en préservant
% les détails. Pour cela, on diminue les contrastes globaux en conservant
% les contrastes locaux.

% Lecture de l'image hdr (à partir de 3 expositions différentes)
srcFolder = '../data/hdr/memorial/'; ext = '.png';
src = double(imread([srcFolder 'low' ext])) + double(imread([srcFolder 'mid' ext])) + double(imread([srcFolder 'high' ext]));

src_hsv = rgb2hsv(src); %Conversion dans l'espace HSV
src_V = src_hsv(:,:,3); %Extraction du canal V


% Réduction d'histogramme
red_src = src - min(src(:));
red_src = red_src./max(red_src(:));
figure; imshow(red_src); title('Réduction uniforme linéaire');


% Filtre Gaussien 

gauss_hsv = src_hsv; %On part de l'ipmage HSV
gauss_V = src_V; %On filtre sur le canal V
filtered_gauss = imgaussfilt(gauss_V, 12);

% Filtre passe-haut 
gauss_V = gauss_V - filtered_gauss; %Extraction des hautes fréquences de l'image en soustrayant la version floutée

%Normalisation
gauss_V = gauss_V - min(gauss_V);
gauss_V = gauss_V./max(gauss_V);
gauss_hsv(:,:,3) = gauss_V;
gaussian = hsv2rgb(gauss_hsv); %Reconversion en RGB

%Normalisation du résultat
gaussian = gaussian - min(gaussian(:));
gaussian = gaussian./max(gaussian(:));
figure; imshow(gaussian); title('Passe-haut Gaussien');


% Filtre Bilateral

bil_hsv = src_hsv; %On part de l'ipmage HSV
bil_V = src_V; %On filtre sur le canal V
filtered_bil = bilateralFilter(bil_V, [], min(bil_hsv(:)), max(bil_hsv(:)), 256, 0.09*max(bil_hsv(:))); %On utilise un sigmaSpatial élevé (ici 50% de la largeur de l'image)

% Filtre passe-haut 
bil_V = bil_V - filtered_bil; %Extraction des hautes fréquences de l'image en soustrayant la version floutée

%Normalisation
bil_V = bil_V - min(bil_V);
bil_V = bil_V./max(bil_V);
bil_hsv(:,:,3) = bil_V;
bilateral = hsv2rgb(bil_hsv); %Reconversion en RGB

%Normalisation du résultat
bilateral = bilateral - min(bilateral(:));
bilateral = bilateral./max(bilateral(:));
figure; imshow(bilateral); title('Passe-haut bilatéral');























