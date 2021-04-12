%论文中的图片

% clear all
% r_data=csvread('vehicle_data/1.csv');
% plot(r_data(2,2:end));xlabel('Index');ylabel('Amplitude');

%%%%%%%%
%三维图
clear all
close all
r_car=csvread('D:\TD_DATA\2021-1-15_data\20210115_103952_三辆_汽车.txt');
r_bus=csvread('D:\TD_DATA\2021-3-18_data\radar_old_keche.txt');
plot(mean(r_car(:,2:end)'));
figure;
plot(mean(r_bus(:,2:end)'));
% r_mesh=[r_car(16000:18000,2:end);r_bus(400:1800,2:end)];
r_mesh=[r_car(15300:15700,:);r_bus(500:1000,:)];
csvwrite('r_mesh.csv',r_mesh);
figure
mesh(r_mesh(:,2:end)');xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');

figure
plot(mean(r_mesh(:,2:end)'));xlabel('Measurement Counts');ylabel('Averaged Amplitude');legend('averaged data');


%%%%%%%%%%%%%%%%%%%%%%%%%%
%数据原理图
clear all

input_radar_address='C:\D\Radartool\acconeer-python-exploration\gui\330_1102.h5';
data=h5read(input_radar_address,'/data');
[r_n,~,r_s]=size(data);
data=reshape(data,r_n,r_s);
timestamp=h5read(input_radar_address,'/sample_times');
radar_res=[timestamp*1000,double(data')];
figure;
plot(radar_res(250,2:end));
xlabel('Sample Counts');ylabel('Amplitude');
set(gca,'XTick',[200,416,600,800]);set(gca,'XTickLabel',{'200','416','600','800'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%车辆数据图片，极大点图片
clear all
r_mesh=csvread('r_mesh.csv');
figure;
% subplot(1,2,1);imshow(mat2gray(r_mesh(291:318,2:end)'));
% subplot(1,2,2);imshow(mat2gray(r_mesh(658:828,2:end)'));
mesh(r_mesh(291:318,2:end)');xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');
figure
mesh(r_mesh(658:828,2:end)');xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');

figure;
% subplot(1,4,1);plot(r_mesh(292,2:end));xlabel('Sample Counts');ylabel('Amplitude');
subplot(1,3,1);plot(r_mesh(293,2:end));xlabel('Sample Counts');ylabel('Amplitude');title('Vehicle entering');
subplot(1,3,2);plot(r_mesh(306,2:end));xlabel('Sample Counts');title('entering');title('Vehicle');
subplot(1,3,3);plot(r_mesh(312,2:end));xlabel('Sample Counts');title('entering');title('Vehicle leaving');


[comp_temp_1,comp_temp_2]=get_maxfeature_signal_new(r_mesh(293,2:end));
figure;
plot(r_mesh(293,2:end));xlabel('Sample Counts');ylabel('Amplitude');title('Vehicle entering');ylim([0,3000]);
% hold on; plot(comp_temp_1(1:32,1),comp_temp_1(1:32,2),'.');legend('Envelope data','Candidate points');
hold on; plot(comp_temp_2(1:4,1),comp_temp_2(1:4,2),'+');legend('Envelope data','Maximum points');

figure;
plot(r_mesh(293,2:end),'*-');xlabel('Sample Counts');ylabel('Amplitude');title('Vehicle entering');ylim([0,3000]);

%%%%%%%%%%%%%%%%%%%%%%%
%vehicle detection parameters
clear all
r_bus2=csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche_b.txt');
r_bus3=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche.txt');
r_bus4=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche_b.txt');
r_car=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_三辆_汽车.txt');
r_bus=[r_bus2;r_bus3(309:14000,:);r_bus4(1:8600,:);r_car];
res0=experiment_vehicle_detection(r_bus,17,1.2);
l_g=[5 7 9 11 13 15 17 19 21 23];
m_thre=[1.15 1.175 1.2 1.225 1.25 1.275 1.3];
% l_g=[5 10 15 20 25];
% m_thre=[1.15 1.2 1.25 1.3];
acc=zeros(10,7);
for i=1:10
    for j=1:7
        res=experiment_vehicle_detection(r_bus,l_g(i),m_thre(j));
        acc(i,j)=1-(sum(abs(res-res0))/7384);
    end
end
figure;
mesh(acc);xlabel('λ');ylabel('l');zlabel('Accuracy');set(gca,'XTick',[1,3, 5  7]);
set(gca,'XTickLabel',{'0.15','0.2','0.25','0.3'});
set(gca,'YTick',[1,2,3,4,5 6 7 8 9 10]);set(gca,'YTickLabel',{'5', '7','9', '11', '13', '15', '17', '19', '21', '23'});

%%%%%%%%%%%%%%%%%%%%%%%%%%
%运行速度图
clear all

S5_EXTEND;%数据
md_RF=fitcensemble(ML_X,label','Learners','tree','Method','Bag');
md_SVM=fitcecoc(ML_X,label','Learners','svm');

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
    'MiniBatchSize',8, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(CNN_X,categorical(label),layers,options);

ML_X_L=[ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X;ML_X];
total_time=zeros(3,12);
for i=1:12
    
       tic;
       for j=1:250*i
       predict(net,CNN_X(:,:,1,mod(j,440)+1));
       end
       toc;
        total_time(3,i)=toc;
    
       tic;
    for j=1:250*i
        predict(md_SVM,ML_X_L(j,:));
    end
    toc;
    total_time(2,i)=toc;
    
    tic;
    for j=1:250*i
        predict(md_RF,ML_X_L(j,:));
    end
    toc;
    total_time(1,i)=toc;
    i
end
% total_time(2,1)=12.332;
% figure;
% plot(total_time(1,:)','*-');hold on;plot(total_time(2,:)','+-');legend('VCRF','VCSVM');
% xlabel('Number of vehicle samples');ylabel('Time/s');xlim([0,13]);
% set(gca,'XTick',[2,4 6 8 10 12]);set(gca,'XTickLabel',{'500', '1000', '1500','2000', '2500','3000'});
% 
figure;
plot(total_time(1,:)','*-');hold on;plot(total_time(2,:)','+-');
hold on;plot(total_time(3,:)','o-');legend('VCRF','VCSVM','VCCNN');
xlabel('Number of vehicle samples');ylabel('Time/s');xlim([0,13]);
set(gca,'XTick',[2,4 6 8 10 12]);set(gca,'XTickLabel',{'500', '1000', '1500','2000', '2500','3000'});


%speed estimation
clear all;
r_1=csvread('D:\TD_DATA\2021-3-18_data\radar_old_keche_b.txt');
r_2=csvread('D:\TD_DATA\2021-3-18_data\radar_new_keche_b.txt');
m_r_1=mean(r_1(:,2:end)');
m_r_2=mean(r_2(:,2:end)');
% plot(mean(r_1(:,2:end)'));
% hold on;
% plot(mean(r_2(:,2:end)')+1000);
% [A,I]=max(r_2(:,2:end)');
% figure;
% plot(I);
s_1=experiment_vehicle_detection(r_1,17,1.2);
s_2=experiment_vehicle_detection(r_2,17,1.2);
% figure;
% plot(s_1);
% hold on;plot(s_2+2);
pl_1=m_r_1([1:924,1125:2246,2456:2653]);
pl_2=m_r_2([250:1361,1560:2653]);
figure;plot(pl_1(1:1000));hold on;plot(pl_2(1:1000),'-.');
hold on; plot([35],m_r_1([35]),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
hold on; plot([539],m_r_2([539]),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
xlabel('Measurement Counts');ylabel('Averaged Amplitude');ylim([1,2500]);
legend('radar_1','radar_2','vehicle entering');
