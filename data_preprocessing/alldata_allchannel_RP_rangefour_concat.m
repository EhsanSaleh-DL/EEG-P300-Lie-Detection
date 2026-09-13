clear all
close all
clc
%% RP for a signal (Truth)
Pz_T = load('C:\Users\user1\Desktop\Code_Data_kazemzadeh\RP_FzCzPz\alldata_allchannel_rangefour\T_alldata_allchannel_rangefour_concat.mat');
C = struct2cell(Pz_T);
Pz_T = cell2mat(C);

for i = 1:size(Pz_T, 2)
    x1 = Pz_T(:,i);

    t = size(Pz_T, 1);

    % We start with the assumption that the phase space is only 1-dimensional. 
    %The calculation of the distances between all points of the phase space trajectory reveals the distance matrix S.
    N1 = length(x1);
    S1 = zeros(N1, N1);


    for j = 1:N1,
        S1(:,j) = abs( repmat( x1(j), N1, 1 ) - x1(:) );
    end

    figure(1)
    imagesc(t, t, S1)
    %axis square
    axis off
    set(gca,'position',[0 0 1 1],'units','normalized')
    saveas(figure(1),strcat('C:\Users\user1\Desktop\Code_Data_kazemzadeh\RP_FzCzPz\alldata_allchannel_rangefour\T\RPT',num2str(i),'.jpg'))
end

%% RP for a signal (Lie)
Pz_L = load('C:\Users\user1\Desktop\Code_Data_kazemzadeh\RP_FzCzPz\alldata_allchannel_rangefour\L_alldata_allchannel_rangefour_concat.mat');
C = struct2cell(Pz_L);
Pz_L = cell2mat(C);

for i = 1:size(Pz_L, 2)
    x2 = Pz_L(:,i);

    t = size(Pz_L, 1);

    % We start with the assumption that the phase space is only 1-dimensional. 
    %The calculation of the distances between all points of the phase space trajectory reveals the distance matrix S.
    N2 = length(x2);
    S2 = zeros(N2, N2);


    for j = 1:N2,
        S2(:,j) = abs( repmat( x2(j), N2, 1 ) - x2(:) );
    end

    figure(2)
    imagesc(t, t, S2)
    %axis square
    axis off
    set(gca,'position',[0 0 1 1],'units','normalized')
    saveas(figure(2),strcat('C:\Users\user1\Desktop\Code_Data_kazemzadeh\RP_FzCzPz\alldata_allchannel_rangefour\L\RPL',num2str(i),'.jpg'))
end

