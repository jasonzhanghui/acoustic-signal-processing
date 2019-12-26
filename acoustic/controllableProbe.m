%% 
% 探头名称以及与名称同名的文件夹

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
dirPrefix = cellstr(repmat('D:\Jason\Study\Postgraduate Projects\光纤超声\可控探头制作\超声信号测量-水听器\探头',size(names,1),1));
directories = cellfun(@strcat,dirPrefix,names,'UniformOutput',false);
clearvars parentDir indices
%% 
% 导入水听器和前置放大器的频率响应数据
% 
% 探头2-4 ~ 2-8使用15号水听器，0-1 ~ 0-5、0-8 ~ 0-12、2-8 ~ 2-9使用16号水听器

sensorName = 'FOH16T';
sensorDataPath = '..\超声信号测量-水听器\FOH.mat';
if ~exist(sensorName,'var')
    load(sensorDataPath,sensorName);
end
laserPowerPath = '..\放大器电流-功率曲线\laserPower.mat';
if ~exist('laserPower','var')
    load(laserPowerPath);
end
clearvars sensorDataPath sensorName laserPowerPath
%% 
% 定义采样频率，采样点等常值参数，并且导入激光和超声的数据

probeName = input('请输入探头编号:\n','s');
index = map(probeName);
% 导入超声和激光的数据
load([directories{index},'\',probeName,'.mat'],'ultrasound','laser','sample');
% [ultrasound,laser,sample] = loadExpData(directories,index,laserPower);
% save([directories{index},'\',probeName,'.mat'],'ultrasound','laser','sample');
N = size(ultrasound.time,2);
%% 
% 校正温度带来的声速差

% [timeAligned,delay] = signalAlignment(ultrasound,20);
%% 
% 选择ROI

ROI = setROI(0.15,ultrasound,sample,N);
%%
% p = plot(ultrasound.time(:,1),ultrasound.signal,'LineWidth',2);
% plotSettings(p,probeName,ROI.timeRange(7,:));
% mysave([directories{index},'\',probeName]);
%% 
% 分析信号的参数，输出峰峰值，最大值，带宽，平均频率，探头和水听器距离，声压，能量转化效率
% 
% 能量转化效率的定义为单周期内的平均声压除以平均光功率

result = calculateParams(ultrasound,laser,sample,ROI,FOH16T,N);
% save([directories{index},'\',probeName,' result.mat'],'result');
%%
titleName = {'F-P{\fontname{宋体}干涉滴蘸法}';
            '{\fontname{宋体}插芯端面旋涂法}';
            '{\fontname{宋体}炭黑}-PDMS{\fontname{宋体}平面基板旋涂法}';
            '{\fontname{宋体}纳米碳粉}-PDMS{\fontname{宋体}平面基板旋涂法}'};
name1 = '100-4';  name2 = '100-11';
index1 = map(name1);   index2 = map(name2);
analyze(names,namesInPlot,directories,titleName{1},index1,index2);