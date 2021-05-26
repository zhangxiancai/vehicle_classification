
% results of different max_height
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

res_height=zeros(3,50);
 method={'nearest','bilinear','bicubic'};
for inter_index=1:3
for height_index=1:20
    
    RES=data_feature_extract(X,height_index*2,method{inter_index});
    ave_acc=zeros(1,2);
    for co=1:1 %3-5kflod
        
        Index=[1:316];
        T_X=RES(Index,:);
        T_Y=label(Index)';
        md1=fitcensemble(T_X,T_Y,'Learners','tree','Method','Bag','KFold',5);
%         md1=fitcecoc(T_X,T_Y,'Learners','svm','KFold',5);
        predict_label=kfoldPredict(md1);
        
        res=zeros(4,4);
        [samples_count1,~]=size(T_X);
        for i=1:samples_count1
            res(T_Y(i)+1,predict_label(i)+1)=res(T_Y(i)+1,predict_label(i)+1)+1;
        end
        res=[1 2 2 1]'.*res;
        
        res_acc=zeros(1,4);%精度

        for i=1:4
            err=res(i,1)+res(i,2)+res(i,3)+res(i,4)+res(1,i)+res(2,i)+res(3,i)+res(4,i)-2*res(i,i);
            res_acc(i)=1-err/sum(res,'all');
        end
        
        ave_acc(co)=mean(res_acc);
    end
    [inter_index,height_index]
    res_height(inter_index,height_index)=mean(ave_acc);%记录结果
   
end
end
figure;
pl_x=[2:2:100];
plot(pl_x,res_height(1,:));hold on;plot(pl_x,res_height(2,:),'--');hold on;plot(pl_x,res_height(3,:),'-.');legend('nearest neighbor','linear','cubic');
xlabel('m');ylabel('Accuracy');ylim([0.835,0.96]);xlim([0,102]);
set(gca,'XTick',[2,8,22,40,60,80,100]);set(gca,'XTickLabel',{'2','8','22','40','60','80','100'});

function RES=data_feature_extract(X,max_height,method)
%数据集特征提取,先插值后提取极大值,车长，底盘高度
%输入：原始数据cell(1,~),method=插值方法（字符串）
%输出：(max_height*6+2,samples_count)
% max_height=96;
% max_height=16;
[~,samples_count]=size(X);
wcre_num=2*1;

RES=zeros(samples_count,max_height*wcre_num+1);
MP_X=zeros(1,max_height*wcre_num);
for i=1:samples_count%
    [vehicle_length,~]=size(X{i});
    

    resize_X=imresize(X{i},[max_height,827],method);%先插值
    vehicle_height=get_vehicle_height(resize_X);%
    if i==50
        
    end
    for j=1:max_height
    [~,comp_temp_2]=get_maxfeature_signal_new(resize_X(j,:));
%     MP_X(8*j-7:8*j)=correction_method(comp_temp_2);%排序
    MP_X(wcre_num*j-wcre_num+1:wcre_num*j)=correction_method(comp_temp_2);%排序
    end
    RES(i,:)=[MP_X,vehicle_height];
   
end


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

% function feature_line=correction_method(comp_temp_2)
% %调整数据
% %输入：5*2，极大值点
% %输出：1*6 按振幅大小排序
% feature_line=zeros(1,6);
%  [~,com_index]=sort(comp_temp_2(:,2),'descend');
% feature_line(1:3)=comp_temp_2(com_index(1:3),1);
% feature_line(4:6)=comp_temp_2(com_index(1:3),2);
% end

