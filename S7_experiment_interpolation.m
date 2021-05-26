
% results of different interpolation
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
ave_acc=zeros(1,10);
for co=1:10
RES=data_feature_extract(X);
Index=[1:316];
T_X=RES(Index,:);
T_Y=label(Index)';
md1=fitcensemble(T_X,T_Y,'Learners','tree','Method','Bag','KFold',5);
% md1=fitcecoc(T_X,T_Y,'Learners','svm','KFold',5);
predict_label=kfoldPredict(md1);

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

ave_acc(co)=mean(res_acc);
end
csvwrite('acc_nearest_s.txt',ave_acc);
