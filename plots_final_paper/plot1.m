clear all
clc;

ten26=[2.0936,0.0057007
3.4717,0.022786
5.0264,0.14531
6.6514,0.94752
8.3007,3.3432
9.958,6.3748
11.618,8.7731
13.278,10.947
14.939,12.576]; % replaced with OMP- was CoSAMP earlier
CO64=[2.0936,0.0039676
3.4717,0.024867
5.0264,0.064461
6.6514,0.26051
8.3007,0.8466
9.958,1.9279
11.618,3.2331
13.278,4.7389
14.939,6.2054]; %replaced with OMP - was CoSAMP earlier
CO128=[2.0813,0.0092337
3.4563,0.020197
5.0096,0.085348
6.6341,0.28609
8.2833,1.0219
9.9405,2.1417
11.6,3.5901
13.261,4.9689
14.922,6.5557];
AL64=[2.0851,0.011865
3.4621,0.041256
5.0532,0.11337
6.6405,0.39296
8.2916,1.1098
9.9469,2.3322
11.592,3.6052
13.265,4.9154
14.938,6.2639]; % 4,4,4 updated done!
AL128=[2.0813,0.012785
3.4487,0.038323
5.0159,0.12412
6.655,0.60901
8.2984,1.7917
9.9661,3.5902
11.611,5.3585
13.222,6.9984
14.923,8.5961];

x=[-20:5:20];
plot(x,ten26(:,1),'r-','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
hold on;
plot(x,ten26(:,2),'b+-','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b')
plot(x,AL64(:,2),'cs-','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','m')
plot(x,AL128(:,2),'co-','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')
plot(x,CO64(:,2),'g^--','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r')
xlim([-20,20]);
xlab=xlabel('$$\frac{\rho}{\sigma^2}$$(dB)','Interpreter','Latex')
set(xlab,'FontSize',18);
ylab=ylabel('Achievable Rate (bps/Hz)');
set(ylab,'FontSize',18);
set(gca,'fontsize',16);
h_legend=legend('Perfect CSI','Tensor based method, $M=64$','Agile Link, $M=64$','Agile Link, $M=128$','OMP ignoring CFO, $M=128$');
set(h_legend,'Interpreter','Latex','FontSize',17);
grid on;