function feature_line=correction_method1(comp_temp_2)
% %调整数据
% %输入：5*2，极大值点
% %输出：1*6
% 
% feature_line=zeros(1,6);
% for i=1:3
%    feature_line(i)=comp_temp_2(i,1);
%    feature_line(i+3)=comp_temp_2(i,2);
%     
% end

%调整数据
%输入：5*2，极大值点
%输出：1*6 按振幅大小排序
feature_line=zeros(1,6);
 [~,com_index]=sort(comp_temp_2(:,2),'descend');
feature_line(1:3)=comp_temp_2(com_index(1:3),1);
feature_line(4:6)=comp_temp_2(com_index(1:3),2);
end