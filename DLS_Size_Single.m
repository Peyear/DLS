clc;close all;clear all;
File_Location='G:\DLS';
File_name='20180620 DOPC_DEPC new';
Font_Size=12;
Logscale=1; %Logscale Select 1=Yes 0=No
Type=3; %1 for Intensity
        %2 for Volume
        %3 for Number
        
cd(File_Location);
Data=xlsread(File_name);

hDiameter=Data(1,1);
polyIndex=Data(2,1);
diffCoeff=Data(21,1);

ParticleDiameter=(Data([3:144],4));
IntensityWeighted=Data([3:144],5);
VolumeWeighted=Data([3:144],6);
NumberWeighted=Data([3:144],7);

if Type==1
    Y_label='Intensity Weighted';
    Data=[IntensityWeighted,ParticleDiameter];
elseif Type==2
	Y_label='Volume Weighted';
    Data=[VolumeWeighted,ParticleDiameter];
elseif Type==3
	Y_label='Number Weighted';
    Data=[NumberWeighted,ParticleDiameter];
end

for i=1:1:size(Data,1)
    if Data(i,1)>0
        a1=Data(i,2);
    break;end
end
for i=size(Data,1):-1:1
    if Data(i,1)>0
        a2=Data(i,2);
    break;end
end

y=Data(1:size(Data,1),1);
x=Data(1:size(Data,1),2);

xlimit=[a1*.85 a2*1.15];
ylimit=[0 max(y)*1.15];

peaks=[];
for i=2:1:size(y)-1
    if y(i)-y(i-1)>0
        if y(i)-y(i+1)>0
            peaks=[peaks;x(i)];
        end
    end
end
peaks=round(peaks*10)/10;

figure(1);subplot(16,16,[17:128]);plot(x,y);
if Logscale==1
    set(gca, 'XScale', 'log')
end
set(gca, 'TickDir', 'out');
set(gca,'LineWidth',1.0,'TickLength',[0.015 0]);
set(gca, 'box', 'off');
set(gca,'FontSize',Font_Size*.666);
legend('off');
xlim(xlimit);ylim(ylimit);

if size(peaks,1)==1
    title({sprintf('Hydrodynamic diameter = %g nm',hDiameter),sprintf('Polydispersity index = %g %%',polyIndex),sprintf('Diffusion coefficient = %g \\mum^2 / s',diffCoeff),sprintf('Peak 1 = %g',peaks([1:1],1))},'FontSize',Font_Size);
elseif  size(peaks,1)==2
	title({sprintf('Hydrodynamic diameter = %g nm',hDiameter),sprintf('Polydispersity index = %g %%',polyIndex),sprintf('Diffusion coefficient = %g \\mum^2 / s',diffCoeff),sprintf('Peak 1 = %g Peak 2 = %g',peaks([1:2],1))},'FontSize',Font_Size);
elseif  size(peaks,1)==3
	title({sprintf('Hydrodynamic diameter = %g nm',hDiameter),sprintf('Polydispersity index = %g %%',polyIndex),sprintf('Diffusion coefficient = %g \\mum^2 / s',diffCoeff),sprintf('Peak 1 = %g Peak 2 = %g Peak 3 = %g',peaks([1:3],1))},'FontSize',Font_Size);
elseif  size(peaks,1)==4
	title({sprintf('Hydrodynamic diameter = %g nm',hDiameter),sprintf('Polydispersity index = %g %%',polyIndex),sprintf('Diffusion coefficient = %g \\mum^2 / s',diffCoeff),sprintf('Peak 1 = %g Peak 2 = %g Peak 3 = %g Peak 4 = %g',peaks([1:4],1))},'FontSize',Font_Size);
elseif  size(peaks,1)==5
	title({sprintf('Hydrodynamic diameter = %g nm',hDiameter),sprintf('Polydispersity index = %g %%',polyIndex),sprintf('Diffusion coefficient = %g \\mum^2 / s',diffCoeff),sprintf('Peak 1 = %g Peak 2 = %g Peak 3 = %g Peak 4 = %g Peak 5 = %g',peaks([1:5],1))},'FontSize',Font_Size);
end

xlabel('Particle diameter (nm)','FontSize',Font_Size);
ylabel({'Relative frequency',Y_label},'FontSize',Font_Size);
if Logscale==1
    set(gca, 'XScale', 'log')
end

y2=[];
for i=1:1:size(y)
    y2=[y2;sum(y(1:i))];
end
figure(1);subplot(2,3,[4,5]);plot(x,y2);
if Logscale==1
    set(gca, 'XScale', 'log')
end
set(gca, 'TickDir', 'out');
set(gca,'LineWidth',1.0,'TickLength',[0.015 0]);
set(gca, 'box', 'off');
set(gca,'FontSize',Font_Size*.666);
legend('off');
xlim(xlimit);ylim([-10 110])
xlabel('Particle diameter (nm)','FontSize',Font_Size);
ylabel({'Under Size','Distribution (%)'},'FontSize',Font_Size);

y3=y2;
for i=1:1:size(y3,1)
    y3(i)=y3(i)+i*(10^-13);
end
Data=[
99 interp1(y3,x,99);
97.5 interp1(y3,x,97.5);
84 interp1(y3,x,84);
75 interp1(y3,x,75);
62.5 interp1(y3,x,62.5);
50 interp1(y3,x,50);
37.5 interp1(y3,x,37.5);
25 interp1(y3,x,25.0);
16 interp1(y3,x,16);
2.5 interp1(y3,x,2.5);
1 interp1(y3,x,1);
];


f = figure(1);
uit = uitable(f,'Data',Data,'Position',[463,78,152,222]);
uit.ColumnName = {'%','nm',};
uit.RowName = {};

set(figure(1), 'color', 'white');
set(figure(1), 'OuterPosition', [100,100,700,800]);
saveas(figure(1),sprintf('%s',File_name),'pdf');
