clc;close all;clear all;
File_name='20170407 CHAPS,Triton, SDS, Ami_DEPC_zeta';
File_Location='H:\DLS';

cd(File_Location);
Data=xlsread(File_name);

ZetaPotential=1000*(Data([3:406],4));
RelativeFrequency=Data([3:406],5);
MeanZetaPotential=1000*Data(1,1);
StandardDeviation=1000*Data(2,1);

for i=1:1:size(RelativeFrequency,1)
    if RelativeFrequency(i)>0
        a1=ZetaPotential(i-1);
    break;end
end
for i=size(RelativeFrequency,1):-1:1
    if RelativeFrequency(i)>0
        a2=ZetaPotential(i+1);
    break;end
end

xlimit=[a1 a2];

plot(ZetaPotential,RelativeFrequency,'r-','LineWidth',1.0);
ylim([-max(RelativeFrequency)/40 max(RelativeFrequency)*1.025]); 
title(strcat(sprintf('%g ',round(MeanZetaPotential,1)),' mV \pm ',sprintf(' %g',round(StandardDeviation,1))));
xlim(xlimit);
xlabel('Zeta Potential / mV');
ylabel({'Relative Frequency / %'});

set(gca,'LineWidth',1.0,'TickLength',[0.02 0])
set(gca, 'TickDir', 'out');
set(gca, 'box', 'off')
set(gca, 'color', 'white');

mean=sum(ZetaPotential.*RelativeFrequency)/sum(RelativeFrequency)
stdev=[];
for i=1:1:size(RelativeFrequency,1);
    stdev1=((ZetaPotential(i)-mean)^2)*RelativeFrequency(i);
    stdev=[stdev;stdev1];
end
stdev2=(sum(stdev)/sum(RelativeFrequency))^.5