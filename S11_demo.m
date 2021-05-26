% demo
clear all
% train_rfmodel();%ѵ�����ɭ��ģ�Ͳ�����
original_data=csvread('C:\D\TD_DATA\2021-3-19_data\radar_old_beimen_b.txt');%��������ԭʼ����
se_pairs=vehicle_detection(original_data,17,1.2);%�������
[~,numb]=size(se_pairs);%��������
types=zeros(1,numb);
for i=1:numb
    types(i)=vehicle_classification(original_data(se_pairs(1,i):se_pairs(2,i),2:end));%��������
end
display(original_data,se_pairs,types);%���������ͳ���������ͼ


function se_pairs=vehicle_detection(original_data,l_g,w_thre)
%�������
%���룺original_data=ԭʼ���� ~*827��l_g=�ṹ�峤�ȣ� w_thre=��̬��ֵ��Ȩֵ
%�������ֹʱ��� 2*~
[r_n,~]=size(original_data);
r_mean=zeros(1,r_n);
S=zeros(1,r_n);
%
%��̬��ֵ
baseline=106;
for i=1:r_n
    r_mean(i)=mean(original_data(i,2:end));%��ֵ
    thre=baseline*w_thre;%��̬��ֵ
    if r_mean(i)>thre
        S(i)=1;%
    else
        baseline=0.8*baseline+0.2*r_mean(i);%���»�׼��
    end  
end
%
S_filt=my_dilate(my_erode(my_erode(my_dilate(S,l_g),l_g),l_g),l_g);%�տ�����
S_filter_diff=[S_filt,0]-[0,S_filt];%���
% figure;plot(500*S);hold on;plot(500*S_filt+600);hold on;plot(r_mean);
% figure;plot(S_filter_diff);ylim([-2,2]);

%ͳ����ֹʱ��
numb=length(find(S_filter_diff==-1));%������������
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
%��������
%���룺ԭʼ�������� ~*827
%��������
m=16;%�������
crests=zeros(1,m*6);

resize_X=imresize(X,[m,827],'bilinear');%������С
for j=1:m
    crests(6*j-6+1:6*j)=get_crests(resize_X(j,:));%���㲨��
end
vehicle_height=get_vehicle_height(resize_X);%������̸߶�

load rf_model.mat %load the trained random forest model
type=predict(rf_model,[crests,vehicle_height]);
end

function vehicle_height=get_vehicle_height(vehicle_sample)
%����: ��������  16*827 
%���: ���̸߶�
[n,~]=size(vehicle_sample);
hs=zeros(1,n);
for i=1:n
    crests=get_crests(vehicle_sample(i,:));
    hs(i)=crests(1)*0.48+200;% mm
end
vehicle_height=mean(hs);%���̸߶�

end


function crests_sorted=get_crests(signal)
%���㲨��
%���룺a Envelope data 1*827
%��������� 1*6 ���������С����
temp=medfilt(medianfilt(signal,26),13);%��ֵ��ֵ�˲�
[~,temp_s]=size(temp);
candidates=zeros(100,2);%��ѡ��
z=1;
for j=11:temp_s-10
    if any([temp(j)-temp(j-1)>0,temp(j)-temp(j-2)>0,temp(j)-temp(j-3)>0,temp(j)-temp(j-4)>0,temp(j)-temp(j-5)>0,temp(j)-temp(j-6)>0,temp(j)-temp(j-7)>0,temp(j)-temp(j-8)>0,temp(j)-temp(j-9)>0,temp(j)-temp(j-10)>0]) ...
            &&any([temp(j)-temp(j+1)>0,temp(j)-temp(j+2)>0,temp(j)-temp(j+3)>0,temp(j)-temp(j+4)>0,temp(j)-temp(j+5)>0,temp(j)-temp(j+6)>0,temp(j)-temp(j+7)>0,temp(j)-temp(j+8)>0,temp(j)-temp(j+9)>0,temp(j)-temp(j+10)>0])
        
        candidates(z,1)=j;%��ѡ���±�
        candidates(z,2)=temp(j);%��ѡ�����
        z=z+1;
    end
end
crests=zeros(10,2);%����
reg_index=1;%��ǰ�������
reg_length=1;%��ǰ���򳤶�
for k=2:100
    if candidates(k,1)==0
        break
    end
    if reg_index>10
        break
    end
    if candidates(k,1)==candidates(k-1,1)+1||candidates(k,1)==candidates(k-1,1)+2
        reg_length=reg_length+1;
        crests(reg_index,1)=candidates(k-floor(reg_length/2),1);%��������
        crests(reg_index,2)=candidates(k-floor(reg_length/2),2);%���
    else
        if reg_length>1%�����һ�����򳤶ȴ���1
            reg_index=reg_index+1;%�������
        end
        reg_length=1;%���򳤶�Ϊ1
    end
end
% di_candidates_index=candidates(:,1)-[0,candidates(1:end-1,1)];
%debug
% figure;plot(temp);hold on;plot(comp_temp_1(:,1),comp_temp_1(:,2),'*');hold on; plot(comp_temp_2(:,1),comp_temp_2(:,2),'+');

%%�������С����
crests_sorted=zeros(1,6);
[~,com_index]=sort(crests(:,2),'descend');
crests_sorted(1:3)=crests(com_index(1:3),1);%�±�
crests_sorted(4:6)=crests(com_index(1:3),2);%���
end

function X_filt=my_dilate(X,l)
%һά���ͺ���
%���룺X=������  l=�ṹ�峤��
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
%һά��ʴ����
%���룺X=������  l=�ṹ�峤��
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
%��ֵ�˲�
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
%��ֵ�˲�
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
%���������ͳ���������ͼ
%���룺ԭʼ���ݣ���ֹʱ��ԣ�����
[~,numb]=size(se_pairs);
radar_mean=mean(original_data(:,2:end)');

figure
subplot(2,1,1);
% mesh(original_data(:,2:end)');title('ԭʼ����');xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');
subplot(2,1,2);
plot(radar_mean);title('ƽ������');xlabel('Measurement Counts');ylabel('Averaged Amplitude');

figure
subplot(2,1,1);
plot(radar_mean);title('���������');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
hold on; plot(se_pairs(1,:),radar_mean(se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
hold on; plot(se_pairs(2,:),radar_mean(se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
subplot(2,1,2);
plot(radar_mean);title('����������');xlabel('Measurement Counts');ylabel('Averaged Amplitude');
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
%ѵ�����ɭ��ģ�Ͳ�����
[X,Y]=load_data();%���복�����ݼ�
X_F=data_feature_extract(X);%�������ݼ�
md1=fitcensemble(X_F,Y,'Learners','tree','Method','Bag');%ѵ��
rf_model = compact(md1);
save('rf_model.mat','rf_model');%����ģ��
end

function X_F=data_feature_extract(X)
%����������
%���룺�������ݼ� cell(1,~)
%����������� ~*m*6+1
m=16;
[~,samples_count]=size(X);
X_F=zeros(samples_count,m*6+1);
crests=zeros(1,m*6);
for i=1:samples_count% 
    resize_X=imresize(X{i},[m,827],'bilinear');%������С
    for j=1:m
    crests(6*j-6+1:6*j)=get_crests(resize_X(j,:));%���㲨��
    end
    vehicle_height=get_vehicle_height(resize_X);%������̸߶�
    X_F(i,:)=[crests,vehicle_height]; 
end
end

function [X,Y]=load_data()
%���복�����ݼ�
l_bus=57;l_car=105;l_SUV=54;l_truck=100;
X_bus=cell(1,l_bus);
X_car=cell(1,l_car);
X_SUV=cell(1,l_SUV);
X_truck=cell(1,l_truck);
for i=1:l_bus
    X_bus{i}=csvread(strcat('vehicle_data_bus/',string(i-1),'.csv'));%����
end
for i=1:l_car
    X_car{i}=csvread(strcat('vehicle_data_car/',string(i-1),'.csv'));%����
end
for i=1:l_SUV
    X_SUV{i}=csvread(strcat('vehicle_data_SUV/',string(i-1),'.csv'));%����
end
for i=1:l_truck
    X_truck{i}=csvread(strcat('vehicle_data_truck/',string(i-1),'.csv'));%����
end
X=[X_car X_SUV X_bus X_truck];%�������ݼ�
Y=[0*ones(1,l_car) 1*ones(1,l_SUV) 2*ones(1,l_bus) 3*ones(1,l_truck)];%��ǩ
end