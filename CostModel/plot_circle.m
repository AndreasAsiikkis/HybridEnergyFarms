function plot_circle(sustained_EtoS_vector_perelements)
p = colormap(jet);

for i=2:19
    circles(FB.CG(i,1),FB.CG(i,2),2.5, 'color',p(P_mapped(i-1),:));
    hold on
    text(FB.CG(i,1)-4,FB.CG(i,2)-6,num2str(data(i-1),'%1.2f'),'fontsize',12,'Interpreter', 'Latex');
end
circles(FB.CG(1,1),FB.CG(1,2),4, 'color','white')
%caxis([data_l_bond data_u_bond])
%colorbar
axis([-35 35 -35 30]);
pbaspect([1 65/70 1])
box on
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
end



% p = colormap(jet);
% l_bond = 1;
% u_bond = length(p);
% P_mapped = round((data-data_l_bond)*(u_bond-l_bond)/(data_u_bond-data_l_bond) + l_bond);
% %title(['Capture power of WEC array', ', H=',num2str(simu.waves.H,'%1.1f'),', T=',num2str(simu.waves.T,'%2.1f'),', ratio=',num2str(PTO.MPP.ratio,'%2.2f')]);
% for i=2:19
%     circles(FB.CG(i,1),FB.CG(i,2),2.5, 'color',p(P_mapped(i-1),:));hold on
% end
% circles(FB.CG(1,1),FB.CG(1,2),4, 'color','white')
% caxis([data_l_bond data_u_bond])
% colorbar
% axis([-35 35 -30 30]);
% pbaspect([1 6/7 1])
% box on