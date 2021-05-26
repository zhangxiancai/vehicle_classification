function feature_line=correction_method(comp_temp_2)
%调整数据
%输入：~*2，极大值点
%输出：1*6 按振幅大小排序
wnum=3;
feature_line=zeros(1,2*wnum);
 [~,com_index]=sort(comp_temp_2(:,2),'descend');
feature_line(1:wnum)=comp_temp_2(com_index(1:wnum),1);
feature_line(wnum+1:2*wnum)=comp_temp_2(com_index(1:wnum),2);
end