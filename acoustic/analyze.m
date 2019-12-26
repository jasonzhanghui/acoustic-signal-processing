function  analyze(names,namesInPlot,directories,titleName,index1,index2)
% ANALYZE 对于水听器测量的超声信号的解调结果进行统计、分析和绘图.
% 
% Detailed explanation of this function.
names = names(index1:index2);
namesInPlot = namesInPlot(index1:index2);
directories = directories(index1:index2);
sz = [15/3,length(names)];
vpp = zeros(sz);        maxima = zeros(sz);         pressure = zeros(sz);       distance = zeros(sz);
meanFreq = zeros(sz);   bandwidth = zeros(sz);      efficiency = zeros(sz);
for i = 1:length(names)
%     index = map(names{i});
    load([directories{i},'\',names{i},' result.mat'],'result');
    reorgnizedData = mat2cell(result{:,:},[3,3,3,3,3]);
    averageData = cell2mat(cellfun(@mean,reorgnizedData,'UniformOutput',false));
    vpp(:,i) = averageData(:,1);
    maxima(:,i) = averageData(:,2);
    bandwidth(:,i) = averageData(:,3);
    meanFreq(:,i) = averageData(:,4);
    distance(:,i) = averageData(:,5);
    pressure(:,i) = averageData(:,6);
    efficiency(:,i) = averageData(:,7);
end
bandwidth = mean(bandwidth);
meanFreq = mean(meanFreq);
efficiency = mean(efficiency);
variables = {'vpp';'maxima';'bandwidth';'meanFreq';'distance';'pressure';'efficiency'};
params = {'峰峰值';'最大值';'-6dB带宽';'平均频率';'距离';'声压';'能量转化效率'};
units = {'mV';'mV';'MHz';'MHz';'cm';'kPa';'Pa/(W/m^2)'};
map = containers.Map(params,units);
sz1 = [5,length(variables)];
means = zeros(sz1);        stds = zeros(sz1);
for i = 1:length(variables)
    eval(['means(:,i) = mean(',variables{i},',2);'])
    eval(['stds(:,i) = std(',variables{i},',[],2);'])
    eval(['myBarPlot(',variables{i},''',namesInPlot,params{i},map(params{i}),titleName);'])
    mysave(['..\超声信号测量-水听器\图\',names{1},'~',names{end},params{i}]);
    saveas(gcf,['..\超声信号测量-水听器\图\',names{1},'~',names{end},params{i}]);
end
cv = stds./means;
statistics = struct('average',means,'std',stds,'cv',cv);
save(['..\超声信号测量-水听器\统计量\',names{1},'~',names{end},'统计量.mat'],'statistics','-mat');
end