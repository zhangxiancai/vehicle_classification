function D_X=medianfilt(X,l)
%ÖÐÖµÂË²¨
h_l=floor(l/2);
[~,s]=size(X);
D_X=X;
for i=1:h_l
   D_X(i)=median(X(1:2*i));
end
for i=h_l+1:s-h_l
   D_X(i)=median(X(i-h_l:i+h_l)); 
end
for i=s-h_l+1:s
   D_X(i)=median(X(2*i-s:s));
end
%  figure;plot(X);hold on;plot(D_X);
end