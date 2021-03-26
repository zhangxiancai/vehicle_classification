%形态学去毛刺
clear all
r_data=csvread('D:\TD_DATA\2021-3-19_data\radar_old_beimen_b.txt');

[r_n,r_s]=size(r_data);
mean_r_data=zeros(1,r_n);%均值
res_state=zeros(1,r_n);%
count=r_n;
for i=1:count
%     norm_data(i,:)=norm_down_signal(r_data(i,2:end));
    mean_r_data(i)=mean(r_data(i,2:end));
    if mean_r_data(i)>200
        res_state(i)=1;
    end
end
figure;plot(mean_r_data);hold on;plot(2500*res_state);

l=res_state;
d_x=my_dilate(l);
c_d_x=my_erode(d_x);
figure
plot(l);hold on
plot(d_x);
figure
plot(l);hold on
plot(c_d_x);


c_c_d_x=my_erode(c_d_x);
d_c_c_d_x=my_dilate(c_c_d_x);

figure
plot(l);hold on
plot(c_c_d_x);
figure
plot(l);hold on
plot(d_c_c_d_x);



figure
plot(res_state);hold on; plot(d_c_c_d_x);ylim([0,2]);

d_c_c_d_x_a=[d_c_c_d_x,0];
d_c_c_d_x_b=[0,d_c_c_d_x];
DI_S=d_c_c_d_x_a-d_c_c_d_x_b;figure;plot(DI_S);ylim([-2,2]);



