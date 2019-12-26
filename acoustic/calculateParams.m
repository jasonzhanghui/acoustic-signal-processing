function params = calculateParams(ultrasound,laser,sample,ROI,FOH,N)
% CALCULATEPARAMS 计算超声信号的时域和频域指标
% 
% 输入六个参数: 
% 
% ultrasound-存储超声数据的结构体       laser-存储激光数据的结构体                sample-存储采样信息的结构体
% 
% ROI-存储感兴趣的范围的结构体          FOH-存储光纤水听器灵敏度的表格     N-数据的组数
% 
% 输出一个表格-params,包含ROI的六个参数
% 
% maxima-信号的最大值                   bandwidth-信号的带宽         meanFreq-信号的平均频率
% 
% distance-探头与水听器的距离      pressure-声压值                    efficiency-能量转化效率
% 从结构体中提取所需的变量
time = ultrasound.time;
sound = ultrasound.signal;
PLaser = laser.PLaser;
fs = sample.fs;
pos1 = ROI.pos1;
pos2 = ROI.pos2;
temperature = ultrasound.temperature;
peaks = ultrasound.peaks;
troughs = ultrasound.troughs;
distance = ultrasound.distance;
repRate = 1000;
pulseWidth = 5e-9;
maxima = max(abs(peaks),abs(troughs));
vpp = abs(peaks-troughs);
% 初始化循环体中所用变量
bandwidth = zeros(N,1);     %vpp = zeros(N,1);            maxima = zeros(N,1);        
meanFreq = zeros(N,1);      pressure = zeros(N,1);      efficiency = zeros(N,1);
LROI = pos2-pos1+1;
for i = 1:N
    timeROI = time(pos1(i):pos2(i),1)/1e6;     % 单位为s
    signalROI = sound(pos1(i):pos2(i),i);
    signalROIDetrend = detrend(signalROI,'constant');
    % 每个波形的最大值
%     maxima(i) = max(signalROI);
    % 每个波形的峰峰值
    % vpp(i) = (maxima(i)-min(signalROI));   % 单位为mV
    % 信号加窗
    w = flattopwin(LROI(i));
    signalROIWindowed = signalROIDetrend.*w;
%     hold on
%     plot(timeROI,signalROIWindowed);
    meanFreq(i) = meanfreq(signalROIWindowed,fs,[10e6,30e6])/1e6;
%     meanFreq(i) = meanfreq(signalROIWindowed,fs)/1e6;
%     medianFreq(i) = medfreq(signalROIWindowed,fs,[0e6,30e6])/1e6;
%     freqrange = meanFreq(i)*1e6+[0,100e6];
%     if freqrange(1) < 0
%         freqrange(1) = 0;
%     elseif freqrange(2) > 30e6
%         freqrange(2) = 30e6;
%     end
    bandwidth(i) = powerbw(signalROIWindowed,fs,[],6)/1e6;
%     bandwidth(i) = powerbw(signalROIWindowed,fs,6)/1e6;
    % 使用PVDF水听器计算声压
    %{
    % 前置放大器数据列表中和当前信号频率最接近的频率值的下标
    [~,Igain] = min( abs(preamp.Freq-meanFreq(i)) );
    gain = db2mag(preamp.Gain_dB(Igain));
    % 水听器数据列表中和当前信号频率最接近的频率值的下标
    [~,Isens] = min( abs(hydrophone.Freq-meanFreq(i)) );
    sens = hydrophone.Sens_V_Pa(Isens);
    % 从测得的电压值(mV)到光纤发射位置的声压值(kPa)的转换倍数，衰减用+dB表示，因此是乘法
    K = 1/(1e3*gain*sens)*db2mag(attenuationWater( meanFreq(i),temperature(i) )*distance(i) )/1e3;
    pressure(i) = K*maxima(i);  % 单位为kPa
    %}
    % 使用光纤水听器计算声压
    % 当前频率为meanFreq(i)，取离该点最近的两个整数频率点，做插值，得到该频率下的灵敏度，单位为mV/MPa
    if meanFreq(i) <= 30
        [~,Isens] = mink( abs(FOH.Freq_MHz-meanFreq(i)), 2);
        sens = FOH.Senstivity_mV_MPa(Isens);
        interpCoeff = abs(Isens-meanFreq(i));
        sens = interpCoeff'*sens;
    else 
        sens = FOH.Senstivity_mV_MPa(end);
    end
    % 补偿衰减
    atten = db2mag(attenuationWater( meanFreq(i),temperature(i) )*( distance(i)-0.001 ) );
    % 补偿球面波
%     circCoeff = distance(i)/0.001;      % 距离单位为cm，将接收位置的声压转换为0.001cm，也就是10μm位置处的声压
    circCoeff = 1;
    % 计算从水听器接收的电压值到真实声压值的转换倍数，单位为kPa
    K = 1/sens*atten*circCoeff*1e3;
    % 计算真实的声压值
    pressure(i) = vpp(i)*K;  % 单位为kPa
    A = pi*(125e-6/2)^2;    % 声场的面积，单位m^2
    % 能量转化效率-无量纲
    %{
    rho = 1000;     % 水的密度，单位kg/m^3
    c = speedSoundWater(temperature(i));     % 水中的声速，单位m/s
    EAcous = A/(rho*c)*trapz(timeROI,(signalROI*K*1e3).^2);    % 超声的能量，单位J
    ELaser = PLaser(i)/1e3*1/1e3;  % 激光的能量，单位J
    efficiency(i) = EAcous/ELaser;
    %}
    % 能量转化效率-Pa/(W/m^2)
    period = timeROI(end)-timeROI(1);     % ROI的时间跨度
    % 将激光在一个周期内的平均功率转化为一个脉冲内的平均功率
    PLaserPeak = PLaser(i)*1e-3/repRate/pulseWidth;     % 单位为W
    efficiency(i) = trapz(timeROI,abs(signalROI)*K*1e3)/period / (PLaserPeak/(1e3)/A);
end
% hold off
params = table(vpp,maxima,bandwidth,meanFreq,distance,pressure,efficiency);
% params.Properties.VariableUnits = {'mV','mV','MHz','MHz','cm','kPa','Pa/(w/m^2)'};
end