function mysave(filename)
% MYSAVE ��PNG��ʽ����ͼ��
% 
% ����������ͼƬ��С���ֺ�
f = gcf;
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 7.2 5.4];
a = gca;
a.FontSizeMode = 'Manual';
a.FontSize = 7;
print(filename,'-dpng','-r600')
end