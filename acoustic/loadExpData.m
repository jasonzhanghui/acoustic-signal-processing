function [ultrasound,laser,sample] = loadExpData(directories,index,laserPower)
% LOADEXPDATA 导入CSV格式的实验数据
% 
% 输入路径，导入路径内所有的CSV文件，返回超声和激光的信号值
% 
% 返回值 ultrasound 包含五个字段: time,signal,temperature,peakTime,distance 时间,信号,温度,峰值时间,距离
% 
% 返回值 laser 包含三个字段: PLaser,time,signal 激光功率,时间,信号
dir = directories{index};
filelist = ls([dir,'\*.csv']);
% 数据组数
N = size(filelist,1)-1;
% 读取数据采集的间隔
interval = csvread([dir,'\',filelist(1,:)],8,1,[8,1,8,1]);
% 计算采样频率
fs = 1/interval;
% 读取激光数据长度
L = getLength([dir,'\',filelist(1,:)]);
f = fs*(0:(L/2))/L;
data = csvread([dir,'\',filelist(1,:)],21,0,[21,0,21+L-1,1]);
timeLaser = data(:,1)*1e6;   % 单位为μs
laser = data(:,2)*1000;      % 单位为mV
temperature = xlsread('D:\Jason\Study\Postgraduate Projects\光纤超声\可控探头制作\超声信号测量-水听器\温度.xlsx',...
    'Sheet1',['E',num2str(2+N*(index-1)),':E',num2str(16+N*(index-1))]);
% 读取超声数据长度
L = getLength([dir,'\',filelist(2,:)]);
sz = [L,N];     time = zeros(sz);   sound = zeros(sz);
% soundPeaks = zeros(N,1);    soundPeakTime = zeros(N,1);
for i = 1:N
    data = csvread([dir,'\',filelist(i+1,:)],21,0,[21,0,21+L-1,1]);
    time(:,i) = data(:,1)*1e6;   % 单位为μs
    sound(:,i) = data(:,2)*1000;     % 单位为mV
end
[soundPeaks,soundPeakTime,soundDetrend] = getPeaks(time,sound,fs);
[soundTroughs,soundTroughTime,~] = getPeaks(time,-sound,fs);
distance = speedSoundWater(temperature).*soundPeakTime/1e4;   % 单位为cm
% 读取每次测量使用的偏置电流值
currents = xlsread('D:\Jason\Study\Postgraduate Projects\光纤超声\可控探头制作\超声信号测量-水听器\温度.xlsx',...
    'Sheet1',['B',num2str(2+N*(index-1)),':B',num2str(16+N*(index-1))]);
% 将电流大小转换为功率大小
PLaser = laserPower{currents./0.1,2};
% 将读取的结果封装为结构体
ultrasound = struct('time',time,'signal',soundDetrend,'temperature',temperature,...
    'peaks',soundPeaks,'peakTime',soundPeakTime,'troughs',-soundTroughs,...
    'troughTime',soundTroughTime,'distance',distance);
% ultrasound = struct('time',time,'signal',sound,'temperature',temperature);
laser = struct('PLaser',PLaser,'time',timeLaser,'singal',laser);
sample = struct('fs',fs,'L',L,'f',f);
end