ten26=[5.8155
    8.1550
    6.5534
    4.4325
    3.0610
    2.5995
    2.3339
    2.2224
    2.1705
    2.1475]; % updated 

co50=[1.8798
   1.8648
   1.8470
   1.9891
   1.9764
   2.0632
   2.0819
   2.1000
   2.0778
   1.9845];

x=[0,0.125,[0.25:0.25:2]];

plot(x,9.9236*ones(size(x)),'r-','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r') % Perfect CSI
hold on;
% AL-M=64
plot(x,ten26,'b+-','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b')
plot(x,2.3322*ones(size(x)),'cs-','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','m') % Agile link(AL) considers only magnitude-
%so no need to evaluate AL for different values of phase noise. Further,
%noise statistics will also remain the same.
plot(x,co50,'g^--','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r')
xlab=xlabel('Phase noise standard deviation  $$\tau$$ (rad)','Interpreter','Latex')
set(xlab,'FontSize',18);
ylab=ylabel('Achievable Rate (bps/Hz)');
xlim([0,1.25])
ylim([0,10.5])
set(ylab,'FontSize',18);
set(gca,'fontsize',16);
h_legend=legend('Perfect CSI','Tensor based method, $M=64$','Agile Link, $M=64$','OMP ignoring CFO, $M=64$');
set(h_legend,'Interpreter','Latex','FontSize',17);
grid on;