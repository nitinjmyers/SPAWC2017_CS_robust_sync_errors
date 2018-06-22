function H=Hmat(N_r,N_t,N_p,tp)

if(tp==1)
N_ray=15;

Aspr=3; %degrees [-Aspr,Aspr]
Aspr=Aspr*pi/180;
Atm=(pi*rand(1,N_p))-(pi/2);
Arm=(pi*rand(1,N_p))-(pi/2);
theta_t=[];
theta_r=[];
for i=1:1:N_p
     Rt=(2*rand(1,N_ray))-1;  
     Rr=(2*rand(1,N_ray))-1;  
     theta_t=[theta_t,Atm(i)+(pi*exprnd(3.6,1,N_ray).*Rt/180)];
     theta_r=[theta_r,Arm(i)+(pi*exprnd(3.6,1,N_ray).*Rr/180)];
end


  theta_t=pi*sin(theta_t);  %angles off the grid
  theta_r=pi*sin(theta_r);    
  H=0;
  gain=(randn(1,N_ray*N_p)+1i*randn(1,N_ray*N_p))/sqrt(2);
  for k=1:1:N_ray*N_p
       H=H+(gain(k)*exp(1i*theta_r(k)*[0:1:N_r-1].')*exp(1i*theta_t(k)*[0:1:N_t-1]));
  end
  H=H/sqrt(N_ray*N_p);
else
 
 
   if(tp==2)
   theta_t=2*pi*(randsample(N_t,N_p)-1)/N_t;  %angles on the grid
   theta_r=2*pi*(randsample(N_r,N_p)-1)/N_r;
   else
   theta_t=pi*sin(pi*rand(N_p,1));  %angles off the grid
   theta_r=pi*sin(pi*rand(N_p,1));    
   end
   H=0;
   gain=(randn(1,N_p)+1i*randn(1,N_p))/sqrt(2);
   for k=1:1:N_p
        H=H+(gain(k)*exp(1i*theta_r(k)*[0:1:N_r-1].')*exp(1i*theta_t(k)*[0:1:N_t-1]));
   end
   H=H/sqrt(N_p);
end 
end