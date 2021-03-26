function D_X=my_dilate(X)
%“ªŒ¨≈Ú’Õ∫Ø ˝,5
%X=1*n
l=5;%25
h_l=floor(l/2);
[~,s]=size(X);
D_X=X;
for i=h_l+1:s-h_l
   D_X(i)=max(X(i-h_l:i+h_l)); 
end


end