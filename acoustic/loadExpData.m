function [ultrasound,laser,sample] = loadExpData(directories,index,laserPower)
% LOADEXPDATA ����CSV��ʽ��ʵ������
% 
% ����·��������·�������е�CSV�ļ������س����ͼ�����ź�ֵ
% 
% ����ֵ ultrasound ��������ֶ�: time,signal,temperature,peakTime,distance ʱ��,�ź�,�¶�,��ֵʱ��,����
% 
% ����ֵ laser ���������ֶ�: PLaser,time,signal ���⹦��,ʱ��,�ź�
dir = directories{index};
filelist = ls([dir,'\*.csv']);
% ��������
N = size(filelist,1)-1;
% ��ȡ���ݲɼ��ļ��
interval = csvread([dir,'\',filelist(1,:)],8,1,[8,1,8,1]);
% �������Ƶ��
fs = 1/interval;
% ��ȡ�������ݳ���
L = getLength([dir,'\',filelist(1,:)]);
f = fs*(0:(L/2))/L;
data = csvread([dir,'\',filelist(1,:)],21,0,[21,0,21+L-1,1]);
timeLaser = data(:,1)*1e6;   % ��λΪ��s
laser = data(:,2)*1000;      % ��λΪmV
temperature = xlsread('D:\Jason\Study\Postgraduate Projects\���˳���\�ɿ�̽ͷ����\�����źŲ���-ˮ����\�¶�.xlsx',...
    'Sheet1',['E',num2str(2+N*(index-1)),':E',num2str(16+N*(index-1))]);
% ��ȡ�������ݳ���
L = getLength([dir,'\',filelist(2,:)]);
sz = [L,N];     time = zeros(sz);   sound = zeros(sz);
% soundPeaks = zeros(N,1);    soundPeakTime = zeros(N,1);
for i = 1:N
    data = csvread([dir,'\',filelist(i+1,:)],21,0,[21,0,21+L-1,1]);
    time(:,i) = data(:,1)*1e6;   % ��λΪ��s
    sound(:,i) = data(:,2)*1000;     % ��λΪmV
end
[soundPeaks,soundPeakTime,soundDetrend] = getPeaks(time,sound,fs);
[soundTroughs,soundTroughTime,~] = getPeaks(time,-sound,fs);
distance = speedSoundWater(temperature).*soundPeakTime/1e4;   % ��λΪcm
% ��ȡÿ�β���ʹ�õ�ƫ�õ���ֵ
currents = xlsread('D:\Jason\Study\Postgraduate Projects\���˳���\�ɿ�̽ͷ����\�����źŲ���-ˮ����\�¶�.xlsx',...
    'Sheet1',['B',num2str(2+N*(index-1)),':B',num2str(16+N*(index-1))]);
% ��������Сת��Ϊ���ʴ�С
PLaser = laserPower{currents./0.1,2};
% ����ȡ�Ľ����װΪ�ṹ��
ultrasound = struct('time',time,'signal',soundDetrend,'temperature',temperature,...
    'peaks',soundPeaks,'peakTime',soundPeakTime,'troughs',-soundTroughs,...
    'troughTime',soundTroughTime,'distance',distance);
% ultrasound = struct('time',time,'signal',sound,'temperature',temperature);
laser = struct('PLaser',PLaser,'time',timeLaser,'singal',laser);
sample = struct('fs',fs,'L',L,'f',f);
end