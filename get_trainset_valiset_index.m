function [trainset_index,valiset_index]=get_trainset_valiset_index(label)
%根据label（固定为3种类别）划分训练集和验证集索引，80%划为训练集
%输入：行向量
%输出：[trainset_index,valiset_index]（两个元素都为行向量）
class_index=cell(1,3);
trainset_index=[];
valiset_index=[];
for i=1:3
class_index{i}=find(label==i-1);
l=length(class_index{i});
t_l=floor(0.8*l);
rand_index=randperm(l);
trainset_index=[trainset_index class_index{i}(rand_index(1:t_l))];
valiset_index=[valiset_index class_index{i}(rand_index(t_l+1:end))];
end


end