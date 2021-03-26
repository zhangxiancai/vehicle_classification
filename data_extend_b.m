function sq_extend_CNN_X=data_extend_b(X,method)
%CNN���ݼ���չ,����ȡ����ֵ���ٲ�ֵ,����Ϊ����24*24
%���룺ԭʼ����cell(1,~),method=��ֵ�������ַ�����
%�����24*24*1*~

max_height=96;
[~,samples_count]=size(X);
maxfeature_X=cell(1,samples_count);%����ֵ������
for i=1:samples_count
    [temp_n,~]=size(X{i});
    for j=1:temp_n
        maxfeature_X{i}(j,:)=correction_method1(get_maxfeature_signal(X{i}(j,:)));%�ȼ��㼫��ֵ��
        
    end
end

sl_maxfeature_X=zeros(max_height,6,samples_count);
for i=1:samples_count
    sl_maxfeature_X(:,:,i)=imresize(maxfeature_X{i},[max_height,6],method);%�ٲ�ֵ
end


sq_extend_CNN_X=zeros(max_height/4,6*4,1,samples_count);
for i=1:samples_count
    sq_extend_CNN_X(:,:,1,i)=mat2gray([sl_maxfeature_X(1:24,:,i) sl_maxfeature_X(25:48,:,i) sl_maxfeature_X(49:72,:,i) sl_maxfeature_X(73:96,:,i)]);%תΪ����

end


end