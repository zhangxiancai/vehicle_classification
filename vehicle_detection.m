function se_pairs=vehicle_detection(mor_mean,l_g,w_thre,baseline)
%地磁或雷达车辆检测
%输入：mor_mean=均值数据 ~*827，l_g=结构体长度， w_thre=动态阈值的权值
%输出：起止时间对 2*~
[r_n,~]=size(mor_mean);
S=zeros(1,r_n);
%
%动态阈值
% baseline=106;
plot_baseline=zeros(1,r_n);
plot_thre=zeros(1,r_n);
for i=1:r_n
%     mor_mean(i)=mean(mor_mean(i,2:end));%均值
    thre=baseline*w_thre;%动态阈值
    plot_thre(i)=thre;%debug
    if mor_mean(i)>thre
        S(i)=1;%
        plot_baseline(i)=baseline;%debug
    else
        baseline=0.8*baseline+0.2*mor_mean(i);%更新基准线
        
        plot_baseline(i)=baseline;%debug
    end  
end
%
S_filt=my_dilate(my_erode(my_erode(my_dilate(S,l_g),l_g),l_g),l_g);%闭开运算
S_filter_diff=[S_filt,0]-[0,S_filt];%差分
 figure;plot(mor_mean);hold on;plot(plot_baseline);hold on;plot(plot_thre);hold on;plot(50*S+50);hold on;plot(50*S_filt+150);
 legend('mor_mean','baseline','thre','S');
% figure;plot(S_filter_diff);ylim([-2,2]);

%统计起止时间
numb=length(find(S_filter_diff==-1));%车辆样本个数
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
function X_filt=my_dilate(X,l)
%一维膨胀函数
%输入：X=行向量  l=结构体长度
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
%一维腐蚀函数
%输入：X=行向量  l=结构体长度
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