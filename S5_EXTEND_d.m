%扩展数据 插值，旋转，噪声 ----- CNN迁移学习

clear all
% close all

X=cell(1,74);
for i=1:74
    X{i}=csvread(strcat('vehicle_data/',string(i-1),'.csv'));%载入
end


sq_extend_CNN_X=cell(1,6);
sq_extend_CNN_X{1}=data_extend(X,'nearest');
sq_extend_CNN_X{2}=data_extend(X,'bilinear');
sq_extend_CNN_X{3}=data_extend(X,'bicubic');

sq_extend_CNN_X{4}=data_extend_b(X,'nearest');
sq_extend_CNN_X{5}=data_extend_b(X,'bilinear');
sq_extend_CNN_X{6}=data_extend_b(X,'bicubic');

CNN_X=zeros(24,24,1,74*6);
CNN_X(:,:,1,1:74)=sq_extend_CNN_X{1};
CNN_X(:,:,1,75:148)=sq_extend_CNN_X{2};
CNN_X(:,:,1,149:222)=sq_extend_CNN_X{3};
CNN_X(:,:,1,223:296)=sq_extend_CNN_X{4};
CNN_X(:,:,1,297:370)=sq_extend_CNN_X{5};
CNN_X(:,:,1,371:444)=sq_extend_CNN_X{6};
% figure
% imshow(CNN_X(:,:,1,70));
% figure
% Y = imrotate(CNN_X(:,:,1,70),90,'bilinear','crop');
% imshow(Y);
CNN_X_ROTA=zeros(24,24,1,74*6*8);

angles=[0 90 180 270 45 135 225 315];
for team_numb=1:8
    for j=1:444
    CNN_X_ROTA(:,:,1,(team_numb-1)*444+j)=imrotate(CNN_X(:,:,1,j),angles(team_numb),'bicubic','crop');
    end
   
end

CNN_X_ROTA_NOISE=zeros(24,24,1,74*6*8*4);

noises={'gaussian', 'poisson', 'salt & pepper', 'speckle'};
for team_numb=1:4
    for j=1:444*8
        CNN_X_ROTA_NOISE(:,:,1,(team_numb-1)*444*8+j)=imnoise(CNN_X_ROTA(:,:,1,j),noises{team_numb});
    end
end






label_ROTA_NOISE=zeros(1,74*6*8*4);
lab=csvread('label.csv');
for team_numb=1:6*8*4
    temp_index=(team_numb-1)*74+1;
    label_ROTA_NOISE(temp_index:temp_index+73)=lab;%
    
end
[trainset_index,valiset_index]=get_trainset_valiset_index(label_ROTA_NOISE);%划分训练集和验证集索引

% CNN_X=sq_extend_CNN_X{1};
% label=csvread('label.csv');




