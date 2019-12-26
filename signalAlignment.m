function [timeAligned,delay] = signalAlignment(ultrasound,referenceT)
%SIGNALALIGNMENT �������źŵĴﵽʱ��������ͬһ�¶���
%   ��������������
%   ultrasound-���������źŵĽṹ��
%   referenceT-�ο��¶�
%   ���� ultrasound �е� peaktime �� distance, �� time ������ referenceT �¶���

time = ultrasound.time;             % ��λΪ��s
peakTime = ultrasound.peakTime;     % ��λΪ��s
distance = ultrasound.distance;     % ��λΪcm
v0 = speedSoundWater(referenceT);   % ��λΪm/s
delay = peakTime - distance./v0*1e4;    %��λΪ��s
timeAligned = time - delay.';
end

