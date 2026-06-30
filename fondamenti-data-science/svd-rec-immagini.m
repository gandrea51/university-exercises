clear all; close all; clc;

load allFaces.mat               % Carichiamo le foto di 38 persone

trainingFaces = faces(:,1:sum(nfaces(1:36)));   % Costruiamo la matrice di partenza
                                                % La matrice faces contiene tutti i visi di partenza  
avgFace = mean(trainingFaces,2);                % Calcola il viso medio--> si ottiene un vettore di taglia n*m+1;

X = trainingFaces-avgFace*ones(1,size(trainingFaces,2));    % Sottrae dalla matrice contenente tutti i 
                                                            % visi il viso medio
[U,S,V] = svd(X,'econ');                        % Calcola la versione economica della SVD

figure
imagesc(reshape(avgFace,n,m)), colormap gray    % Plot del viso medio


figure
testFace = faces(:,1+sum(nfaces(1:36)));        % Plot del viso numero 37 
imagesc(reshape(testFace,n,m)), 
colormap gray
title('Viso da ricostruire');

figure
testFaceMS = testFace - avgFace;                % Calcolo delle differenze tra il viso medio e
                                                % il viso che si vuole analizzare
for r=25:25:750     %2275
    reconFace = avgFace + (U(:,1:r)*(U(:,1:r)'*testFaceMS));    % Ricostruzione del viso attraverso proiezione
                                                                % nello spazio generato dai primi 36 visi.
    imagesc(reshape(reconFace,n,m)), colormap gray
    title(['r=',num2str(r,'%d')]);
    pause(0.1)
end

figure
A=imread('dog.jpg');                            % Lettura immagine e sistemazione dati in una matrice
A=double(rgb2gray(A(100:1200,1:1000,1:3)));
X=imresize(A,[n m]);
imagesc(X) 
colormap gray
title('Viso da ricostruire');
testFace=reshape(X,n*m,1);
imagesc(reshape(testFace,n,m)), 

figure
testFaceMS = testFace - avgFace;                % Calcolo delle differenze tra il viso medio e il viso che si vuole 
                                                % analizzare
for r=25:50:1750
    reconFace = avgFace + (U(:,1:r)*(U(:,1:r)'*testFaceMS));    % Ricostruzione del viso attraverso proiezione
                                                                % nello spazio generato dai primi 36 visi.
    imagesc(reshape(reconFace,n,m)), colormap gray
    title(['r=',num2str(r,'%d')]);
    pause(0.1)
end

figure
A=imread('gerry.jpg');                           % Lettura immagine e sistemazione dati in una matrice
A=double(rgb2gray(A(800:2200,900:1800,1:3)));
X=imresize(A,[n m]);
imagesc(X) 
colormap gray
title('Viso da ricostruire');
testFace=reshape(X,n*m,1);
imagesc(reshape(testFace,n,m)), 

figure
testFaceMS = testFace - avgFace;                    % Calcolo delle differenze tra il viso medio e
                                                    % il viso che si vuole analizzare
for r=25:50:2225
    reconFace = avgFace + (U(:,1:r)*(U(:,1:r)'*testFaceMS));    % Ricostruzione del viso attraverso proiezione
                                                                % nello spazio generato dai primi 36 visi.
    imagesc(reshape(reconFace,n,m)), colormap gray
    title(['r=',num2str(r,'%d')]);
    pause(0.1)
end
