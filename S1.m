%截取车辆经过传感器时的数据并写入.csv文件
%输入：一段时间的envelope数据 r_data
%输出：一系列车辆经过传感器时的数据（.csv文件）
clear all
close all
r_data=csvread('20210115_103952_三辆_汽车.txt');
% r_data=csvread('20201227_165827_老师汽车.txt');
[r_n,r_s]=size(r_data);
norm_data=zeros(5000,207);
r_f_temp=zeros(1,r_n);%均值
res_state=zeros(1,r_n);
count=r_n;
for i=1:count
%     norm_data(i,:)=norm_down_signal(r_data(i,2:end));
    r_f_temp(i)=mean(r_data(i,2:end));
    if r_f_temp(i)>450
        res_state(i)=1;
    end
end
figure
plot(r_f_temp(1:count));

r_f_temp_f=[0,r_f_temp];
r_f_temp_b=[r_f_temp,0];
figure
plot(r_f_temp_b-r_f_temp_f);

figure
% res_state(1269:1395)=0;%修正
% res_state(10430:10540)=0;%修正
plot(res_state(1:count));
label=csvread('label.csv');
numb=0;
for i=2:r_n
 if res_state(i)-res_state(i-1)==1
     start=i;
 end
  if res_state(i)-res_state(i-1)==-1
     t_end=i;
    
%       csvwrite(strcat('vehicle_data/',string(numb),'.csv'),r_data(start:t_end,2:end));
%       csvwrite(strcat('cnn_vehicle_data/',string(label(numb+1)),'/',string(numb),'.csv'),r_data(start:t_end,2:end));
       csvwrite(strcat('vehicle_data_b/',string(numb),'.csv'),r_data(start:t_end,2:end));
      
      numb=numb+1;
  end 
   
 end


