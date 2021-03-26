%扩展数据_c,不特征提取

clear all
% close all

X=cell(1,74);
ML_X=zeros(74,827*70);
CNN_X=zeros(70,827,1,74);
for i=1:74
    X{i}=csvread(strcat('vehicle_data/',string(i-1),'.csv'));%载入
    
    CNN_X(:,:,1,i)=imresize(X{i},[70,827],'bicubic');
    ML_X(i,:)=reshape(imresize(X{i}',[70,827],'bicubic'),[1,827*70]);
end



label=csvread('label.csv');
[trainset_index_a,valiset_index_a]=get_trainset_valiset_index(label);%划分训练集和验证集索引



