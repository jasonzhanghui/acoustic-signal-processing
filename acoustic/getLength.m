function len = getLength(filePath)
% GETLENGTH ��ȡʾ�����洢��csv�ļ������ݳ���
% 
% ͨ��csv�ļ���ʮһ�е�gating��Ϣ������
recordLength = csvread(filePath,9,1,[9,1,9,1]);
fileID = fopen(filePath,'r');
% ����ǰʮ��
for i = 1:10
    fgetl(fileID);
end
line = fgetl(fileID);
% ��ȡ����gating��ѡͨ����Ϣ����
temp = textscan(line,'%s%f%s%f','Delimiter',{',','to'});
% ��ȡѡͨ��Χ
gating = [temp{2},temp{4}];
len = round(recordLength*(gating(2)-gating(1))/100);
end