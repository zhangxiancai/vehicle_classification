label_cars=[1 2 1 2 2 1 2 1 2 2 2 1 2 1 1 0 1 2 2 1 2 1 1 1 2 2 1 1 2 2 2 2 1 1 2 1 2 2 2 0 2 2 2 1 1 2 1 1 1 1 2 1 2 1 0 2 0 2 2 1 1 1 2 1 1 1 1 1 1 1 1 1 2 2 1 1 1 1 1 1 0 1 1 1 1 ];
csvwrite('label_cars_25_end.csv',label_cars);
mag_data=csvread('D:\TD_DATA\2021-3-19_data\mag3_beimen_zhong.txt');
figure
plot((mag_data(:,1)-1.61611*10^12)/100,mag_data(:,2));%1.616112660820000e+12   1.616112660914000e

t=(mag_data(:,1)-1.61611*10^12);


A(sort([1:85],'descend'))=label_cars(sort([1:85],'descend'));