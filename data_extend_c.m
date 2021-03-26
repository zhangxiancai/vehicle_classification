function ML_X=data_extend_c(X,method)
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

sl_maxfeature_X=zeros(8,6,samples_count);
for i=1:samples_count
%     sl_maxfeature_X(:,:,i)=imresize(maxfeature_X{i},[max_height,6],method);%�ٲ�ֵ
    
    [height,~]=size(maxfeature_X{i});
    step=height/8;
    for j=1:8
        sl_maxfeature_X(j,:,i)=mean(maxfeature_X{i}(floor(step)*(j-1)+1:floor(step*j),:));
    end
end


ML_X=zeros(samples_count,48);
for i=1:samples_count
    ML_X(i,:)=reshape(sl_maxfeature_X(:,:,i),[1,48]);
end


end







