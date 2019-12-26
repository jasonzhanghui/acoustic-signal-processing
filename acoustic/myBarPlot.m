function myBarPlot(data,names,yname,unit,titleName)
if size(data,2) > 1
    bar(gca,data,'BarWidth',1);
else
    bar(gca,data,'BarWidth',0.8,'LineWidth',1,'FaceColor',[237,177,32]/255);
end
ylabel(['{\fontname{ËÎÌå}',yname,'} (',unit,')']);
xlabel('{\fontname{ËÎÌå}Ì½Í·±àºÅ}');
title(titleName,'FontWeight','bold');
labels = {'3mW';'7mW';'23mW';'7mW';'3mW'};
if size(data,2) > 1
    legend(labels,'Location','bestoutside');
end
set(gca,'FontName','Times New Roman','FontSize',16,'FontWeight','bold',...
    'XTickLabel',names);
set(gcf,'Visible','on');
end