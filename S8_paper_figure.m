clear all
r_data=csvread('vehicle_data/1.csv');
plot(r_data(2,2:end));xlabel('Index');ylabel('Amplitude');