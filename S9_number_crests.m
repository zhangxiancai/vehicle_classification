%%%%%%%%%%%%%%%%%%%%%%%%
% distribution of the wave crests number of one Envelope data
clear all;
close all;
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
res=zeros(1,10);
for i=1:316
    
    resize_X=imresize(X{i},[16,827],'bilinear');   
    for j=1:16
     [comp_temp_1,comp_temp_2]=get_maxfeature_signal_new_mfilt(resize_X(j,:));
     for z=1:9
         if comp_temp_2(z,1)==0
             res(z)=res(z)+1;
            if z==6
                figure;plot(resize_X(j,:),'-');hold on;plot(medianfilt(resize_X(j,:),26),'--');hold on;plot(medfilt(resize_X(j,:),13),'-.');
                legend('Envelope data','median filter','median and mean filter');xlabel('Sample Counts');ylabel('Amplitude');
           
            end
            break
        end
     end
     if comp_temp_2(9,1)~=0
         res(10)=res(10)+1;
     end
  
    end
    
   
end
%2516	9243	9447	4148	816	154	0
%[1733,7994,10687,5013,812,82,3,0]
%[14233,10392,1575,120,4,0,0,0] 9
% [9205,12064,4275,742,36,2,0,0] 14
% [6877,11573,6445,1313,105,11,0,0] 19

%[0,136,1439,1881,1192,360,42,5,1,0]

%[0,112,1977,2043,612,202,55,34,12,9]
%[7,240,2045,1890,555,189,57,34,20,19]

%[0,143,2254,2096,467,82,10,4,0,0]
%[0,194,2332,1954,499,66,10,1,0,0]
figure;
pl_res=100*(res/sum(res));
bar(0:6,pl_res(1:7));xlabel('Crests Number');ylabel('Percentage (%)');%条形图
 pl_res_t={'0.00' '4.00' '50.32' '39.38' '5.93' '0.36' '0.02'};
for i=1:7

    text(i-1,pl_res(i)+0.5,pl_res_t{i},'VerticalAlignment','bottom','HorizontalAlignment','center',"fontsize",7);%

end

figure;title('bus');
for z=1:16
    resize_X=imresize(X_bus{2},[16,827],'bilinear');
    [comp_temp_1,comp_temp_2]=get_maxfeature_signal_new_mfilt(resize_X(z,:));
    subplot(4,4,z);
    plot(medfilt(resize_X(z,:),13),'-*');hold on;plot(comp_temp_1(:,1),comp_temp_1(:,2),'*');hold on; plot(comp_temp_2(:,1),comp_temp_2(:,2),'+');
end
     
figure;title('car');
for z=1:16
    resize_X=imresize(X_car{2},[16,827],'bilinear');
    [comp_temp_1,comp_temp_2]=get_maxfeature_signal_new_mfilt(resize_X(z,:));
    subplot(4,4,z);
    plot(medfilt(resize_X(z,:),13),'-*');hold on;plot(comp_temp_1(:,1),comp_temp_1(:,2),'*');hold on; plot(comp_temp_2(:,1),comp_temp_2(:,2),'+');
end

function [comp_temp_1,comp_temp_2]=get_maxfeature_signal_new_mfilt_simple(signal)
%得到极大值点 simple
% temp=downsample_norm(signal);%下采样 归一化
temp=medfilt(signal,100);
[~,temp_s]=size(temp);
comp_temp_1=0;
comp_temp_2=zeros(10,2);
j=1;
for i=5:temp_s-5
    if j>10
       break; 
    end
    if temp(i)>temp(i-1)&&temp(i)>temp(i+1)
        comp_temp_2(j,1)=i;
        comp_temp_2(j,2)=temp(i);
        j=j+1;
    end
 
end
% figure;
% plot(temp);xlabel('Sample Counts');ylabel('Amplitude');
% hold on; plot(comp_temp_2(:,1),comp_temp_2(:,2),'+');legend('Envelope data','Wave crests');

end

function [comp_temp_1,comp_temp_2]=get_maxfeature_signal_new_mfilt(signal)
%得到极大值点 输入=一维行向量 输出=100*2 5*2, 不归一化 不下采样
% temp=downsample_norm(signal);%下采样 归一化
temp=medfilt(signal,13);%均值滤波
[~,temp_s]=size(temp);

comp_temp_1=zeros(100,2);
z=1;

for j=11:temp_s-10
%     if any([temp(j)-temp(j-1)>0,temp(j)-temp(j-2)>0,temp(j)-temp(j-3)>0,temp(j)-temp(j-4)>0,temp(j)-temp(j-5)>0]) ...
%         &&any([temp(j)-temp(j+1)>0,temp(j)-temp(j+2)>0,temp(j)-temp(j+3)>0,temp(j)-temp(j+4)>0,temp(j)-temp(j+5)>0])
    if     any([temp(j)-temp(j-1)>0,temp(j)-temp(j-2)>0,temp(j)-temp(j-3)>0,temp(j)-temp(j-4)>0,temp(j)-temp(j-5)>0,temp(j)-temp(j-6)>0,temp(j)-temp(j-7)>0,temp(j)-temp(j-8)>0,temp(j)-temp(j-9)>0,temp(j)-temp(j-10)>0]) ...
        &&any([temp(j)-temp(j+1)>0,temp(j)-temp(j+2)>0,temp(j)-temp(j+3)>0,temp(j)-temp(j+4)>0,temp(j)-temp(j+5)>0,temp(j)-temp(j+6)>0,temp(j)-temp(j+7)>0,temp(j)-temp(j+8)>0,temp(j)-temp(j+9)>0,temp(j)-temp(j+10)>0])
%     if     any([temp(j)-temp(j-1)>0,temp(j)-temp(j-2)>0,temp(j)-temp(j-3)>1,temp(j)-temp(j-4)>1,temp(j)-temp(j-5)>2,temp(j)-temp(j-6)>2,temp(j)-temp(j-7)>3,temp(j)-temp(j-8)>3,temp(j)-temp(j-9)>4,temp(j)-temp(j-10)>4]) ...
%         &&any([temp(j)-temp(j+1)>0,temp(j)-temp(j+2)>0,temp(j)-temp(j+3)>1,temp(j)-temp(j+4)>1,temp(j)-temp(j+5)>2,temp(j)-temp(j+6)>2,temp(j)-temp(j+7)>3,temp(j)-temp(j+8)>3,temp(j)-temp(j+9)>4,temp(j)-temp(j+10)>4])
           
        comp_temp_1(z,1)=j;
        comp_temp_1(z,2)=temp(j);
        z=z+1;
        
    end
end

comp_temp_2=zeros(10,2);
reg_index=1;
reg=1;
for k=2:100
    if comp_temp_1(k,1)==0
        break
    end
    if reg_index>10
        break
    end
    
    if comp_temp_1(k,1)==comp_temp_1(k-1,1)+1||comp_temp_1(k,1)==comp_temp_1(k-1,1)+2
        
        reg=reg+1;
        comp_temp_2(reg_index,1)=comp_temp_1(k-floor(reg/2),1);%区域中心
        comp_temp_2(reg_index,2)=comp_temp_1(k-floor(reg/2),2);%振幅
    else
        if reg>1%如果上一个区域长度大于1
            reg_index=reg_index+1;%区域序号
        end
        reg=1;%区域长度
        
    end
    
end
%debug
% figure;plot(temp);hold on;plot(comp_temp_1(:,1),comp_temp_1(:,2),'*');hold on; plot(comp_temp_2(:,1),comp_temp_2(:,2),'+');

end

function D_X=medfilt(X,l)
%均值滤波
X=medianfilt(X,26);
h_l=floor(l/2);
[~,s]=size(X);
D_X=X;
for i=1:h_l
   D_X(i)=mean(X(1:2*i));
end
for i=h_l+1:s-h_l
   D_X(i)=mean(X(i-h_l:i+h_l)); 
end
for i=s-h_l+1:s
   D_X(i)=mean(X(2*i-s:s));
end
%  figure;plot(X);hold on;plot(D_X);
end
function D_X=medianfilt(X,l)
%中值滤波
h_l=floor(l/2);
[~,s]=size(X);
D_X=X;
for i=1:h_l
   D_X(i)=median(X(1:2*i));
end
for i=h_l+1:s-h_l
   D_X(i)=median(X(i-h_l:i+h_l)); 
end
for i=s-h_l+1:s
   D_X(i)=median(X(2*i-s:s));
end
%  figure;plot(X);hold on;plot(D_X);
end