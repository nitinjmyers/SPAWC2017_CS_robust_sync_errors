function nmat=ntnmtx(G,N)
 nmat=zeros(N,G);
 ang=[0:1:G-1]*2*pi/G;
 for i=1:1:G
    nmat(:,i)=exp(1i*ang(i)*[0:1:N-1]).';
 end
 nmat=nmat/sqrt(N);
 end