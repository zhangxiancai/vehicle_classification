%��ȡ��������������ʱ�����ݲ�д��.csv�ļ�
%���룺һ��ʱ���envelope���� r_data
%�����һϵ�г�������������ʱ�����ݣ�.csv�ļ���
clear all
close all
r_data=csvread('20210115_103952_����_����.txt');
% r_data=csvread('20201227_165827_��ʦ����.txt');
[r_n,r_s]=size(r_data);
norm_data=zeros(5000,207);
r_f_temp=zeros(1,r_n);%��ֵ
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
% res_state(1269:1395)=0;%����
% res_state(10430:10540)=0;%����
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


