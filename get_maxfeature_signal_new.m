function [comp_temp_1,comp_temp_2]=get_maxfeature_signal_new(signal)
%得到极大值点 输入=一维行向量 输出=100*2 5*2, 不归一化 不下采样, 中值均值滤波


% temp=downsample_norm(signal);%下采样 归一化
temp=medfilt(medianfilt(signal,26),13);%中值均值滤波
% temp=signal;
[~,temp_s]=size(temp);
comp_temp_1=zeros(100,2);
z=1;

for j=11:temp_s-10
    if any([temp(j)-temp(j-1)>0,temp(j)-temp(j-2)>0,temp(j)-temp(j-3)>0,temp(j)-temp(j-4)>0,temp(j)-temp(j-5)>0,temp(j)-temp(j-6)>0,temp(j)-temp(j-7)>0,temp(j)-temp(j-8)>0,temp(j)-temp(j-9)>0,temp(j)-temp(j-10)>0]) ...
        &&any([temp(j)-temp(j+1)>0,temp(j)-temp(j+2)>0,temp(j)-temp(j+3)>0,temp(j)-temp(j+4)>0,temp(j)-temp(j+5)>0,temp(j)-temp(j+6)>0,temp(j)-temp(j+7)>0,temp(j)-temp(j+8)>0,temp(j)-temp(j+9)>0,temp(j)-temp(j+10)>0])
        
        
        comp_temp_1(z,1)=j;
        comp_temp_1(z,2)=temp(j);
        z=z+1;
        
    end
end

comp_temp_2=zeros(10,2);

reg_index=1;
reg=1;
for k=2:100
    if comp_temp_1(k,1)==0
        break
    end
    if reg_index>10
        break
    end
    
    if comp_temp_1(k,1)==comp_temp_1(k-1,1)+1||comp_temp_1(k,1)==comp_temp_1(k-1,1)+2
        
        reg=reg+1;
        comp_temp_2(reg_index,1)=comp_temp_1(k-floor(reg/2),1);%区域中心
        comp_temp_2(reg_index,2)=comp_temp_1(k-floor(reg/2),2);%振幅
    else
        if reg>1%如果上一个区域长度大于1
            reg_index=reg_index+1;%区域序号
        end
        reg=1;%区域长度
        
    end
    
end
%debug
% figure;plot(temp);hold on;plot(comp_temp_1(:,1),comp_temp_1(:,2),'*');hold on; plot(comp_temp_2(:,1),comp_temp_2(:,2),'+');

end