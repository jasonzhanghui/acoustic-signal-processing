function [soundPeaks,soundPeakTime,signalDetrend] = getPeaks(time,signal,fs)
% GETPEAKS 提取信号的波峰位置和大小
% 
% 首先对信号使用小波去噪，接下来去除线性趋势，之后使用互相关算法提取信号波峰位置和均值
% 读取数据组数
N = size(time,2);
% 使用小波算法对信号去噪
signalDenoised = wdenoise(signal, 4, 'Wavelet', 'coif4', ...
    'DenoisingMethod', 'UniversalThreshold', 'ThresholdRule', 'Soft', 'NoiseEstimate', 'LevelDependent');
% 去除信号中的常值
signalDetrend = detrend(signalDenoised,'constant');
% 7-9列为信噪比最大的信号，直接通过最大值寻找第7列信号的峰值位置
[~,peakIndex7] = max(signalDetrend(:,7));
% 初始化存储声信号峰值和峰值位置的变量
soundPeakTime = zeros(N,1);     soundPeaks = zeros(N,1);
% 设定相关运算的范围，也就是峰值左右各corrRange个点
corrRange = 30;
for i = 1:N
    % 所有列的信号与第七列进行相关运算
    [r,lags] = xcorr(signalDetrend(peakIndex7-corrRange:peakIndex7+corrRange,i),...
        signalDetrend(peakIndex7-corrRange:peakIndex7+corrRange,7));
    % 寻找相关结果中的局部极值
    [pks,locs] = findpeaks(r);
    % 对局部极值进行排序，以取得最大极值的位置
    temp = sortrows([pks,locs],'descend');
    if ~isempty(locs)
        peakLocation = temp(1,2);  % 单位为μs
    else
        [~,peakLocation] = max(r);
    end
    % 使用最大极值的位置作为索引，计算每组信号的峰值时间
    timeDelay = lags(peakLocation)/fs*1e6;  % 单位为μs
    soundPeakTime(i) = time(peakIndex7) + timeDelay;
    soundPeaks(i) = signalDetrend(peakIndex7 + lags(peakLocation),i);
end
end