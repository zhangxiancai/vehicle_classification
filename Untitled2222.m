a=1;b=1;h=1;l=1;
f=@(y)sqrt(1-y.^2/b.^2);
S=2*a*integral(f,-b,h-b)
V=l*S

