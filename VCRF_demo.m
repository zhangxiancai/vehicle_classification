% demo
clear all
% train_rfmodel();%训练随机森林模型并保存
original_data=csvread('D:\TD_DATA\2021-1-15_data\20210115_103952_三辆_汽车.txt');%载入待检测原始数据
se_pairs=vehicle_detection(original_data,17,1.2);%车辆检测
[~,numb]=size(se_pairs);%车辆个数
types=zeros(1,numb);
for i=1:numb
    types(i)=vehicle_classification(original_data(se_pairs(1,i):se_pairs(2,i),2:end));%车辆分类
end
display(original_data,se_pairs,types);%画车辆检测和车辆分类结果图


function se_pairs=vehicle_detection(original_data,l_g,w_thre)
%车辆检测
%输入：original_data=原始数据 ~*827，l_g=结构体长度， w_thre=动态阈值的权值
%输出：起止时间对 2*~
[r_n,~]=size(original_data);
r_mean=zeros(1,r_n);
S=zeros(1,r_n);
%
%动态阈值
baseline=106;
for i=1:r_n
    r_mean(i)=mean(original_data(i,2:end));%均值
    thre=baseline*w_thre;%动态阈值
    if r_mean(i)>thre
        S(i)=1;%
    else
        baseline=0.8*baseline+0.2*r_mean(i);%更新基准线
    end  
end
%
S_filt=my_dilate(my_erode(my_erode(my_dilate(S,l_g),l_g),l_g),l_g);%闭开运算
S_filter_diff=[S_filt,0]-[0,S_filt];%差分
% figure;plot(500*S);hold on;plot(500*S_filt+600);hold on;plot(r_mean);
% figure;plot(S_filter_diff);ylim([-2,2]);

%统计起止时间
numb=length(find(S_filter_diff==-1));%车辆样本个数
se_pairs=zeros(2,numb);
j=0;
for i=1:r_n+1
    if S_filter_diff(i)==1
        t_start=i;
        tag=1;
    end
    if S_filter_diff(i)==-1&&tag==1
        t_end=i-1;
        tag=0;
        j=j+1;
        se_pairs(:,j)=[t_start,t_end];
    end  
end
end

function type=vehicle_classification(X)
%车辆分类
%输入：原始车辆样本 ~*827
%输出：类别
m=16;%样本宽度
crests=zeros(1,m*6);

resize_X=imresize(X,[m,827],'bilinear');%调整大小
for j=1:m
    crests(6*j-6+1:6*j)=get_crests(resize_X(j,:));%计算波峰
end
vehicle_height=get_vehicle_height(resize_X);%计算底盘高度

load rf_model.mat %load the trained random forest model
type=predict(rf_model,[crests,vehicle_height]);
end

function vehicle_height=get_vehicle_height(vehicle_sample)
%输入: 车辆样本  16*827 
%输出: 底盘高度
[n,~]=size(vehicle_sample);
hs=zeros(1,n);
for i=1:n
    crests=get_crests(vehicle_sample(i,:));
    hs(i)=crests(1)*0.48+200;% mm
end
vehicle_height=mean(hs);%底盘高度

end


function crests_sorted=get_crests(signal)
%计算波峰
%输入：a Envelope data 1*827
%输出：波峰 1*6 （按振幅大小排序）
temp=medfilt(medianfilt(signal,26),13);%中值均值滤波
[~,temp_s]=size(temp);
candidates=zeros(100,2);%候选点
z=1;
for j=11:temp_s-10
    if any([temp(j)-temp(j-1)>0,temp(j)-temp(j-2)>0,temp(j)-temp(j-3)>0,temp(j)-temp(j-4)>0,temp(j)-temp(j-5)>0,temp(j)-temp(j-6)>0,temp(j)-temp(j-7)>0,temp(j)-temp(j-8)>0,temp(j)-temp(j-9)>0,temp(j)-temp(j-10)>0]) ...
            &&any([temp(j)-temp(j+1)>0,temp(j)-temp(j+2)>0,temp(j)-temp(j+3)>0,temp(j)-temp(j+4)>0,temp(j)-temp(j+5)>0,temp(j)-temp(j+6)>0,temp(j)-temp(j+7)>0,temp(j)-temp(j+8)>0,temp(j)-temp(j+9)>0,temp(j)-temp(j+10)>0])
        
        candidates(z,1)=j;%候选点下标
        candidates(z,2)=temp(j);%候选点振幅
        z=z+1;
    end
end
crests=zeros(10,2);%波峰
reg_index=1;%当前区域序号
reg_length=1;%当前区域长度
for k=2:100
    if candidates(k,1)==0
        break
    end
    if reg_index>10
        break
    end
    if candidates(k,1)==candidates(k-1,1)+1||candidates(k,1)==candidates(k-1,1)+2
        reg_length=reg_length+1;
        crests(reg_index,1)=candidates(k-floor(reg_length/2),1);%区域中心
        crests(reg_index,2)=candidates(k-floor(reg_length/2),2);%振幅
    else
        if reg_length>1%如果上一个区域长度大于1
            reg_index=reg_index+1;%区域序号
        end
        reg_length=1;%区域长度为1
    end
end
% di_candidates_index=candidates(:,1)-[0,candidates(1:end-1,1)];
%debug
% figure;plot(temp);hold on;plot(comp_temp_1(:,1),comp_temp_1(:,2),'*');hold on; plot(comp_temp_2(:,1),comp_temp_2(:,2),'+');

%%按振幅大小排序
crests_sorted=zeros(1,6);
[~,com_index]=sort(crests(:,2),'descend');
crests_sorted(1:3)=crests(com_index(1:3),1);%下标
crests_sorted(4:6)=crests(com_index(1:3),2);%振幅
end

function X_filt=my_dilate(X,l)
%一维膨胀函数
%输入：X=行向量  l=结构体长度
half_l=floor(l/2);
[~,s]=size(X);
X_filt=X;
for i=1:half_l
   X_filt(i)=max(X(1:i+half_l)); 
end
for i=half_l+1:s-half_l
   X_filt(i)=max(X(i-half_l:i+half_l)); 
end
for i=s-half_l+1:s
   X_filt(i)=max(X(i-half_l:s)); 
end
end

function X_filt=my_erode(X,l)
%一维腐蚀函数
%输入：X=行向量  l=结构体长度
half_l=floor(l/2);
[~,s]=size(X);
X_filt=X;
for i=1:half_l
   X_filt(i)=min(X(1:i+half_l)); 
end
for i=half_l+1:s-half_l
   X_filt(i)=min(X(i-half_l:i+half_l)); 
end
for i=s-half_l+1:s
   X_filt(i)=min(X(i-half_l:s)); 
end
end

function X_filt=medianfilt(X,l)
%中值滤波
half_l=floor(l/2);
[~,s]=size(X);
X_filt=X;
for i=1:half_l
   X_filt(i)=median(X(1:2*i));
end
for i=half_l+1:s-half_l
   X_filt(i)=median(X(i-half_l:i+half_l)); 
end
for i=s-half_l+1:s
   X_filt(i)=median(X(2*i-s:s));
end
end

function X_filt=medfilt(X,l)
%均值滤波
half_l=floor(l/2);
[~,s]=size(X);
X_filt=X;
for i=1:half_l
   X_filt(i)=mean(X(1:2*i));
end
for i=half_l+1:s-half_l
   X_filt(i)=mean(X(i-half_l:i+half_l)); 
end
for i=s-half_l+1:s
   X_filt(i)=mean(X(2*i-s:s));
end
end

function display(original_data,se_pairs,types)
%画车辆检测和车辆分类结果图
%输入：原始数据，起止时间对，车型
[~,numb]=size(se_pairs);
radar_mean=mean(original_data(:,2:end)');

figure
subplot(2,1,1);
% mesh(original_data(:,2:end)');title('原始数据');xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');
subplot(2,1,2);
plot(radar_mean);title('平均数据');xlabel('Measurement Counts');ylabel('Averaged Amplitude');

figure
subplot(2,1,1);
plot(radar_mean);title('车辆检测结果');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
hold on;plot(se_pairs(1,:),radar_mean(se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
hold on; plot(se_pairs(2,:),radar_mean(se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
subplot(2,1,2);
plot(radar_mean);title('车辆分类结果');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
% hold on; plot(se_pairs(1,:),radar_mean(se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
% hold on; plot(se_pairs(2,:),radar_mean(se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
types_name={'Car' 'SUV' 'Bus' 'Middle-truck'};
for i=1:numb
    x_point=floor((se_pairs(1,i)+se_pairs(2,i))/2);
    y_point=radar_mean(x_point)+10;
    text(x_point,y_point,types_name{types(i)+1},"fontsize",12,'FontWeight','bold');%
end
end

function train_rfmodel()
%训练随机森林模型并保存
[X,Y]=load_data();%载入车辆数据集
X_F=data_feature_extract(X);%特征数据集
md1=fitcensemble(X_F,Y,'Learners','tree','Method','Bag');%训练
rf_model = compact(md1);
save('rf_model.mat','rf_model');%保存模型
end

function X_F=data_feature_extract(X)
%计算特征集
%输入：车辆数据集 cell(1,~)
%输出：特征集 ~*m*6+1
m=16;
[~,samples_count]=size(X);
X_F=zeros(samples_count,m*6+1);
crests=zeros(1,m*6);
for i=1:samples_count% 
    resize_X=imresize(X{i},[m,827],'bilinear');%调整大小
    for j=1:m
    crests(6*j-6+1:6*j)=get_crests(resize_X(j,:));%计算波峰
    end
    vehicle_height=get_vehicle_height(resize_X);%计算底盘高度
    X_F(i,:)=[crests,vehicle_height]; 
end
end

function [X,Y]=load_data()
%载入车辆数据集
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
X=[X_car X_SUV X_bus X_truck];%车辆数据集
Y=[0*ones(1,l_car) 1*ones(1,l_SUV) 2*ones(1,l_bus) 3*ones(1,l_truck)];%标签
end
