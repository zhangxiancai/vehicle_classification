%��չ����_c,��������ȡ

clear all
% close all

X=cell(1,74);
ML_X=zeros(74,827*70);
CNN_X=zeros(70,827,1,74);
for i=1:74
    X{i}=csvread(strcat('vehicle_data/',string(i-1),'.csv'));%����
    
    CNN_X(:,:,1,i)=imresize(X{i},[70,827],'bicubic');
    ML_X(i,:)=reshape(imresize(X{i}',[70,827],'bicubic'),[1,827*70]);
end



label=csvread('label.csv');
[trainset_index_a,valiset_index_a]=get_trainset_valiset_index(label);%����ѵ��������֤������



