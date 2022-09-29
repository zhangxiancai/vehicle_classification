%停车检测demo
clear all
% train();
%  test_data=csvread('4_20191229_113007.log');
test_data=csvread('test_data.txt');%载入测试数据
[n,~]=size(test_data);
res=zeros(1,n);
A=csvread('MTV_model.csv');%载入模型参数
for i=1:n
    x=test_data(i,2:11);
    res(i)=MTV_model(A,x);%预测（1：无车无干扰；2：有车无干扰；3：无车有干扰；4：有车有干扰）
end
figure;
plot(res*100,'*-');hold on;plot(test_data(:,2:11));title('停车检测结果');xlabel('Measurement Counts');legend('类别')%


function A=train()
%训练，将参数保存至“MTV_model.csv”
global data;global g;
data=csvread('training_data.txt');%载入训练集,含扩展属性
A=zeros(2*14,6);
for g=1:6
    A(:,g)= particleswarm(@targetFunction,2*14,[],[]);%用粒子群优化算法计算基分类器g的参数
end
csvwrite('MTV_model.csv',A);%将参数A保存至MTV_model.csv
end

function cost=targetFunction(a)
%粒子群优化的目标函数
%输入：基分类器参数 2*14
global data;global g;
T=[2 3 3 4 4 4;1 1 2 1 2 3];
cost=0;
[~,s]=size(data);
data_c1=data(data(:,s)==T(1,g),:);data_c2=data(data(:,s)==T(2,g),:);
[n(1),~]=size(data_c1);[n(2),~]=size(data_c2);
base_data=[data_c1;data_c2];%载入基分类器g的训练集

for i=1:n(1)+n(2)
    c=baseModel(a,base_data(i,1:s-1));
    if T(c,g)~=base_data(i,s)%如果模型结果与标签不同
        if base_data(i,s)==T(1,g)
            cost=cost+1/n(1);
        else
            cost=cost+1/n(2);
        end
    end
end
cost=cost*50;
end

function m_c=MTV_model(A,x)
% MTV分类器
%输入: A=参数 x=数据
%输出：类别{1 2 3 4}
T=[2 3 3 4 4 4;1 1 2 1 2 3];
res=zeros(1,6);%6个基分类器的投票结果
x=add_extendFeature(x);%添加扩展属性
for k=1:6
    c=baseModel(A(:,k),x);%第k个基分类器进行分类
    if c==1
        res(T(1,k))=res(T(1,k))+1;
    else
        res(T(2,k))=res(T(2,k))+1;
    end
end
[~,m_c]=max(res);%取得票最多的类别
end

function x=add_extendFeature(x)
%添加扩展属性
corr=corrcoef(1:10,x);
ef(1)=250+corr(1,2)*250;%相关系数
ef(2)=sum(x)/10;%均值
ef(3)=length(find(x<=50))*50;%小于50的属性数量
ef(4)=std(x);%标准差
x=[x ef];
end

function c=baseModel(a,x)
%基分类器
%输入：参数 数据
%输出：类别(1或2)
s=length(x);
temp1=0;temp2=0;
for i=1:s
    if a(s+i)>=0
        if x(i)>a(i)
            temp1=temp1+1;
        else
            temp2=temp2+1;
        end
    else
        if x(i)<a(i)
            temp1=temp1+1;
        else
            temp2=temp2+1;
        end
    end
end
if temp1>=temp2
    c=1;
else
    c=2;
end
end
