
%优化随机森林模型
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
X=[X_car X_SUV X_bus X_truck];%车辆数据集
Y=[0*ones(1,l_car) 1*ones(1,l_SUV) 2*ones(1,l_bus) 3*ones(1,l_truck)];%标签


T_X=data_feature_extract(X);%特征数据集
% coeff = pca(T_X);
% pca_X=T_X*coeff(:,1:7);%主成分变换
% md1=fitcensemble(T_X,Y,'Learners','tree','Method','Bag','KFold',5);%
% res=zeros(100,100);
% for i=1:100
%     Md1 = TreeBagger(100,T_X,Y,'OOBPrediction','On','Method','classification',...
%     'NumPredictorsToSample',10,'MinLeafSize',i);
%     res(i,:)=oobError(Md1);
% end
% figure;plot(res(:,100));ylabel('Out-of-bag classification error');ylim([0,1]);
% figure;plot(mean(res(:,30:100)'));legend('1','2','3','4','5','6','7','8','9','10');ylim([0,1]);

Md1 = TreeBagger(100,T_X,Y,'OOBPrediction','On','Method','classification',...
    'NumPredictorsToSample',10);
% Md2 = TreeBagger(100,T_X,Y,'OOBPrediction','On','Method','classification',...
%     'NumPredictorsToSample',100);
%  view(Md2.Trees{2},'Mode','graph');
figure;
plot(oobError(Md1));
% hold on;plot(n);legend('1 wrests','3 wcrests');
xlabel 'Number of Decision Trees';
ylabel 'Out-of-bag  Error';
predict_label=oobPredict(Md1);
res=zeros(4,4);
[samples_count,~]=size(T_X);
for i=1:samples_count
    res(Y(i)+1,predict_label{i}+1)=res(Y(i)+1,predict_label{i}+1)+1;
end
res=[1 2 2 1]'.*res;
total_acc=(res(1,1)+res(2,2)+res(3,3)+res(4,4))/sum(res,'all');
res_acc=zeros(1,4);%精度
res_pre=zeros(1,4);%查准率
res_recall=zeros(1,4);%查全率
for i=1:4
    err=res(i,1)+res(i,2)+res(i,3)+res(i,4)+res(1,i)+res(2,i)+res(3,i)+res(4,i)-2*res(i,i);
    res_acc(i)=1-err/sum(res,'all');
    res_pre(i)=res(i,i)/sum(res(:,i));
    res_recall(i)=res(i,i)/sum(res(i,:));
end
figure;bar([res_acc;res_pre;res_recall]');

