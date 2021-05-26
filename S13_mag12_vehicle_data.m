%制作地磁和雷达车辆数据集
% %car数据集
% clear all
% close all
% 
% r_data=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_三辆_汽车.txt');
% m_data_4=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_4.txt');
% m_data_3=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_3.txt');
% 
% r_data_mean=mean(r_data(:,2:end),2);
% m_data_4_mean=mean(abs(m_data_4(:,2:end)-[160 426 245]),2);
% m_data_3_mean=mean(abs(m_data_3(:,2:end)-[162 326 204]),2);
% 
% % r_data(:,1)=r_data(:,1)-1.61067e12;
% % % m_data_4(:,1)=m_data_4(:,1)-1.61067e12;
% % m_data_6(:,1)=m_data_6(:,1)-1.61067e12;
% 
% r_se_pairs=vehicle_detection(r_data_mean,17,1.2,106);
% m3_se_pairs=vehicle_detection(m_data_3_mean+100,9,1.05,101);
% m4_se_pairs=vehicle_detection(m_data_4_mean+100,9,1.05,101);
% 
% m3_se_pairs(:,[23 24 25 26])=[];
% m4_se_pairs(:,[1 24:27 56])=[];
% r_se_pairs(:,[3 24])=[];
% m3_se_pairs=m3_se_pairs+[-4;4];
% m4_se_pairs=m4_se_pairs+[-4;4];
% 
% figure
% plot(r_data(:,1),r_data_mean);title('车辆检测结果');xlabel('Time');ylabel('Averaged Amplitude');
% hold on; plot(r_data(r_se_pairs(1,:),1),r_data_mean(r_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
% hold on; plot(r_data(r_se_pairs(2,:),1),r_data_mean(r_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
% 
% hold on;plot(m_data_3(:,1),m_data_3_mean);
% hold on; plot(m_data_3(m3_se_pairs(1,:),1),m_data_3_mean(m3_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
% hold on; plot(m_data_3(m3_se_pairs(2,:),1),m_data_3_mean(m3_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
% hold on;plot(m_data_4(:,1),m_data_4_mean);
% hold on; plot(m_data_4(m4_se_pairs(1,:),1),m_data_4_mean(m4_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
% hold on; plot(m_data_4(m4_se_pairs(2,:),1),m_data_4_mean(m4_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
% 
% for i=1:length(m3_se_pairs(1,:))
%     x_point=floor((m3_se_pairs(1,i)+m3_se_pairs(2,i))/2);
%     text(m_data_3(x_point,1),10,num2str(i),"fontsize",12,'FontWeight','bold');%
% end
% for i=1:length(m4_se_pairs(1,:))
%     x_point=floor((m4_se_pairs(1,i)+m4_se_pairs(2,i))/2);
%     text(m_data_4(x_point,1),50,num2str(i),"fontsize",12,'FontWeight','bold');%
% end
% for i=1:length(r_se_pairs(1,:))
%     x_point=floor((r_se_pairs(1,i)+r_se_pairs(2,i))/2);
%     text(r_data(x_point,1),100,num2str(i),"fontsize",12,'FontWeight','bold');%
% end
% 
% label=csvread('label.csv');
% m3_car_index=m3_se_pairs(:,label~=2);%
% m3_SUV_index=m3_se_pairs(:,label==2);%
% m4_car_index=m4_se_pairs(:,label~=2);%
% m4_SUV_index=m4_se_pairs(:,label==2);%
% r_car_index=r_se_pairs(:,label~=2);%
% r_SUV_index=r_se_pairs(:,label==2);%
% for i=1:length(m3_car_index(1,:))
%         csvwrite(strcat('mag12_vehicle_data/mag1_car/',string(i),'.txt'),m_data_3(m3_car_index(1,i):m3_car_index(2,i),:));
% end
% for i=1:length(m3_SUV_index(1,:))
%         csvwrite(strcat('mag12_vehicle_data/mag1_SUV/',string(i),'.txt'),m_data_3(m3_SUV_index(1,i):m3_SUV_index(2,i),:));
% end
% 
% for i=1:length(m4_car_index(1,:))
%         csvwrite(strcat('mag12_vehicle_data/mag2_car/',string(i),'.txt'),m_data_4(m4_car_index(1,i):m4_car_index(2,i),:));
% end
% for i=1:length(m4_SUV_index(1,:))
%         csvwrite(strcat('mag12_vehicle_data/mag2_SUV/',string(i),'.txt'),m_data_4(m4_SUV_index(1,i):m4_SUV_index(2,i),:));
% end
% 
% for i=1:length(r_car_index(1,:))
%         csvwrite(strcat('mag12_vehicle_data/radar_car/',string(i),'.txt'),r_data(r_car_index(1,i):r_car_index(2,i),:));
% end
% for i=1:length(r_SUV_index(1,:))
%         csvwrite(strcat('mag12_vehicle_data/radar_SUV/',string(i),'.txt'),r_data(r_SUV_index(1,i):r_SUV_index(2,i),:));
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%制作卡车数据集
clear all
close all

r_data=[csvread('C:\D\TD_DATA\2021-4-15_data\radar_old_kache.txt');csvread('C:\D\TD_DATA\2021-4-15_data\radar_old_kache_b.txt')];
% r_data=csvread('C:\D\TD_DATA\2021-4-15_data\radar_old_kache_b.txt');
% m_data_4=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_4.txt');
m_data_3=[csvread('C:\D\TD_DATA\2021-4-15_data\mag3_kache.txt');csvread('C:\D\TD_DATA\2021-4-15_data\mag3_kache_b.txt')];
m_data_4=[csvread('C:\D\TD_DATA\2021-4-15_data\mag4_kache.txt');csvread('C:\D\TD_DATA\2021-4-15_data\mag4_kache_b.txt')];
figure
hold on;plot(m_data_3(:,1)',m_data_3(:,2));
hold on;plot(m_data_3(:,1)',m_data_3(:,3));
hold on;plot(m_data_3(:,1)',m_data_3(:,4));
legend('1','2','3');

r_data_mean=mean(r_data(:,2:end),2);
m_data_3_mean=mean(abs(m_data_3(:,2:end)-[-9 236 261]),2);
m_data_4_mean=mean(abs(m_data_4(:,2:end)-[-89 379 232]),2);

% r_data(:,1)=r_data(:,1)-1.61067e12;
% % m_data_4(:,1)=m_data_4(:,1)-1.61067e12;
% m_data_6(:,1)=m_data_6(:,1)-1.61067e12;

r_se_pairs=vehicle_detection(r_data_mean,17,1.2,140);
m3_se_pairs=vehicle_detection(m_data_3_mean+100,9,1.05,101);
m4_se_pairs=vehicle_detection(m_data_4_mean+100,9,1.05,101);



m4_se_pairs(:,[1 2 3])=[];
m3_se_pairs=m3_se_pairs+[-4;4];
m4_se_pairs=m4_se_pairs+[-4;4];

figure
plot(r_data(:,1),r_data_mean);title('车辆检测结果');xlabel('Time');ylabel('Averaged Amplitude');
hold on; plot(r_data(r_se_pairs(1,:),1),r_data_mean(r_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
hold on; plot(r_data(r_se_pairs(2,:),1),r_data_mean(r_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');

hold on;plot(m_data_3(:,1),m_data_3_mean);
hold on; plot(m_data_3(m3_se_pairs(1,:),1),m_data_3_mean(m3_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
hold on; plot(m_data_3(m3_se_pairs(2,:),1),m_data_3_mean(m3_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');

hold on;plot(m_data_4(:,1),m_data_4_mean);
hold on; plot(m_data_4(m4_se_pairs(1,:),1),m_data_4_mean(m4_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
hold on; plot(m_data_4(m4_se_pairs(2,:),1),m_data_4_mean(m4_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');

for i=1:length(m3_se_pairs(1,:))
    x_point=floor((m3_se_pairs(1,i)+m3_se_pairs(2,i))/2);
    text(m_data_3(x_point,1),10,num2str(i),"fontsize",12,'FontWeight','bold');%
end
for i=1:length(m4_se_pairs(1,:))
    x_point=floor((m4_se_pairs(1,i)+m4_se_pairs(2,i))/2);
    text(m_data_4(x_point,1),50,num2str(i),"fontsize",12,'FontWeight','bold');%
end
for i=1:length(r_se_pairs(1,:))
    x_point=floor((r_se_pairs(1,i)+r_se_pairs(2,i))/2);
    text(r_data(x_point,1),100,num2str(i),"fontsize",12,'FontWeight','bold');%
end

for i=1:length(m3_se_pairs(1,:))
        csvwrite(strcat('mag12_vehicle_data/mag1_truck/',string(i),'.txt'),m_data_3(m3_se_pairs(1,i):m3_se_pairs(2,i),:));
end
for i=1:length(m4_se_pairs(1,:))
        csvwrite(strcat('mag12_vehicle_data/mag2_truck/',string(i),'.txt'),m_data_4(m4_se_pairs(1,i):m4_se_pairs(2,i),:));
end
for i=1:length(r_se_pairs(1,:))
        csvwrite(strcat('mag12_vehicle_data/radar_truck/',string(i),'.txt'),r_data(r_se_pairs(1,i):r_se_pairs(2,i),:));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%制作公交车数据集
% clear all
% close all
% 
% r_data=[csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche.txt');csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche_b.txt')];
% % r_data=csvread('C:\D\TD_DATA\2021-4-15_data\radar_old_kache_b.txt');
% % m_data_4=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_4.txt');
% m_data_3=[csvread('C:\D\TD_DATA\2021-3-18_data\mag4_kechedi.txt')];
% % m_data_4=csvread('C:\D\TD_DATA\2021-4-15_data\mag4_kache_b.txt');
% figure
% hold on;plot(m_data_3(:,1)',m_data_3(:,2));
% hold on;plot(m_data_3(:,1)',m_data_3(:,3));
% hold on;plot(m_data_3(:,1)',m_data_3(:,4));
% legend('1','2','3');
% 
% r_data_mean=mean(r_data(:,2:end),2);
% % m_data_4_mean=mean(abs(m_data_4(:,2:end)-[-89 379 232]),2);
% % m_data_3_mean=mean(abs(m_data_3(:,2:end)-[-138 -513 235]),2);
% m_data_3_mean=mean(abs(m_data_3(:,2:end)-[-170 -278 199]),2);
% 
% % r_data(:,1)=r_data(:,1)-1.61067e12;
% % % m_data_4(:,1)=m_data_4(:,1)-1.61067e12;
% % m_data_6(:,1)=m_data_6(:,1)-1.61067e12;
% 
% r_se_pairs=vehicle_detection(r_data_mean,17,1.2,140);
% m_se_pairs=vehicle_detection(m_data_3_mean+100,13,1.05,101);
%  m_se_pairs(:,2:end-1)=m_se_pairs(:,2:end-1)+[-4;4];
%  
% %  
% % m_se_pairs(:,[1 23:27])=[];
% % r_se_pairs(:,[22 23])=[];
% 
% figure
% plot(r_data(:,1),r_data_mean);title('车辆检测结果');xlabel('Time');ylabel('Averaged Amplitude');
% hold on; plot(r_data(r_se_pairs(1,:),1),r_data_mean(r_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
% hold on; plot(r_data(r_se_pairs(2,:),1),r_data_mean(r_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
% 
% hold on;plot(m_data_3(:,1),m_data_3_mean);
% hold on; plot(m_data_3(m_se_pairs(1,:),1),m_data_3_mean(m_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
% hold on; plot(m_data_3(m_se_pairs(2,:),1),m_data_3_mean(m_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
% 
% % hold on;plot(m_data_4(:,1),m_data_4_mean);
% % hold on; plot(m_data_4(m_se_pairs(1,:),1),m_data_4_mean(m_se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
% % hold on; plot(m_data_4(m_se_pairs(2,:),1),m_data_4_mean(m_se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
% for i=1:length(m_se_pairs(1,:))
%     x_point=floor((m_se_pairs(1,i)+m_se_pairs(2,i))/2);
%     text(m_data_3(x_point,1),10,num2str(i),"fontsize",12,'FontWeight','bold');%
% end
% for i=1:length(r_se_pairs(1,:))
%     x_point=floor((r_se_pairs(1,i)+r_se_pairs(2,i))/2);
%     text(r_data(x_point,1),100,num2str(i),"fontsize",12,'FontWeight','bold');%
% end
% 
% 
% for i=1:length(m_se_pairs(1,:))
%         csvwrite(strcat('mag_radar_vehicle_data/mag_bus/',string(i),'.txt'),m_data_3(m_se_pairs(1,i):m_se_pairs(2,i),:));
% end
% for i=1:length(r_se_pairs(1,:))
%         csvwrite(strcat('mag_radar_vehicle_data/radar_bus/',string(i),'.txt'),r_data(r_se_pairs(1,i):r_se_pairs(2,i),:));
% end





