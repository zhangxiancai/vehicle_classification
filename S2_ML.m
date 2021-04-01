%SVM, RF
clear all
% close all
S5_EXTEND;
% S5_EXTEND_c;


%   md1=fitcecoc(ML_X,label','Learners','tree','KFold',5);
  
  md1=fitcensemble(ML_X,label','Learners','tree','Method','Bag');
  predict_label=kfoldPredict(md1);
 
  res=zeros(3,3);
  for i=1:74*6
  res(label(i)+1,predict_label(i)+1)=res(label(i)+1,predict_label(i)+1)+1;
  end

 acc=(res(1,1)+res(2,2)+res(3,3))/(74*6);
 
 
%  YPred=predict(md1,ML_X_b);
%  acc_b = sum(YPred == label_b')/numel(YPred);
%  

 
 
 
 
 
 