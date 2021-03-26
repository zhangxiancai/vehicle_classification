function samelength_maxfeature_X=set_SameLength_ML(maxfeature_X)
 %使maxfeature_X的尺寸一致
 %maxfeature_X=cell(1,74)
  %samelength_maxfeature_X=74行700列
 
 heights=zeros(1,74);
 for i=1:74
     [heights(i),~]=size(maxfeature_X{i});
 end
  max_height=max(heights);
  samelength_maxfeature_X=zeros(74,max_height*10);
  for i=1:74
      samelength_maxfeature_X(i,:)=reshape([maxfeature_X{i};zeros(max_height-heights(i),10)]',[1,max_height*10]);
  end
 end