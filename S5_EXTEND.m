%扩展数据

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

CNN_X=zeros(24,24,1,74*6);%
CNN_X(:,:,1,1:74)=sq_extend_CNN_X{1};
CNN_X(:,:,1,75:148)=sq_extend_CNN_X{2};
CNN_X(:,:,1,149:222)=sq_extend_CNN_X{3};
CNN_X(:,:,1,223:296)=sq_extend_CNN_X{4};
CNN_X(:,:,1,297:370)=sq_extend_CNN_X{5};
CNN_X(:,:,1,371:444)=sq_extend_CNN_X{6};
lab=csvread('label.csv');
label=[lab lab lab lab lab lab];
[trainset_index_a,valiset_index_a]=get_trainset_valiset_index(lab);%划分训练集和验证集索引
trainset_index_b=[trainset_index_a 74+trainset_index_a 148+trainset_index_a 222+trainset_index_a 296+trainset_index_a 370+trainset_index_a];
valiset_index_b=[valiset_index_a 74+valiset_index_a 148+valiset_index_a 222+valiset_index_a 296+valiset_index_a 370+valiset_index_a];

% CNN_X=sq_extend_CNN_X{1};
% label=csvread('label.csv');
ML_X=zeros(74*6,576);
for i=1:74*6
    ML_X(i,:)=reshape(CNN_X(:,:,1,i),[1,576]);%
end



