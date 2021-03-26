function samelength_maxfeature_X=set_SameLength_1(maxfeature_X)
 %使maxfeature_X的尺寸一致
 %输入=cell(1,74)
  %输出=70*6*74
 
 heights=zeros(1,74);
 for i=1:74
     [heights(i),~]=size(maxfeature_X{i});
 end
  max_height=max(heights);
  samelength_maxfeature_X=zeros(70,6,74);
  for i=1:74
      samelength_maxfeature_X(:,:,i)=imresize(maxfeature_X{i},[max_height,6]);%
  end
 end