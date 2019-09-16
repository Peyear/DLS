clc;close all;clear all;
Font_Size=12;
Logscale=1; %Logscale Select 1=Yes 0=No
Type=1; %1 for Intensity
        %2 for Volume
        %3 for Number
        
j = 1;
AllSamples{j}.File_name      = '20180620 DOPC_DOPC + 5% EtOH 62818'; 
AllSamples{j}.File_Location  = 'G:\DLS';
AllSamples{j}.Sample_name    = '5% EtOH'; 
j = 2;
AllSamples{j}.File_name      = '20180620 DOPC_DOPC + 30 uM Triton 62818'; 
AllSamples{j}.File_Location  = 'G:\DLS';
AllSamples{j}.Sample_name    = '30 \muM Triton';
j = 3;
AllSamples{j}.File_name      = '20180620 DOPC_DOPC + 100 uM Capsaicin 62818'; 
AllSamples{j}.File_Location  = 'G:\DLS';
AllSamples{j}.Sample_name    = '100 \muM Capsaicin';
j = 4;
AllSamples{j}.File_name      = '20180525 HFIP_Triton 700uM 2'; 
AllSamples{j}.File_Location  = 'G:\DLS';
AllSamples{j}.Sample_name    = '700 \muM Triton';

legendpeak={' '};
legendinfo={' '};
for A=10000:-1:1;
    try 
        AllSamples{j}.File_name;
        A=j;
    break;end
end

for i=1:A
cd(AllSamples{i}.File_Location);
Data=xlsread(AllSamples{i}.File_name);

hDiameter=round(10*Data(1,1))/10;
polyIndex=round(10*Data(2,1))/10;
diffCoeff=round(10*Data(21,1))/10;

ParticleDiameter=(Data([3:144],4));
IntensityWeighted=Data([3:144],5);
VolumeWeighted=Data([3:144],6);
NumberWeighted=Data([3:144],7);

if Type==1
    Y_label='Intensity Weighted';
    for k=2:1:10^5
        if IntensityWeighted(2)==0
            ParticleDiameter(1)=[];
            IntensityWeighted(1)=[];
        else
            break
        end
    end
    for k=size(IntensityWeighted,1)-1:-1:1
        if IntensityWeighted(k)==0
            ParticleDiameter(k+1)=[];
            IntensityWeighted(k+1)=[];
        else
            break
        end
    end
    Data=[IntensityWeighted,ParticleDiameter];
elseif Type==2
	Y_label='Volume Weighted';
    Data=[VolumeWeighted,ParticleDiameter];
elseif Type==3
	Y_label='Number Weighted';
    Data=[NumberWeighted,ParticleDiameter];
end

y=Data(1:size(Data,1),1);
x=Data(1:size(Data,1),2);

peaks=[];
for k=2:1:size(y)-1
    if y(k)-y(k-1)>0
        if y(k)-y(k+1)>0
            peaks=[peaks;x(k)];
        end
    end
end
peaks=round(peaks*10)/10;

legendb=char(AllSamples{i}.Sample_name);
legenda=strcat(legendb,sprintf(' D = %g nm',hDiameter),sprintf(' PDI = %g %%',polyIndex),sprintf(' D = %g \\mum^2 / s',diffCoeff));
legendinfo=cat(1,legendinfo,legenda);

if size(peaks,1)==1
    legenda=sprintf('Peak 1 = %g',peaks([1:1],1));
    legendpeak=cat(1,legendpeak,legenda);
elseif  size(peaks,1)==2
    legenda=sprintf('Peak 1 = %g Peak 2 = %g',peaks([1:2],1));
    legendpeak=cat(1,legendpeak,legenda);
elseif  size(peaks,1)==3
    legenda=sprintf('Peak 1 = %g Peak 2 = %g Peak 3 = %g',peaks([1:3],1));
    legendpeak=cat(1,legendpeak,legenda);
elseif  size(peaks,1)==4
    legenda=sprintf('Peak 1 = %g Peak 2 = %g Peak 3 = %g Peak 4 = %g',peaks([1:4],1));
    legendpeak=cat(1,legendpeak,legenda);
elseif  size(peaks,1)==5
    legenda=sprintf('Peak 1 = %g Peak 2 = %g Peak 3 = %g Peak 4 = %g Peak 5 = %g',peaks([1:5],1));
    legendpeak=cat(1,legendpeak,legenda);
end

figure(1);subplot(2,1,1);plot(x,y);hold on
if Logscale==1
    set(gca, 'XScale', 'log')
end
set(gca, 'TickDir', 'out');
set(gca,'LineWidth',1.0,'TickLength',[0.015 0]);
set(gca, 'box', 'off');
set(gca,'FontSize',Font_Size*.666);
legend(legendpeak(2:end),'Location','northeastoutside')
xlabel('Particle diameter (nm)','FontSize',Font_Size);
ylabel({'Relative frequency',Y_label},'FontSize',Font_Size);

y2=[];
for k=1:1:size(y)
    y2=[y2;sum(y(1:k))];
end
figure(1);subplot(2,1,2);plot(x,y2);hold on
if Logscale==1
    set(gca, 'XScale', 'log')
end
set(gca, 'TickDir', 'out');
set(gca,'LineWidth',1.0,'TickLength',[0.015 0]);
set(gca, 'box', 'off');
set(gca,'FontSize',Font_Size*.666);
ylim([-5 105]);
legend(legendinfo(2:end),'Location','southoutside')
xlabel('Particle diameter (nm)','FontSize',Font_Size);
ylabel({'Under Size','Distribution (%)'},'FontSize',Font_Size);

end
set(gca,'LineWidth',1.0,'TickLength',[0.02 0])
set(gca, 'TickDir', 'out');
set(gca, 'box', 'off')
set(gca, 'color', 'white');
set(figure(1), 'color', 'white');
set(figure(1), 'OuterPosition', [10,10,700,900]);
saveas(figure(1), AllSamples{i}.File_name, 'pdf');