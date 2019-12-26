function mysave(filename)
% MYSAVE 以PNG格式保存图像
% 
% 可自行设置图片大小和字号
f = gcf;
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 7.2 5.4];
a = gca;
a.FontSizeMode = 'Manual';
a.FontSize = 7;
print(filename,'-dpng','-r600')
end