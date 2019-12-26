function [soundPeaks,soundPeakTime,signalDetrend] = getPeaks(time,signal,fs)
% GETPEAKS ��ȡ�źŵĲ���λ�úʹ�С
% 
% ���ȶ��ź�ʹ��С��ȥ�룬������ȥ���������ƣ�֮��ʹ�û�����㷨��ȡ�źŲ���λ�ú;�ֵ
% ��ȡ��������
N = size(time,2);
% ʹ��С���㷨���ź�ȥ��
signalDenoised = wdenoise(signal, 4, 'Wavelet', 'coif4', ...
    'DenoisingMethod', 'UniversalThreshold', 'ThresholdRule', 'Soft', 'NoiseEstimate', 'LevelDependent');
% ȥ���ź��еĳ�ֵ
signalDetrend = detrend(signalDenoised,'constant');
% 7-9��Ϊ����������źţ�ֱ��ͨ�����ֵѰ�ҵ�7���źŵķ�ֵλ��
[~,peakIndex7] = max(signalDetrend(:,7));
% ��ʼ���洢���źŷ�ֵ�ͷ�ֵλ�õı���
soundPeakTime = zeros(N,1);     soundPeaks = zeros(N,1);
% �趨�������ķ�Χ��Ҳ���Ƿ�ֵ���Ҹ�corrRange����
corrRange = 30;
for i = 1:N
    % �����е��ź�������н����������
    [r,lags] = xcorr(signalDetrend(peakIndex7-corrRange:peakIndex7+corrRange,i),...
        signalDetrend(peakIndex7-corrRange:peakIndex7+corrRange,7));
    % Ѱ����ؽ���еľֲ���ֵ
    [pks,locs] = findpeaks(r);
    % �Ծֲ���ֵ����������ȡ�����ֵ��λ��
    temp = sortrows([pks,locs],'descend');
    if ~isempty(locs)
        peakLocation = temp(1,2);  % ��λΪ��s
    else
        [~,peakLocation] = max(r);
    end
    % ʹ�����ֵ��λ����Ϊ����������ÿ���źŵķ�ֵʱ��
    timeDelay = lags(peakLocation)/fs*1e6;  % ��λΪ��s
    soundPeakTime(i) = time(peakIndex7) + timeDelay;
    soundPeaks(i) = signalDetrend(peakIndex7 + lags(peakLocation),i);
end
end