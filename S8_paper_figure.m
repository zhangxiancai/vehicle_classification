clear all
r_data=csvread('vehicle_data/1.csv');
plot(r_data(2,2:end));xlabel('Index');ylabel('Amplitude');

%%%%%%%%
clear all
close all
r_car=csvread('C:\D\TD_DATA\2021-1-15_data\20210115_103952_ÈýÁ¾_Æû³µ.txt');
r_bus=csvread('C:\D\TD_DATA\2021-3-18_data\radar_old_keche.txt');
plot(mean(r_car(:,2:end)'));
figure;
plot(mean(r_bus(:,2:end)'));
% r_mesh=[r_car(16000:18000,2:end);r_bus(400:1800,2:end)];
r_mesh=[r_car(15300:15700,:);r_bus(500:1000,:)];
csvwrite('r_mesh.csv',r_mesh);
figure
mesh(r_mesh(:,2:end)');xlabel('Measurement Counts');ylabel('Sample Counts');zlabel('Amplitude');

figure
plot(mean(r_mesh(:,2:end)'));xlabel('Measurement Counts');ylabel('Averaged Amplitude');legend('averaged data');




