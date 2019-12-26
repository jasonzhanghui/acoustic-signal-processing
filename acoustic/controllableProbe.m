%% 
% ̽ͷ�����Լ�������ͬ�����ļ���

names = {'0-1';'0-3';'0-4';'0-5';
        '0-6';'0-7';'0-8';
        '0-9';'0-10';'0-11';'0-12';'0-13';'0-14';'0-15';'0-16';'0-17';
        '100-4';'100-5';'100-6';'100-7';'100-8';'100-9';'100-10';'100-11';'100-12';'100-13'};
namesInPlot = {'0-1';'0-2';'0-3';'0-4';
    '';'';'';
    '0-5';'0-6';'0-7';'0-8';'0-9';'0-10';'0-11';'0-12';'0-13';
    '100-1';'100-2';'100-3';'100-4';'100-5';'100-6';'100-7';'100-8';'100-9';'100-10'};
indices = 1:1:length(names);
% values = cellfun(@(a,b) {a,b},namesInPlot,num2cell(indices'),'UniformOutput',false);
map = containers.Map(names,indices);
dirPrefix = cellstr(repmat('D:\Jason\Study\Postgraduate Projects\���˳���\�ɿ�̽ͷ����\�����źŲ���-ˮ����\̽ͷ',size(names,1),1));
directories = cellfun(@strcat,dirPrefix,names,'UniformOutput',false);
clearvars parentDir indices
%% 
% ����ˮ������ǰ�÷Ŵ�����Ƶ����Ӧ����
% 
% ̽ͷ2-4 ~ 2-8ʹ��15��ˮ������0-1 ~ 0-5��0-8 ~ 0-12��2-8 ~ 2-9ʹ��16��ˮ����

sensorName = 'FOH16T';
sensorDataPath = '..\�����źŲ���-ˮ����\FOH.mat';
if ~exist(sensorName,'var')
    load(sensorDataPath,sensorName);
end
laserPowerPath = '..\�Ŵ�������-��������\laserPower.mat';
if ~exist('laserPower','var')
    load(laserPowerPath);
end
clearvars sensorDataPath sensorName laserPowerPath
%% 
% �������Ƶ�ʣ�������ȳ�ֵ���������ҵ��뼤��ͳ���������

probeName = input('������̽ͷ���:\n','s');
index = map(probeName);
% ���볬���ͼ��������
load([directories{index},'\',probeName,'.mat'],'ultrasound','laser','sample');
% [ultrasound,laser,sample] = loadExpData(directories,index,laserPower);
% save([directories{index},'\',probeName,'.mat'],'ultrasound','laser','sample');
N = size(ultrasound.time,2);
%% 
% У���¶ȴ��������ٲ�

% [timeAligned,delay] = signalAlignment(ultrasound,20);
%% 
% ѡ��ROI

ROI = setROI(0.15,ultrasound,sample,N);
%%
% p = plot(ultrasound.time(:,1),ultrasound.signal,'LineWidth',2);
% plotSettings(p,probeName,ROI.timeRange(7,:));
% mysave([directories{index},'\',probeName]);
%% 
% �����źŵĲ�����������ֵ�����ֵ������ƽ��Ƶ�ʣ�̽ͷ��ˮ�������룬��ѹ������ת��Ч��
% 
% ����ת��Ч�ʵĶ���Ϊ�������ڵ�ƽ����ѹ����ƽ���⹦��

result = calculateParams(ultrasound,laser,sample,ROI,FOH16T,N);
% save([directories{index},'\',probeName,' result.mat'],'result');
%%
titleName = {'F-P{\fontname{����}�����պ��}';
            '{\fontname{����}��о������Ϳ��}';
            '{\fontname{����}̿��}-PDMS{\fontname{����}ƽ�������Ϳ��}';
            '{\fontname{����}����̼��}-PDMS{\fontname{����}ƽ�������Ϳ��}'};
name1 = '100-4';  name2 = '100-11';
index1 = map(name1);   index2 = map(name2);
analyze(names,namesInPlot,directories,titleName{1},index1,index2);