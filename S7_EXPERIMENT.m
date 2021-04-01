% 实验结果
clear all
close all
% r_bus1=csvread('D:\TD_DATA\2021-3-18_data\radar_old_keche.txt');
r_bus2=csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche_b.txt');
r_bus3=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche.txt');
r_bus4=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche_b.txt');
r_car=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_三辆_汽车.txt');
r_bus=[r_bus2;r_bus3(309:14000,:);r_bus4(1:8600,:);r_car];
% r_bus=csvread('D:\TD_DATA\2021-3-19_data\radar_old_beimen_b.txt');
% r_bus=csvread('r_mesh.csv');
% r_bus=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche_b.txt');
[r_n,r_s]=size(r_bus);

r_mean=zeros(1,r_n);%均值
r_state=zeros(1,r_n);
count=r_n;

baseline=106;
save_baseline=zeros(1,r_n);
thre=zeros(1,r_n);
for i=1:count
    %     norm_data(i,:)=norm_down_signal(r_data(i,2:end));
    r_mean(i)=mean(r_bus(i,2:end));
    thre(i)=baseline*1.2;
    if r_mean(i)>thre(i)
        r_state(i)=1;
        
    else
        baseline=0.8*baseline+0.2*r_mean(i);
    end
    save_baseline(i)=baseline;
end
figure
plot(r_mean(1:count));hold on;plot(thre,'--');
hold on;plot(500*r_state(1:count)+200,'-.');
legend('averaged data','threhold','result of step 1');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
% ylim([0,2]);

% r_f_temp_f=[0,r_state];
% r_f_temp_b=[r_state,0];
% figure
% plot(r_f_temp_b-r_f_temp_f);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l=r_state;
l_g=17;
d_x=my_dilate(l,l_g);
c_d_x=my_erode(d_x,l_g);
c_c_d_x=my_erode(c_d_x,l_g);
d_c_c_d_x=my_dilate(c_c_d_x,l_g);

figure
plot(r_mean);hold on
plot(500*r_state+200,'-.');hold on
plot(500*d_c_c_d_x+1000);
legend('averaged data','result of step 1','filtered result');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
% 
% d_c_c_d_x_a=[d_c_c_d_x,0];
% d_c_c_d_x_b=[0,d_c_c_d_x];
% DI_S=d_c_c_d_x_a-d_c_c_d_x_b;figure;plot(DI_S);ylim([-2,2]);%差分
% 
% 
% % numb=0;
% % for i=2:r_n
% %  if DI_S(i)==1
% %      start=i-1;
% %  end
% %   if DI_S(i)==-1
% %      t_end=i-1;
% %
% %      csvwrite(strcat('vehicle_data_cars/',string(numb),'.csv'),r_bus(start:t_end,2:end));
% %      numb=numb+1;
% %   end
% %
% % end
%%%%%%%%%%%%%%%%%
clear all
X_bus=cell(1,45);
X_car=cell(1,74);
X_car2=cell(1,85);
samples_count=45+74+85;
X=cell(1,samples_count);
for i=1:45
    X_bus{i}=csvread(strcat('vehicle_data_bus/',string(i-1),'.csv'));%载入
    X{i}=X_bus{i};
end

for i=1:74
    X_car{i}=csvread(strcat('vehicle_data/',string(i-1),'.csv'));%载入
    X{i+45}=X_car{i};
end

for i=1:85
    X_car2{i}=csvread(strcat('vehicle_data_cars/',string(i-1+24),'.csv'));%载入
    X{i+45+74}=X_car2{i};
end

CNN_X=data_extend(X,'bicubic');
label=csvread('label.csv');
label_cars=csvread('label_cars_25_end.csv');
label=[3*ones(1,45),label,label_cars(sort([1:85],'descend'))];

% ML_X=CNN_X;
ML_X=zeros(samples_count,576);
for i=1:samples_count
    ML_X(i,:)=reshape(CNN_X(:,:,1,i),[1,576]);
end

  md1=fitcensemble(ML_X(1:119,:),label(1:119)','Learners','tree','Method','Bag','KFold',5);
% md1=fitcecoc(ML_X,label','Learners','svm','KFold',5);
predict_label=kfoldPredict(md1);



res=zeros(4,4);
samples_count1=119;
for i=1:samples_count1
    res(label(i)+1,predict_label(i)+1)=res(label(i)+1,predict_label(i)+1)+1;
end

acc=(res(1,1)+res(2,2)+res(3,3)+res(4,4))/(samples_count1);


[trainset_index,valiset_index]=get_trainset_valiset_index(label);%划分训练集和验证集索引
layers = [
    imageInputLayer([24 24 1])
    
    convolution2dLayer(3,8,'Padding','same','Stride',1)
    batchNormalizationLayer
    reluLayer
%     maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
 
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',8, ...
    'Shuffle','every-epoch', ...
     'ValidationData',{CNN_X(:,:,1,valiset_index),categorical(label(valiset_index))'},...
    'ValidationFrequency',1, ...
    'MiniBatchSize',8, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(CNN_X(:,:,1,trainset_index),categorical(label(trainset_index)),layers,options);


