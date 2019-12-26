%******************************ǻ�����******************************%
clc;clear;
format short;
% ·��2:Ӳ���д洢���ݵ�·��
dir2 = 'D:\Jason\Study\Postgraduate Projects\���˳���\�ɿ�̽ͷ����\100΢��̽ͷ\̽ͷ2-13\';
% dir2 = 'D:\Jason\Study\Postgraduate Projects\���˳���\�ɿ�̽ͷ����\0΢��̽ͷ\ֱ����Ϳ̽ͷ';
% ����������򴴽���·��
if ~exist(dir2,'dir')
    mkdir(dir2);
end
% ��·���е�csv�ļ��б�
filelist2 = ls([dir2,'\*.csv']);
% ��ȡU���е��ļ��б����ĳ��csv�������������ļ��У����Ƶ������ļ���
if exist('I:\','dir')
    dir1 = 'I:\';       % ·��1:U��
    filelist1 = ls([dir1,'*.csv']);
    idx = ismember(filelist1,filelist2,'rows');
    for i = 1:size(filelist1,1)
        if ~idx(i)
            copyfile([dir1,filelist1(i,:)],dir2);
        end
    end
    filelist2 = ls([dir2,'\*.csv']);
end
N = size(filelist2,1);
for i = 1:N
    data(:,:,i) = csvread([dir2,'\',filelist2(i,:)],30);
end
% ��ʼ���洢���壬���ȣ����漶�εȲ����ı���
init = @(m) zeros(N,m);
troughWL = init(2);
L = init(1);    % peakWL = init(1); m = init(1);  R1 = init(1); R2 = init(1); n1 = init(1); n2 = init(1);
for i=1:N
    wavelength = data(:,1,i);   %����
    % y=10.^(A(:,2,i)./10);
    intensity = smooth(data(:,2,i),200,'lowess');   %��ǿ
    plot(wavelength,intensity,'linewidth',2);hold on;

    % ********************��˫����ǻ��************************%
    % Ѱ�Ҳ�������Ӧ�Ĳ���
    [troughs,locs] = findpeaks(-intensity,wavelength);
    troughWL(i,:) = mink(locs',2);
    trough = -troughs(1);
    w1 = troughWL(i,1);
    w2 = troughWL(i,2);
    % ������漶��
    m(i) = round(w1./(w2-w1));
    % ����ǻ��
    L(i) = m(i).*w2./2./1000;
    % m_min(i)=round((wmin(1,i)./(wmin(2,i)-wmin(1,i)))); %ȷ�����漶��m
    % L_min(i)=m_min(i).*wmin(2,i)./2000;                 %��ǻ��
    % text(wmin(1,i),y(tmin(1,i)+n(1)-1),'��','color',color,'HorizontalAlignment','center');
    % ���岨����������������
    
%     % �󲨷�Ĵ�С��λ��
%     [pks,locs] = findpeaks(intensity,wavelength);
%     % ������ɸ�����λ�ã�ȡ��һ��
%     peakWL(i) = min(locs);
%     peak = pks(1);
%     a = w1.*L(i)./37714.8;
%     coff = (4+4.*a.^2)./((2+a.^2).^2);
%     % ���㷴����
%     R1(i) = (((sqrt(peak)+sqrt(trough))/2).^2);
%     R2(i) = (((sqrt(peak)-sqrt(trough))/2).^2)/coff;
%     % ����������
%     n1(i) = (sqrt(R1(i))+1)./(1-sqrt(R1(i)))*1.4682;
%     n2(i) = (sqrt(R2(i))+1)./(1-sqrt(R2(i)))*1;
end
hold off
% plot(wavelength,reshape(data(:,2,:),10000,N))
fprintf('Cavity length:\n')
disp(L')
if N > 5
    disp('Average cavity length:')
    disp(mean(L(end-4:end)))
end