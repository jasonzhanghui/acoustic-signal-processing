function ROI = setROI(scope,ultrasound,sample,N)
% SETROI 设定ROI
% 
% 截取的时间段越短，频谱分辨率越低
% 
% 频谱的最高频率和采样间隔有关，为一个固定值
% ultrasound为存储超声数据的结构体
time = ultrasound.time;
% 取峰值时间左右两边各 scope 微秒的时间范围
timeRange = [-1,1]*scope + ultrasound.peakTime;
% 对于每一行，寻找该时间范围对应的数组下标
pos1 = find(abs(time-timeRange(:,1)')<1e-6)-sample.L*(0:1:N-1)';
pos2 = find(abs(time-timeRange(:,2)')<1e-6)-sample.L*(0:1:N-1)';
% 返回该时间范围和数组下标范围
ROI = struct('timeRange',timeRange,'pos1',pos1,'pos2',pos2);
end