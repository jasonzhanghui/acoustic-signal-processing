function plotSettings(p,probeName,timeRange)

title(['{\fontname{宋体}探头}',probeName]);
xlim(timeRange);
% linestyles = {'-','-','-','--','--','--',':',':',':',':',':',':','--','--','--','-','-','-'}';
linestyles = {'-','-','-','--','--','--',':',':',':','--','--','--','-','-','-'}';
set(p,{'LineStyle'},linestyles);
xlabel('{\fontname{宋体}时间} (μs)');  ylabel('{\fontname{宋体}电压} (mV)');
% legends = {
% '正行程1.6A第1次','正行程1.6A第2次','正行程1.6A第3次',...
% '正行程1.8A第1次','正行程1.8A第2次','正行程1.8A第3次',...
% '正行程2.0A第1次','正行程2.0A第2次','正行程2.0A第3次',...
% '反行程1.8A第1次','反行程1.8A第2次','反行程1.8A第3次',...
% '反行程1.6A第1次','反行程1.6A第2次','反行程1.6A第3次'};
% legend(legends,'Location','bestoutside');
legend({'1','','','','','','','','','2','','','','','','','','','3','','','','','','','',''})
set(gca,'FontSize',16,'FontName','Times New Roman','FontWeight','Bold');
end