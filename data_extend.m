function sq_extend_CNN_X=data_extend(X,method)
%CNN���ݼ���չ,�Ȳ�ֵ����ȡ����ֵ��,����Ϊ����24*24
%���룺ԭʼ����cell(1,~),method=��ֵ�������ַ�����
%�����24*24*1*~



max_height=96;
[~,samples_count]=size(X);
samelength_X=zeros(max_height,827,samples_count);
for i=1:samples_count
    samelength_X(:,:,i)=imresize(X{i},[max_height,827],method);%�Ȳ�ֵ
end

extend_CNN_X=zeros(max_height,6,1,samples_count);
sq_extend_CNN_X=zeros(max_height/4,6*4,1,samples_count);
for i=1:samples_count
    for j=1:max_height
        extend_CNN_X(j,:,1,i)=correction_method1(get_maxfeature_signal(samelength_X(j,:,i)));
    end
    
    sq_extend_CNN_X(:,:,1,i)=mat2gray([extend_CNN_X(1:24,:,1,i) extend_CNN_X(25:48,:,1,i) extend_CNN_X(49:72,:,1,i) extend_CNN_X(73:96,:,1,i)]);

end


end