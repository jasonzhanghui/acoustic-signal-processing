function len = getLength(filePath)
% GETLENGTH 读取示波器存储的csv文件的数据长度
% 
% 通过csv文件第十一行的gating信息来计算
recordLength = csvread(filePath,9,1,[9,1,9,1]);
fileID = fopen(filePath,'r');
% 跳过前十行
for i = 1:10
    fgetl(fileID);
end
line = fgetl(fileID);
% 读取包含gating（选通）信息的行
temp = textscan(line,'%s%f%s%f','Delimiter',{',','to'});
% 获取选通范围
gating = [temp{2},temp{4}];
len = round(recordLength*(gating(2)-gating(1))/100);
end