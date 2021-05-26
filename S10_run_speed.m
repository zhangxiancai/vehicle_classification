%运行速度图

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


ML_X=data_feature_extract(X);%

md_RF=fitcensemble(ML_X,label','Learners','tree','Method','Bag');
md_SVM=fitcecoc(ML_X,label','Learners','svm');



X_S=[X X X X X X X X X X X X X];
total_time=zeros(3,12);
for i=1:5
    
    tic;
    for j=1:250*i
        
        predict(md_RF,vesamp_feature_extract(X_S{j}));
    end
    toc;
    total_time(1,i)=toc;
    
    
    tic;
    for j=1:250*i
       
        predict(md_SVM,vesamp_feature_extract(X_S{j}));
    end
    toc;
    total_time(2,i)=toc;
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

function RES=vesamp_feature_extract(X)
%车辆样本特征提取,先插值后提取极大值，底盘高度
%输入：原始车辆样本,method=插值方法（字符串）
%输出：(max_height*6+2,samples_count)


max_height=16;

wcre_num=2*3;


MP_X=zeros(1,max_height*wcre_num);

    resize_X=imresize(X,[max_height,827],'bilinear');%先插值
    vehicle_height=get_vehicle_height(resize_X);%

    for j=1:max_height
    [~,comp_temp_2]=get_maxfeature_signal_new(resize_X(j,:));
%     MP_X(8*j-7:8*j)=correction_method(comp_temp_2);%排序
    MP_X(wcre_num*j-wcre_num+1:wcre_num*j)=correction_method(comp_temp_2);%排序
    end
    RES=[MP_X,vehicle_height];

end

function vehicle_height=get_vehicle_height(X)
%input: one vehicle sample, ~*827
%output: height of vehicle chassis
[n,~]=size(X);
hs=zeros(1,n);
for i=1:n
comp_temp_2=(get_maxfeature_signal(X(i,:)));
[~,I]=max(comp_temp_2(:,2));
hs(i)=comp_temp_2(I,1);
end
vehicle_height=mean(hs);

end
