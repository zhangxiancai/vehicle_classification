function comp_temp_2=get_maxfeature_signal(signal)
%�õ�����ֵ�� ����=һά������ ���=5*2


temp=downsample_norm(signal);%�²��� ��һ��
[~,temp_s]=size(temp);
comp_temp_1=zeros(100,2);
z=1;

for j=4:temp_s-3
    if any([temp(j)-temp(j-1)>0,temp(j)-temp(j-2)>0,temp(j)-temp(j-3)>0])&&any([temp(j)-temp(j+1)>0,temp(j)-temp(j+2)>0,temp(j)-temp(j+3)>0])
        
        
        comp_temp_1(z,1)=j;
        comp_temp_1(z,2)=temp(j);
        z=z+1;
        
    end
end

comp_temp_2=zeros(5,2);

reg_index=1;
reg=1;
for k=2:100
    if comp_temp_1(k,1)==0
        break
    end
    if reg_index>5
        break
    end
    
    if comp_temp_1(k,1)==comp_temp_1(k-1,1)+1||comp_temp_1(k,1)==comp_temp_1(k-1,1)+2
        
        reg=reg+1;
        comp_temp_2(reg_index,1)=comp_temp_1(k-floor(reg/2),1);%��������
        comp_temp_2(reg_index,2)=comp_temp_1(k-floor(reg/2),2);%���
    else
        if reg>1%�����һ�����򳤶ȴ���1
            reg_index=reg_index+1;%�������
        end
        reg=1;%���򳤶�
        
    end
    
end


end


function res=downsample_norm(signal)
%�²��� ��һ��
temp=signal(1:4:end);%�²���

max_temp=max(temp);
min_temp=min(temp);
res=round((255/(max_temp-min_temp))*(temp-min_temp));%��һ��*255��
end


