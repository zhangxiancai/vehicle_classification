function feature_line=correction_method1(comp_temp_2)
%��������
%���룺5*2������ֵ��
%�����1*6

feature_line=zeros(1,6);
for i=1:3
   feature_line(i)=comp_temp_2(i,1);
   feature_line(i+3)=comp_temp_2(i,2);
    
end

end