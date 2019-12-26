function params = calculateParams(ultrasound,laser,sample,ROI,FOH,N)
% CALCULATEPARAMS ���㳬���źŵ�ʱ���Ƶ��ָ��
% 
% ������������: 
% 
% ultrasound-�洢�������ݵĽṹ��       laser-�洢�������ݵĽṹ��                sample-�洢������Ϣ�Ľṹ��
% 
% ROI-�洢����Ȥ�ķ�Χ�Ľṹ��          FOH-�洢����ˮ���������ȵı��     N-���ݵ�����
% 
% ���һ�����-params,����ROI����������
% 
% maxima-�źŵ����ֵ                   bandwidth-�źŵĴ���         meanFreq-�źŵ�ƽ��Ƶ��
% 
% distance-̽ͷ��ˮ�����ľ���      pressure-��ѹֵ                    efficiency-����ת��Ч��
% �ӽṹ������ȡ����ı���
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
% ��ʼ��ѭ���������ñ���
bandwidth = zeros(N,1);     %vpp = zeros(N,1);            maxima = zeros(N,1);        
meanFreq = zeros(N,1);      pressure = zeros(N,1);      efficiency = zeros(N,1);
LROI = pos2-pos1+1;
for i = 1:N
    timeROI = time(pos1(i):pos2(i),1)/1e6;     % ��λΪs
    signalROI = sound(pos1(i):pos2(i),i);
    signalROIDetrend = detrend(signalROI,'constant');
    % ÿ�����ε����ֵ
%     maxima(i) = max(signalROI);
    % ÿ�����εķ��ֵ
    % vpp(i) = (maxima(i)-min(signalROI));   % ��λΪmV
    % �źżӴ�
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
    % ʹ��PVDFˮ����������ѹ
    %{
    % ǰ�÷Ŵ��������б��к͵�ǰ�ź�Ƶ����ӽ���Ƶ��ֵ���±�
    [~,Igain] = min( abs(preamp.Freq-meanFreq(i)) );
    gain = db2mag(preamp.Gain_dB(Igain));
    % ˮ���������б��к͵�ǰ�ź�Ƶ����ӽ���Ƶ��ֵ���±�
    [~,Isens] = min( abs(hydrophone.Freq-meanFreq(i)) );
    sens = hydrophone.Sens_V_Pa(Isens);
    % �Ӳ�õĵ�ѹֵ(mV)�����˷���λ�õ���ѹֵ(kPa)��ת��������˥����+dB��ʾ������ǳ˷�
    K = 1/(1e3*gain*sens)*db2mag(attenuationWater( meanFreq(i),temperature(i) )*distance(i) )/1e3;
    pressure(i) = K*maxima(i);  % ��λΪkPa
    %}
    % ʹ�ù���ˮ����������ѹ
    % ��ǰƵ��ΪmeanFreq(i)��ȡ��õ��������������Ƶ�ʵ㣬����ֵ���õ���Ƶ���µ������ȣ���λΪmV/MPa
    if meanFreq(i) <= 30
        [~,Isens] = mink( abs(FOH.Freq_MHz-meanFreq(i)), 2);
        sens = FOH.Senstivity_mV_MPa(Isens);
        interpCoeff = abs(Isens-meanFreq(i));
        sens = interpCoeff'*sens;
    else 
        sens = FOH.Senstivity_mV_MPa(end);
    end
    % ����˥��
    atten = db2mag(attenuationWater( meanFreq(i),temperature(i) )*( distance(i)-0.001 ) );
    % �������沨
%     circCoeff = distance(i)/0.001;      % ���뵥λΪcm��������λ�õ���ѹת��Ϊ0.001cm��Ҳ����10��mλ�ô�����ѹ
    circCoeff = 1;
    % �����ˮ�������յĵ�ѹֵ����ʵ��ѹֵ��ת����������λΪkPa
    K = 1/sens*atten*circCoeff*1e3;
    % ������ʵ����ѹֵ
    pressure(i) = vpp(i)*K;  % ��λΪkPa
    A = pi*(125e-6/2)^2;    % �������������λm^2
    % ����ת��Ч��-������
    %{
    rho = 1000;     % ˮ���ܶȣ���λkg/m^3
    c = speedSoundWater(temperature(i));     % ˮ�е����٣���λm/s
    EAcous = A/(rho*c)*trapz(timeROI,(signalROI*K*1e3).^2);    % ��������������λJ
    ELaser = PLaser(i)/1e3*1/1e3;  % �������������λJ
    efficiency(i) = EAcous/ELaser;
    %}
    % ����ת��Ч��-Pa/(W/m^2)
    period = timeROI(end)-timeROI(1);     % ROI��ʱ����
    % ��������һ�������ڵ�ƽ������ת��Ϊһ�������ڵ�ƽ������
    PLaserPeak = PLaser(i)*1e-3/repRate/pulseWidth;     % ��λΪW
    efficiency(i) = trapz(timeROI,abs(signalROI)*K*1e3)/period / (PLaserPeak/(1e3)/A);
end
% hold off
params = table(vpp,maxima,bandwidth,meanFreq,distance,pressure,efficiency);
% params.Properties.VariableUnits = {'mV','mV','MHz','MHz','cm','kPa','Pa/(w/m^2)'};
end