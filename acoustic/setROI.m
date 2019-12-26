function ROI = setROI(scope,ultrasound,sample,N)
% SETROI �趨ROI
% 
% ��ȡ��ʱ���Խ�̣�Ƶ�׷ֱ���Խ��
% 
% Ƶ�׵����Ƶ�ʺͲ�������йأ�Ϊһ���̶�ֵ
% ultrasoundΪ�洢�������ݵĽṹ��
time = ultrasound.time;
% ȡ��ֵʱ���������߸� scope ΢���ʱ�䷶Χ
timeRange = [-1,1]*scope + ultrasound.peakTime;
% ����ÿһ�У�Ѱ�Ҹ�ʱ�䷶Χ��Ӧ�������±�
pos1 = find(abs(time-timeRange(:,1)')<1e-6)-sample.L*(0:1:N-1)';
pos2 = find(abs(time-timeRange(:,2)')<1e-6)-sample.L*(0:1:N-1)';
% ���ظ�ʱ�䷶Χ�������±귶Χ
ROI = struct('timeRange',timeRange,'pos1',pos1,'pos2',pos2);
end