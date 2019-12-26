function [timeAligned,delay] = signalAlignment(ultrasound,referenceT)
%SIGNALALIGNMENT 将超声信号的达到时间修正到同一温度下
%   输入两个参数：
%   ultrasound-包含超声信号的结构体
%   referenceT-参考温度
%   根据 ultrasound 中的 peaktime 和 distance, 将 time 修正到 referenceT 温度下

time = ultrasound.time;             % 单位为μs
peakTime = ultrasound.peakTime;     % 单位为μs
distance = ultrasound.distance;     % 单位为cm
v0 = speedSoundWater(referenceT);   % 单位为m/s
delay = peakTime - distance./v0*1e4;    %单位为μs
timeAligned = time - delay.';
end

