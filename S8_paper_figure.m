%论文中的图片

% clear all
% r_data=csvread('vehicle_data/1.csv');
% plot(r_data(2,2:end));xlabel('Index');ylabel('Amplitude');



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

%%%%%%%%
%三维图
clear all
close all
r_car=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_三辆_汽车.txt');
r_bus=csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche_b.txt');
r_truck=csvread('C:\D\TD_DATA\2021-4-15_data\radar_new_kache_b.txt');
figure;
plot(mean(r_car(:,2:end)'));
figure;
plot(mean(r_bus(:,2:end)'));
figure;
plot(mean(r_truck(:,2:end)'));
% r_mesh=[r_car(16000:18000,2:end);r_bus(400:1800,2:end)];
% r_mesh=[r_car(16420:16520,:);r_car(16300:16360,:);r_bus(850:1200,:);r_truck(10200:10300,:)];
r_mesh=[r_car(16420:16560,:);r_car(16280:16360,:);r_bus(860:1200,:);r_truck(4500:4600,:)];

 csvwrite('r_mesh_4.csv',r_mesh);
figure
mesh(r_mesh(:,2:end)');xla=xlabel('Measurement Counts');yla=ylabel('Sample Counts');zlabel('Amplitude');
xlim([0,700]);ylim([0,830]); set(yla,'Rotation',-40); 

figure
plot(mean(r_mesh(:,2:end)'));xlabel('Measurement Counts');ylabel('Averaged Amplitude');legend('averaged data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%车辆检测结果图

r_mesh=csvread('r_mesh_4.csv');
r_bus=r_mesh;
[r_n,r_s]=size(r_bus);

r_mean=zeros(1,r_n);%均值
r_state=zeros(1,r_n);
count=r_n;

baseline=106;%
save_baseline=zeros(1,r_n);
thre=zeros(1,r_n);
for i=1:count
    %     norm_data(i,:)=norm_down_signal(r_data(i,2:end));
    r_mean(i)=mean(r_bus(i,2:end));
    thre(i)=baseline*1.2;%
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
legend('averaged data','threhold','S(t)');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
%
l=r_state;
l_g=17;%
d_x=my_dilate(l,l_g);
c_d_x=my_erode(d_x,l_g);
c_c_d_x=my_erode(c_d_x,l_g);
d_c_c_d_x=my_dilate(c_c_d_x,l_g);

figure
plot(r_mean);hold on
plot(500*r_state+200,'-.');hold on
plot(500*d_c_c_d_x+1000,':');
legend('averaged data','S(t)','filtered result');xlabel('Measurement Counts');ylabel('Averaged Amplitude');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%车辆样本图片，resized车辆样本，波峰
clear all
r_mesh=csvread('r_mesh_4.csv');
figure;
% subplot(1,2,1);imshow(mat2gray(r_mesh(291:318,2:end)'));
% subplot(1,2,2);imshow(mat2gray(r_mesh(658:828,2:end)'));
subplot(4,1,1);
mesh(r_mesh(45:69,2:end)');zlabel('Amplitude');xlim([0,200]);zlim([0,9200]);ylim([0,830]);
subplot(4,1,2);
mesh(r_mesh(176:201,2:end)');zlabel('Amplitude');xlim([0,200]);zlim([0,9200]);ylim([0,830]);
subplot(4,1,3);
mesh(r_mesh(288:487,2:end)');zlabel('Amplitude');xlim([0,200]);zlim([0,9200]);ylim([0,830]);
subplot(4,1,4);
mesh(r_mesh(588:619,2:end)');xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');
xlim([0,200]);zlim([0,9200]);ylim([0,830]);

%25 26 200 32
figure;
subplot(4,1,1);
mesh(imresize(r_mesh(45:69,2:end)',[827,16],'bilinear'));zlabel('Amplitude');xlim([0,16]);zlim([0,9200]);ylim([0,830]);
subplot(4,1,2);
mesh(imresize(r_mesh(176:201,2:end)',[827,16],'bilinear'));zlabel('Amplitude');xlim([0,16]);zlim([0,9200]);ylim([0,830]);
subplot(4,1,3);
mesh(imresize(r_mesh(288:487,2:end)',[827,16],'bilinear'));zlabel('Amplitude');xlim([0,16]);zlim([0,9200]);ylim([0,830]);
subplot(4,1,4);
mesh(imresize(r_mesh(588:619,2:end)',[827,16],'bilinear'));xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');
xlim([0,16]);zlim([0,9200]);ylim([0,830]);


figure;
car=imresize(r_mesh(45:69,2:end)',[827,16],'bilinear');
SUV=imresize(r_mesh(176:201,2:end)',[827,16],'bilinear');
bus=imresize(r_mesh(288:487,2:end)',[827,16],'bilinear');
truck=imresize(r_mesh(588:619,2:end)',[827,16],'bilinear');
% subplot(1,4,1);plot(r_mesh(292,2:end));xlabel('Sample Counts');ylabel('Amplitude');
subplot(1,3,1);plot(car(2:end,5)');xlabel('Sample Counts');ylabel('Amplitude');title('Vehicle entering');
subplot(1,3,2);plot(car(2:end,10)');xlabel('Sample Counts');title('entering');title('Vehicle');
subplot(1,3,3);plot(car(2:end,15)');xlabel('Sample Counts');title('entering');title('Vehicle leaving');

figure;
for i=1:16
    subplot(2,8,i);
    plot(car(2:end,i)');
%     hold on;plot(SUV(2:end,i)'); hold on; plot(bus(2:end,i)');hold on; plot(truck(2:end,i)');
    ylim([0,8000]);
    if i==1
   xlabel('Sample Counts');ylabel('Amplitude'); 
%    legend('car','SUV','bus','middle-truck');
    end
    title(['mc=',num2str(i)]);
end

[comp_temp_1,comp_temp_2]=get_maxfeature_signal_new(car(2:end,2)');
figure;%候选点，波峰
plot(medfilt(medianfilt(car(2:end,2)',26),13));xlabel('Sample Counts');ylabel('Amplitude');ylim([0,8000]);
hold on; plot(comp_temp_1(1:30,1),comp_temp_1(1:30,2),'.','MarkerSize',15);
%legend('Smoothed Envelope data','Candidate points');
hold on; plot(comp_temp_2(1:3,1),comp_temp_2(1:3,2),'+');legend('Smoothed Envelope data','Candidate points','Wave crests');

figure;
plot(car(2:end,5)','*-');xlabel('Sample Counts');ylabel('Amplitude');ylim([0,3000]);
hold on; plot(medianfilt(car(2:end,5)',26));
hold on; plot(medfilt(medianfilt(car(2:end,5)',26),13));legend('Envelope data','median filter','median and mean filter');

%%%%%%%%%%%%%%%%%%%%%%%
%vehicle detection parameters
clear all
r_bus2=csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche_b.txt');
r_bus3=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche.txt');
r_bus4=csvread('C:\D\TD_DATA\2021-3-18_data\radar_new_keche_b.txt');
r_car=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_三辆_汽车.txt');
r_bus=[r_bus2;r_bus3(309:14000,:);r_bus4(1:8600,:);r_car];
res0=experiment_vehicle_detection(r_bus,50,1.2);
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


%speed estimation figure
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interpolation figure

clear all
acc_ne=csvread('acc_nearest.txt');
acc_li=csvread('acc_bilinear.txt');
acc_cu=csvread('acc_bicubic.txt');

acc_ne_s=csvread('acc_nearest_s.txt');

res=[acc_ne;acc_li;acc_cu;acc_ne_s];
figure;plot(sum(res(:,1:10)')/10);
figure;plot(res(1,:));hold on;plot(res(2,:));hold on;plot(res(3,:));
figure;plot(acc_ne);hold on;plot(acc_ne_s);


