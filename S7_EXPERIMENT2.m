% 实验结果 car SUV bus truck
clear all
close all

% r_bus=csvread('C:\D\TD_DATA\2021-4-15_data\radar_new_kache_b.txt');
r_bus1=csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche.txt');
r_bus2=csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche_b.txt');
r_bus3=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche.txt');
r_bus4=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche_b.txt');
r_bus=[r_bus1; r_bus2; r_bus3; r_bus4];
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
l_g=25;
d_x=my_dilate(l,l_g);
c_d_x=my_erode(d_x,l_g);
c_c_d_x=my_erode(c_d_x,l_g);
d_c_c_d_x=my_dilate(c_c_d_x,l_g);

figure
plot(r_mean);hold on
plot(500*r_state+200,'-.');hold on
 plot(500*d_c_c_d_x+1000);hold on
plot(500*medianfilt(r_state,50)+1600);
legend('averaged data','result of step 1','filtered result','medianfilt');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
%%%%%%%%%%%%%%%%%
d_c_c_d_x_a=[d_c_c_d_x,0];
d_c_c_d_x_b=[0,d_c_c_d_x];
DI_S=d_c_c_d_x_a-d_c_c_d_x_b;figure;plot(DI_S);ylim([-2,2]);%差分


numb=0;
for i=500:r_n
 if DI_S(i)==1
     start=i-1;
 end
  if DI_S(i)==-1
     t_end=i-1;

     csvwrite(strcat('vehicle_data_bus/',string(numb),'.csv'),r_bus(start:t_end,2:end));
     numb=numb+1;
  end

end
%%%%%%%%%%%%%%%%%
clear all
l_bus=57;l_car=105;l_SUV=54;l_truck=100;
X_bus=cell(1,l_bus);
X_car=cell(1,l_car);
X_SUV=cell(1,l_SUV);
X_truck=cell(1,l_truck);


for i=1:l_bus
    X_bus{i}=csvread(strcat('vehicle_data_bus/',string(i-1),'.csv'));%载入
   
end

for i=1:l_car
    X_car{i}=csvread(strcat('vehicle_data_car/',string(i-1),'.csv'));%载入

end

for i=1:l_SUV
    X_SUV{i}=csvread(strcat('vehicle_data_SUV/',string(i-1),'.csv'));%载入
end

for i=1:l_truck
    X_truck{i}=csvread(strcat('vehicle_data_truck/',string(i-1),'.csv'));%载入
end

X=[X_car X_SUV X_bus X_truck];
label=[0*ones(1,l_car) 1*ones(1,l_SUV) 2*ones(1,l_bus) 3*ones(1,l_truck)];

% numb=0;
% for i=1:204
%    if label(i)==0||label(i)==1
%        csvwrite(strcat('vehicle_data_car/',string(numb),'.csv'),X{i});
%        numb=numb+1;
%    end
% end

RES=data_feature_extract(X);%
% RES=data_feature_extract_comp(X);%
Index=[1:316];
T_X=RES(Index,:);
T_Y=label(Index)';

%  md1=fitcensemble(T_X,T_Y,'Learners','tree','Method','Bag');
% md1=fitcecoc(T_X,T_Y,'Learners','svm','KFold',5);
md1 = TreeBagger(50,T_X,T_Y);
rf_model = compact(md1);
save('rf_model.mat','rf_model');

predict_label=predict(rf_model,T_X(1,:));

res=zeros(4,4);
[samples_count1,~]=size(T_X);
for i=1:samples_count1
    res(T_Y(i)+1,predict_label(i)+1)=res(T_Y(i)+1,predict_label(i)+1)+1;
end
res=[1 2 2 1]'.*res;

acc=(res(1,1)+res(2,2)+res(3,3)+res(4,4))/sum(res,'all');

res_acc=zeros(1,4);%精度
res_pre=zeros(1,4);%查准率
res_recall=zeros(1,4);%查全率
for i=1:4
    
    err=res(i,1)+res(i,2)+res(i,3)+res(i,4)+res(1,i)+res(2,i)+res(3,i)+res(4,i)-2*res(i,i);
    res_acc(i)=1-err/sum(res,'all');
    res_pre(i)=res(i,i)/sum(res(:,i));
    res_recall(i)=res(i,i)/sum(res(i,:));
end

% [0.9363,0.8529,0.8922,0.9951];0.8382 %所有样本37-68-54-45
% [0.9496,0.9496,0.9916,0.9916]Index=[1:119];0.9412客车+图书馆样本
% [0.9615,0.8385,0.8077,0.9769]Index=[1:45 120:204];0.7923客车+北门样本


% 0.8294 0.9546 0.7892 极大点特征+底盘高度+车长
% 0.8358 0.9496 0.7877 极大点特征+底盘高度
% 0.8206 0.9378 0.7777 极大点特征

%%%%%%%%%%%%%%
% [trainset_index,valiset_index]=get_trainset_valiset_index(label);%划分训练集和验证集索引
% layers = [
%     imageInputLayer([24 24 1])
%     
%     convolution2dLayer(3,8,'Padding','same','Stride',1)
%     batchNormalizationLayer
%     reluLayer
%     %     maxPooling2dLayer(2,'Stride',2)
%     convolution2dLayer(3,16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     maxPooling2dLayer(2,'Stride',2)
%     
%     convolution2dLayer(3,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     fullyConnectedLayer(3)
%     softmaxLayer
%     classificationLayer];
% 
% options = trainingOptions('sgdm', ...
%     'InitialLearnRate',0.01, ...
%     'MaxEpochs',8, ...
%     'Shuffle','every-epoch', ...
%     'ValidationData',{CNN_X(:,:,1,valiset_index),categorical(label(valiset_index))'},...
%     'ValidationFrequency',1, ...
%     'MiniBatchSize',8, ...
%     'Verbose',false, ...
%     'Plots','training-progress');
% net = trainNetwork(CNN_X(:,:,1,trainset_index),categorical(label(trainset_index)),layers,options);


