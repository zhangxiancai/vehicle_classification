function [trainset_index,valiset_index]=get_trainset_valiset_index(label)
%����label���̶�Ϊ3����𣩻���ѵ��������֤��������80%��Ϊѵ����
%���룺������
%�����[trainset_index,valiset_index]������Ԫ�ض�Ϊ��������
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