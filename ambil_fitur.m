clc; clear; close all; warning off all;

nama_folder = 'data latih';
nama_file = dir(fullfile(nama_folder,'*.jpeg'));
jumlah_file = numel(nama_file);

for n = 1 : jumlah_file
    images  = imread(fullfile(nama_folder, nama_file(n).name));
  
    % Warna
    rataR(n)=mean(mean(images(:,:,1)));
    rataG(n)=mean(mean(images(:,:,2)));
    rataB(n)=mean(mean(images(:,:,3)));
    stdR(n)=std(std(double(images(:,:,1))));
    stdG(n)=std(std(double(images(:,:,2))));
    stdB(n)=std(std(double(images(:,:,3))));
    skewnR(n)=skewness(skewness(double(images(:,:,1))));
    skewnG(n)=skewness(skewness(double(images(:,:,2))));
    skewnB(n)=skewness(skewness(double(images(:,:,3)))) ;
    entropR(n)=entropy(double(images(:,:,1)));
    entropG(n)=entropy(double(images(:,:,2)));
    entropB(n)=entropy(double(images(:,:,3)));
    
    % Bentuk
    grays = rgb2gray(images);
    bw = im2bw(grays,graythresh(grays));
    [B, L] = bwboundaries(bw, 'noholes');
    statis = regionprops(L, 'All');
    area(n) = statis.Area;
    perimeter(n) = statis.Perimeter;
    metric(n) = 4*pi*area(n)/(perimeter(n)^2);
    majoraxis(n) = statis.MajorAxisLength;
    minoraxis(n) = statis.MinorAxisLength;
    eccentricity(n) = statis.Eccentricity;
      
end
input = [area;perimeter;metric;majoraxis;minoraxis;eccentricity; rataR;rataG;rataB;stdR;stdG;stdB;skewnR;skewnG;skewnB; entropR;entropG;entropB];
target(1:80) = 1;
target(81:160) = 2;

rng('default');
net = newff(input,target,[10 5],{'logsig','logsig'}, 'trainlm');
% melakukan pelatihan jaringan
net = train(net,input,target); 
% membaca nilai keluaran janringan
output = round(sim(net,input));
%xlswrite('warna', warna);
%xlswrite('tekstur', tekstur);
%xlswrite('bentuk', bentuk);

save net net