clc;close all;clear all;

j = 1;
AllSamples{j}.File_name      = 'Sara_20190823 45% LUVs - Zeta'; 
AllSamples{j}.File_Location  = 'G:\Stopped Flow Exp\00.Sara\Zeta-DEPS';
AllSamples{j}.Sample_name   = 'Control'; 
j = 2;
AllSamples{j}.File_name      = 'Sara_20190823 10uM Kan 45% LUVs - Zeta'; 
AllSamples{j}.File_Location  = 'G:\Stopped Flow Exp\00.Sara\Zeta-DEPS';
AllSamples{j}.Sample_name   = '10 \muM Kan'; 
j = 3;
AllSamples{j}.File_name      = 'Sara_20190823 100uM Kan 45% LUVs - Zeta'; 
AllSamples{j}.File_Location  = 'G:\Stopped Flow Exp\00.Sara\Zeta-DEPS';
AllSamples{j}.Sample_name   = '100 \muM Kan'; 
j = 4;
AllSamples{j}.File_name      = 'Sara_20190823 300uM Kan 45% LUVs - Zeta'; 
AllSamples{j}.File_Location  = 'G:\Stopped Flow Exp\00.Sara\Zeta-DEPS';
AllSamples{j}.Sample_name   = '300 \muM Kan'; 
j = 5;
AllSamples{j}.File_name      = 'Sara_20190823 1000uM Kan 45% LUVs - Zeta'; 
AllSamples{j}.File_Location  = 'G:\Stopped Flow Exp\00.Sara\Zeta-DEPS';
AllSamples{j}.Sample_name   = '1000 \muM Kan'; 

legendzeta={' '};
for A=10000:-1:1;
    try 
        AllSamples{j}.File_name;
        A=j;
    break;end
end

for i=1:A
cd(char(AllSamples{i}.File_Location));
Data=xlsread(char(AllSamples{i}.File_name));

ZetaPotential=(Data([3:end],4));
RelativeFrequency=Data([3:end],5);
MeanZetaPotential=Data(1,1);
StandardDeviation=Data(2,1);

for k=size(RelativeFrequency,1):-1:1
    if RelativeFrequency(k)==0
        ZetaPotential(k)=[];
        RelativeFrequency(k)=[];
    end
end

figure(1)
plot(ZetaPotential,RelativeFrequency,'-','LineWidth',1.0);hold on
legendb=char(AllSamples{i}.Sample_name);
legenda=strcat(sprintf('%g ',round(MeanZetaPotential,1)),' mV \pm ',sprintf(' %g --',round(StandardDeviation,1)),legendb);
legendzeta=cat(1,legendzeta,legenda);
xlabel('Zeta Potential / mV');
ylabel({'Relative Frequency / %'});
%legend(legendzeta(2:end),'Location','northeastoutside')
legend(legendzeta(2:end),'Location','southoutside')
end
set(gca,'LineWidth',1.0,'TickLength',[0.02 0])
set(gca, 'TickDir', 'out');
set(gca, 'box', 'off')
set(gca, 'color', 'white');
set(figure(1), 'color', 'white');
set(figure(1), 'OuterPosition', [100,100,400,600]);
%saveas(figure(1), legendb, 'pdf');