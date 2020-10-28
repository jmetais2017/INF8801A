% Fonction principale du TP sur le filtre bilat�ral

clc
clear all
close all

%% Denoising
% Il s'agit d'une simple application du filtre bilat�ral.

noise = rgb2hsv(imread('../data/taj-rgb-noise.jpg'));
figure;
imshow(noise(:,:,3)); title('Image originale (bruit�e)');


% TODO Question 1 :
filtered = medfilt2(noise(:,:,3), [ 5 5 ], 'symmetric');
figure;
imshow(filtered); title('Image filtr�e');

%% Tone mapping
% Il s'agit de compresser la plage d'intensit�es d'une image en pr�servant
% les d�tails. Pour cela, on diminue les contrastes globaux en conservant
% les contrastes locaux.

% lecture de l'image hdr (� partir de 3 expositions diff�rentes)
srcFolder = '../data/hdr/memorial/'; ext = '.png';
src = double(imread([srcFolder 'low' ext])) + double(imread([srcFolder 'mid' ext])) + double(imread([srcFolder 'high' ext]));

% normalisation
src = src - min(src(:));
src = src./max(src(:));
figure; imshow(src); title('Réduction uniforme linéaire');

% Filtrage avec filtres Gaussien et bilatéral (Question 2)

% Filtre Gaussien 

src = double(imread([srcFolder 'low' ext])) + double(imread([srcFolder 'mid' ext])) + double(imread([srcFolder 'high' ext]));
% Image avec les basses frequences : passe-bas

gaussian = imgaussfilt(src);
% On soustrait le resultat du passe-bas pour obtenir un passe-haut
src = src - gaussian;

figure; imshow(src); title('Gaussian');


% Filtre Bilateral 

src = double(imread([srcFolder 'low' ext])) + double(imread([srcFolder 'mid' ext])) + double(imread([srcFolder 'high' ext]));

% Utilisation d'un patch pour observer le bruit de l'image 
patch = imcrop(src,[50,50,50,50]);
% Calcul de la variance du bruit 
patchVar = std2(patch)^2;
% Degree de variation du filtre doit etre superieur au bruit de l'image 
degree = 2*patchVar;
bilateral = imbilatfilt(src,degree,2);

% Filtre passe-haut 
src = src - bilateral;
figure; imshow(src); title('Bilateral');
















