function d_c_c_d_x=experiment_vehicle_detection(r_bus,l_g,m_thre)
%车辆检测
%l_g=结构体长度， m_thre=阈值权值
%输出: s(t)

[r_n,r_s]=size(r_bus);

r_mean=zeros(1,r_n);%均值
r_state=zeros(1,r_n);
count=r_n;

baseline=106;
save_baseline=zeros(1,r_n);
thre=zeros(1,r_n);
for i=1:count
    %     norm_data(i,:)=norm_down_signal(r_data(i,2:end));
    r_mean(i)=mean(r_bus(i,2:end));
    thre(i)=baseline*m_thre;
    if r_mean(i)>thre(i)
        r_state(i)=1;
        
    else
        baseline=0.8*baseline+0.2*r_mean(i);
    end
    save_baseline(i)=baseline;
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l=r_state;
d_x=my_dilate(l,l_g);
c_d_x=my_erode(d_x,l_g);
c_c_d_x=my_erode(c_d_x,l_g);
d_c_c_d_x=my_dilate(c_c_d_x,l_g);


end