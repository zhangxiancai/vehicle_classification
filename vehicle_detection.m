function se_pairs=vehicle_detection(mor_mean,l_g,w_thre,baseline)
%�شŻ��״ﳵ�����
%���룺mor_mean=��ֵ���� ~*827��l_g=�ṹ�峤�ȣ� w_thre=��̬��ֵ��Ȩֵ
%�������ֹʱ��� 2*~
[r_n,~]=size(mor_mean);
S=zeros(1,r_n);
%
%��̬��ֵ
% baseline=106;
plot_baseline=zeros(1,r_n);
plot_thre=zeros(1,r_n);
for i=1:r_n
%     mor_mean(i)=mean(mor_mean(i,2:end));%��ֵ
    thre=baseline*w_thre;%��̬��ֵ
    plot_thre(i)=thre;%debug
    if mor_mean(i)>thre
        S(i)=1;%
        plot_baseline(i)=baseline;%debug
    else
        baseline=0.8*baseline+0.2*mor_mean(i);%���»�׼��
        
        plot_baseline(i)=baseline;%debug
    end  
end
%
S_filt=my_dilate(my_erode(my_erode(my_dilate(S,l_g),l_g),l_g),l_g);%�տ�����
S_filter_diff=[S_filt,0]-[0,S_filt];%���
 figure;plot(mor_mean);hold on;plot(plot_baseline);hold on;plot(plot_thre);hold on;plot(50*S+50);hold on;plot(50*S_filt+150);
 legend('mor_mean','baseline','thre','S');
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