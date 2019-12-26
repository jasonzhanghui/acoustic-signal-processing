function  analyze(names,namesInPlot,directories,titleName,index1,index2)
% ANALYZE ����ˮ���������ĳ����źŵĽ���������ͳ�ơ������ͻ�ͼ.
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
params = {'���ֵ';'���ֵ';'-6dB����';'ƽ��Ƶ��';'����';'��ѹ';'����ת��Ч��'};
units = {'mV';'mV';'MHz';'MHz';'cm';'kPa';'Pa/(W/m^2)'};
map = containers.Map(params,units);
sz1 = [5,length(variables)];
means = zeros(sz1);        stds = zeros(sz1);
for i = 1:length(variables)
    eval(['means(:,i) = mean(',variables{i},',2);'])
    eval(['stds(:,i) = std(',variables{i},',[],2);'])
    eval(['myBarPlot(',variables{i},''',namesInPlot,params{i},map(params{i}),titleName);'])
    mysave(['..\�����źŲ���-ˮ����\ͼ\',names{1},'~',names{end},params{i}]);
    saveas(gcf,['..\�����źŲ���-ˮ����\ͼ\',names{1},'~',names{end},params{i}]);
end
cv = stds./means;
statistics = struct('average',means,'std',stds,'cv',cv);
save(['..\�����źŲ���-ˮ����\ͳ����\',names{1},'~',names{end},'ͳ����.mat'],'statistics','-mat');
end