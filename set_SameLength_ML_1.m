
 function samelength_maxfeature_X=set_SameLength_ML_1(maxfeature_X)
 %ʹmaxfeature_X�ĳߴ�һ��
 %maxfeature_X=cell(1,74)
  %samelength_maxfeature_X=74��700��
 
 heights=zeros(1,74);
 for i=1:74
     [heights(i),~]=size(maxfeature_X{i});
 end
  max_height=max(heights);
  samelength_maxfeature_X=zeros(74,max_height*6);
  for i=1:74
      samelength_maxfeature_X(i,:)=reshape(imresize(maxfeature_X{i},[max_height,6])',[1 max_height*6]);
  end
 end