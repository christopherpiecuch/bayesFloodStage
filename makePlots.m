% makePlots.m
% this is the code i used used to generate the plots
clear all, close all, clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data
load maindata
clear clrbr
load clr0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% swap ordering of pacific and caribbean locations for figures
% (ordering of regions in figures 1, 2, and 5 is distinct from sweet et al.
% 2022 task team report)
% sort
reg(reg==1)=999;
reg(reg==9)=1;
reg(reg==999)=9;
[reg,sortind]=sort(reg);
% swap
bay=bay(:,sortind);
gt=gt(sortind);
id=id(sortind);
lat=lat(sortind);
lon=lon(sortind);
mhhw=mhhw(sortind);
name=name(sortind);
nos=nos(sortind);
numday=numday(sortind,:);
nws=nws(sortind);
nxdbay=nxdbay(:,sortind,:);
nxdnos=nxdnos(sortind,:);
nxdnws=nxdnws(sortind,:);
myreg{1}='Caribbean';
myreg{9}='Pacific';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if either nos or nws thresholds give nan values, make sure both do
for kk=1:numel(lon)
 if isnan(nos(kk))
  nxdnos(kk,:)=nan;
 end
 if isnan(nws(kk))
  nxdnws(kk,:)=nan;
 end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% print out table s1
clc
for kk=1:numel(nos)
 l1=num2str(1e-1*round(1e1*lat(kk)));
 l2=num2str(1e-1*round(1e1*mod(lon(kk),360)));
 b1=num2str(1e-2*round(1e2*median(bay(:,kk))));
 b2=num2str(1e-2*round(1e2*prctile(bay(:,kk),5)));
 b3=num2str(1e-2*round(1e2*prctile(bay(:,kk),95)));
 sp=[];
 sp=[char(name(kk)),' & ',char(myreg(reg(kk))),' & ',num2str(id(kk)),' & $',l1,'$ & $',l2,'$ & $',num2str(nws(kk)),'$ & $',num2str(nos(kk)),'$ & $',b1,' \\ [',b2,' , ',b3,']$'];
 fprintf([sp,' \\\\ \r'])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 1 map
pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1.25;
fig.Position(4) = fig.Position(4)*1.25;
geoshow(land,'facecolor',[0.9 0.9 0.9],'edgecolor','none')
hold on, grid on
geoshow(land2,'facecolor',[0.9 0.9 0.9],'edgecolor','none')
axis([140 320 -20 80])
scatter(mod(lon,360),lat,25,reg,'filled')
colormap(turbo(9));
set(gca,'Layer','top')
set(gca,'xtick',140:20:320,'xticklabel',[{'140^\circE'};{'160^\circE'};{'180^\circE'};{'200^\circE'};{'220^\circE'};{'240^\circE'};{'260^\circE'};{'280^\circE'};{'300^\circE'};{'320^\circE'}],'ytick',-20:20:80,'yticklabel',[{'20^\circS'};{'0^\circ'};{'20^\circN'};{'40^\circN'};{'60^\circN'};{'80^\circN'}])
cc=colorbar('location','eastoutside');
set(cc,'ytick',1:9,'yticklabel',myreg)
caxis([0.5 9.5]);
for kk=19:21:numel(lat)
scatter(mod(lon(kk),360),lat(kk),25,1,'markerfacecolor','none','markeredgecolor','k')
 if kk<=100
  if kk==19
   text(mod(lon(kk),360)+5,lat(kk)+1,char(name(kk)),'HorizontalAlignment','left')
  elseif kk==61
   text(mod(lon(kk),360)+5,lat(kk)-1,char(name(kk)),'HorizontalAlignment','left')
  else
   text(mod(lon(kk),360)+5,lat(kk),char(name(kk)),'HorizontalAlignment','left')
  end
 else
  text(mod(lon(kk),360)-1,lat(kk),char(name(kk)),'HorizontalAlignment','right')
 end
end
% draw arrows
CLR=turbo(9); 
CLR=CLR([1 1 2 3 5 6 8 8 8 9 9],:);
POS(1,:)=[300,15,15,0];
POS(2,:)=[315,15,0,35];
POS(3,:)=[315,50,-30,0];
POS(4,:)=[285,50,-10,-17.5];
POS(5,:)=[275,32.5,-30,0];
POS(6,:)=[245,32.5,-5,20];
POS(7,:)=[240,52.5,-15,10];
POS(8,:)=[225,62.5,-25,0];
POS(9,:)=[200,62.5,10,5];
POS(10,:)=[210,57.5,0,-30];
POS(11,:)=[210,27.5,-40,-10];
for zz=1:11
 anArrow=annotation('arrow') ;
 anArrow.Parent=gca;  
 anArrow.Position=POS(zz,:);
 anArrow.Color=CLR(zz,:);
 anArrow.LineWidth=2;
end
plot([210 210],[67.5 64.5],'color',CLR(10,:),'linewidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 2
clrbasic=turbo(9);
pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*2;

subplot(8,1,1:2)
 hold on
 % for legend
 for kk=1:numel(myreg)
  scatter(100,100,25,kk,'filled','markerfacecolor',clrbasic(kk,:),'markeredgecolor','none'),
 end
 for kk=1:numel(lat)
  scatter(kk,nws(kk),25,1,'filled','Markeredgecolor',clrbasic(reg(kk),:),'MarkerFaceColor','none','linewidth',1)
  scatter(kk,nos(kk),25,1,'filled','Markeredgecolor','k','MarkerFaceColor',clrbasic(reg(kk),:))
 end
 legend(char(myreg),'numcolumns',3,'location','northwest')
 axis([0 188 0 3])
 set(gca,'xtick',19:21:187,'xticklabel',[],'ytick',0:3), legend boxoff
 title('a. NWS and NOS minor high-tide flooding thresholds (m MHHW)','fontsize',12,'fontweight','normal')
 ylabel('Threshold (m MHHW)','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')

subplot(8,1,3:4)
 hold on
 plot([0 188],[0 0],'k--')
 for kk=1:numel(lat)
  scatter(kk,nws(kk)-nos(kk),25,1,'filled','Markeredgecolor',clrbasic(reg(kk),:),'MarkerFaceColor',clrbasic(reg(kk),:),'linewidth',1)
 end
 axis([0 188 -0.5 1])
 text(175,0.25,[{'NWS higher'};{'threshold'}],'color','k','fontsize',10,'HorizontalAlignment','center')
 text(175,-0.25,[{'NOS higher'};{'threshold'}],'color','k','fontsize',10,'HorizontalAlignment','center')
 set(gca,'xtick',19:21:187,'xticklabel',[],'ytick',-0.5:0.5:1)
 title('b. Difference between NWS and NOS thresholds (m)','fontsize',12,'fontweight','normal')
 ylabel('Difference (m)','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')

 uyr=1990:2023;
 i1=find(uyr>=1990&uyr<=2000);
 i2=find(uyr>=2010&uyr<=2020);
 subplot(8,1,5:6)
 hold on
 hold on
 % for legend
 for kk=1:1
  scatter(100,100,25,1,'filled','Markeredgecolor',clrbasic(reg(kk),:),'MarkerFaceColor','none','linewidth',1)
  scatter(100,100,25,1,'filled','Markeredgecolor','k','MarkerFaceColor',clrbasic(reg(kk),:))
 end
 for kk=1:numel(lat)
  scatter(kk,mean(nxdnws(kk,i2)),25,1,'filled','Markeredgecolor',clrbasic(reg(kk),:),'MarkerFaceColor','none','linewidth',1)
  scatter(kk,mean(nxdnos(kk,i2)),25,1,'filled','Markeredgecolor','k','MarkerFaceColor',clrbasic(reg(kk),:))
 end
 axis([0 188 0 60])
 set(gca,'xtick',19:21:187,'xticklabel',[],'ytick',0:20:60)
 title('c. NWS and NOS average annual flood days 2010-2020','fontsize',12,'fontweight','normal')
 ylabel('Days','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 legend([{'NWS'};{'NOS'}],'location','northwest','orientation','vertical'), legend boxoff

subplot(8,1,7:8)
 hold on
 plot([0 188],[0 0],'k--')
 for kk=1:numel(lat)
  scatter(kk,mean(nxdnws(kk,i2))-mean(nxdnos(kk,i2)),25,1,'filled','Markeredgecolor',clrbasic(reg(kk),:),'MarkerFaceColor',clrbasic(reg(kk),:),'linewidth',1)
 end
 axis([0 188 -20 40])
 set(gca,'xtick',19:21:187,'xticklabel',char(name(19:21:187)),'ytick',-20:20:40)
 text(175,10,[{'NWS gives'};{'more floods'}],'color','k','fontsize',10,'HorizontalAlignment','center')
 text(175,-10,[{'NOS gives'};{'more floods'}],'color','k','fontsize',10,'HorizontalAlignment','center')

 title('d. Difference between NWS and NOS flood days 2010-2020','fontsize',12,'fontweight','normal')
 ylabel('Difference (Days)','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 xtickangle(10)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 3
pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*0.5;

subplot(1,2,1)
 histogram(nws,0:0.1:4,'Normalization','probability','FaceAlpha',0.8,'edgecolor','none') 
 hold on
 histogram(nos,0:0.1:4,'Normalization','probability','FaceAlpha',0.6,'edgecolor','none') 
 axis([0 4 0 0.2])
 legend([{'NWS'};{'NOS'}],'location','northeast'), legend boxoff
 grid on, box on, hold on
 set(gca,'fontsize',12,'fontweight','normal','xtick',-2:4,'ytick',0:0.05:0.2)
 xlabel('Threshold (m MHHW)','fontsize',12,'fontweight','normal')
 ylabel('Probability','fontsize',12,'fontweight','normal')
 title('a.','fontsize',12,'fontweight','normal')

subplot(1,2,2)
 histogram(log(nws),-2:0.1:2,'Normalization','probability','FaceAlpha',0.8,'edgecolor','none') 
 hold on
 histogram(log(nos),-2:0.1:2,'Normalization','probability','FaceAlpha',0.6,'edgecolor','none') 
 axis([-2 2 0 0.2])
 grid on, box on, hold on
 set(gca,'fontsize',12,'fontweight','normal','xtick',-2:4,'ytick',0:0.05:0.2)
 xlabel('Log [Threshold (m MHHW)]','fontsize',12,'fontweight','normal')
 ylabel('Probability','fontsize',12,'fontweight','normal')
 title('b.','fontsize',12,'fontweight','normal')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 4
% compute statistics
idkw=8724580; % noaa id for key west
[kw,dn]=noaaSealevel(idkw,1990,2023);
kw=max(reshape(kw,24,numel(kw)/24));
dn=max(reshape(dn,24,numel(dn)/24));
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
kw(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
uyr=unique(yr);
for kk=1:numel(uyr)
 kwnos(kk)=sum(kw(find(yr==uyr(kk)))>nos(find(id==idkw)));
 kwnws(kk)=sum(kw(find(yr==uyr(kk)))>nws(find(id==idkw)));
end
load clr0.mat

pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*1.5;

subplot(6,1,1:2)
 axis([1990 2022.5 -1 1.5])
 hold on
 plot([1990 2024],nws(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(1,:)])
 plot([1990 2024],nos(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(2,:)])
 ii=find(kw>nws(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markerfacecolor',[clr0(1,:)])
 ii=find(kw>nos(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markeredgecolor',[clr0(2,:)],'markerfacecolor','none')
 plot(decyear(dn),kw,'k')
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'xticklabel',[],'ytick',-1:0.5:1.5)
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('a. Key West water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 legend([{'NWS threshold'};{'NOS threshold'};{'Flood (NWS threshold)'};{'Flood (NOS threshold)'};{'Daily maximum water level'}],'location','southwest','orientation','vertical','numcolumns',3)
 legend boxoff

subplot(6,1,3)
 bb=bar(uyr,[kwnws],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(1,:))
 hold on
 bb=bar(uyr,[kwnos],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(2,:))
 hold on
 box off
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'ytick',0:10:20,'xticklabel',[])
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('b. Key West flood days','fontsize',12,'fontweight','normal')
 legend([{'Flood days (NWS)'};{'Flood days (NOS)'}],'location','northwest','orientation','horizontal'), legend boxoff
 axis([1990 2022.5 0 20])
 set(gca,'Layer','top')

% compute statistics
idkw=8447930; % noaa id for woods hole
[kw,dn]=noaaSealevel(idkw,1990,2023);
kw=max(reshape(kw,24,numel(kw)/24));
dn=max(reshape(dn,24,numel(dn)/24));
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
kw(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
uyr=unique(yr);
for kk=1:numel(uyr)
 kwnos(kk)=sum(kw(find(yr==uyr(kk)))>nos(find(id==idkw)));
 kwnws(kk)=sum(kw(find(yr==uyr(kk)))>nws(find(id==idkw)));
end

subplot(6,1,4:5)
 axis([1990 2022.5 -1 1.5])
 hold on
 plot([1990 2024],nws(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(1,:)])
 plot([1990 2024],nos(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(2,:)])
 ii=find(kw>nws(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markerfacecolor',[clr0(1,:)])
 ii=find(kw>nos(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markeredgecolor',[clr0(2,:)],'markerfacecolor','none')
 plot(decyear(dn),kw,'k')
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'xticklabel',[],'ytick',-1:0.5:1.5)
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('c. Woods Hole water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')

subplot(6,1,6)
 bb=bar(uyr,[kwnos],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(2,:))
 hold on
 bb=bar(uyr,[kwnws],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(1,:))
 hold on
 box off
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'ytick',0:5:10)
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('d. Woods Hole flood days','fontsize',12,'fontweight','normal')
 axis([1990 2022.5 0 10])
 set(gca,'Layer','top')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure s1
% compute statistics
idkw=8723970;  % noaa id for vaca key
[kw,dn]=noaaSealevel(idkw,1990,2023);
kw=max(reshape(kw,24,numel(kw)/24));
dn=max(reshape(dn,24,numel(dn)/24));
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
kw(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
uyr=unique(yr);
for kk=1:numel(uyr)
 kwnos(kk)=sum(kw(find(yr==uyr(kk)))>nos(find(id==idkw)));
 kwnws(kk)=sum(kw(find(yr==uyr(kk)))>nws(find(id==idkw)));
end
load clr0.mat
pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*1.5;

subplot(6,1,1:2)
 axis([1990 2022.5 -1 1.5])
 hold on
 plot([1990 2024],nws(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(1,:)])
 plot([1990 2024],nos(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(2,:)])
 ii=find(kw>nws(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markerfacecolor',[clr0(1,:)])
 ii=find(kw>nos(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markeredgecolor',[clr0(2,:)],'markerfacecolor','none')
 plot(decyear(dn),kw,'k')
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'xticklabel',[],'ytick',-1:0.5:1.5)
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('a. Vaca Key water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 legend([{'NWS threshold'};{'NOS threshold'};{'Flood (NWS threshold)'};{'Flood (NOS threshold)'};{'Daily maximum water level'}],'location','southwest','orientation','vertical','numcolumns',3)
 legend boxoff

subplot(6,1,3)
 bb=bar(uyr,[kwnws],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(1,:))
 hold on
 bb=bar(uyr,[kwnos],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(2,:))
 hold on
 box off
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'ytick',0:20:40,'xticklabel',[])
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('b. Vaca Key flood days','fontsize',12,'fontweight','normal')
 legend([{'Flood days (NWS)'};{'Flood days (NOS)'}],'location','northwest','orientation','horizontal'), legend boxoff
 axis([1990 2022.5 0 40])
 set(gca,'Layer','top')

% compute statistics
idkw=8723214;  % noaa id for virginia key
[kw,dn]=noaaSealevel(idkw,1990,2023);
kw=max(reshape(kw,24,numel(kw)/24));
dn=max(reshape(dn,24,numel(dn)/24));
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
kw(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
uyr=unique(yr);
for kk=1:numel(uyr)
 kwnos(kk)=sum(kw(find(yr==uyr(kk)))>nos(find(id==idkw)));
 kwnws(kk)=sum(kw(find(yr==uyr(kk)))>nws(find(id==idkw)));
end

subplot(6,1,4:5)
 axis([1990 2022.5 -1 1.5])
 hold on
 plot([1990 2024],nws(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(1,:)])
 plot([1990 2024],nos(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(2,:)])
 ii=find(kw>nws(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markerfacecolor',[clr0(1,:)])
 ii=find(kw>nos(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markeredgecolor',[clr0(2,:)],'markerfacecolor','none')
 plot(decyear(dn),kw,'k')
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'xticklabel',[],'ytick',-1:0.5:1.5)
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('c. Virginia Key water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')

subplot(6,1,6)
 bb=bar(uyr,[kwnws],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(1,:))
 hold on
 bb=bar(uyr,[kwnos],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(2,:))
 hold on
 box off
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'ytick',0:20:40)
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('d. Virginia Key flood days','fontsize',12,'fontweight','normal')
 axis([1990 2022.5 0 40])
 set(gca,'Layer','top')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure s2
% compute statistics
idkw=8443970;  % noaa id for boston
[kw,dn]=noaaSealevel(idkw,1990,2023);
kw=max(reshape(kw,24,numel(kw)/24));
dn=max(reshape(dn,24,numel(dn)/24));
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
kw(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
uyr=unique(yr);
for kk=1:numel(uyr)
 kwnos(kk)=sum(kw(find(yr==uyr(kk)))>nos(find(id==idkw)));
 kwnws(kk)=sum(kw(find(yr==uyr(kk)))>nws(find(id==idkw)));
end
load clr0.mat
pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*1.5;

subplot(6,1,1:2)
 axis([1990 2022.5 -1.5 1.5])
 hold on
 plot([1990 2024],nws(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(1,:)])
 plot([1990 2024],nos(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(2,:)])
 ii=find(kw>nws(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markerfacecolor',[clr0(1,:)])
 ii=find(kw>nos(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markeredgecolor',[clr0(2,:)],'markerfacecolor','none')
 plot(decyear(dn),kw,'k')
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'xticklabel',[],'ytick',-1.5:0.5:1.5)
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('a. Boston water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 legend([{'NWS threshold'};{'NOS threshold'};{'Flood (NWS threshold)'};{'Flood (NOS threshold)'};{'Daily maximum water level'}],'location','southwest','orientation','vertical','numcolumns',3)
 legend boxoff

subplot(6,1,3)
 bb=bar(uyr,[kwnos],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(2,:))
 hold on
 bb=bar(uyr,[kwnws],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(1,:))
 hold on
 box off
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'ytick',0:10:20,'xticklabel',[])
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('b. Boston flood days','fontsize',12,'fontweight','normal')
 legend([{'Flood days (NOS)'};{'Flood days (NWS)'}],'location','northwest','orientation','horizontal'), legend boxoff
 axis([1990 2022.5 0 20])
 set(gca,'Layer','top')

idkw=8418150;  % noaa id for portland (me)
[kw,dn]=noaaSealevel(idkw,1990,2023);
kw=max(reshape(kw,24,numel(kw)/24));
dn=max(reshape(dn,24,numel(dn)/24));
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
kw(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
uyr=unique(yr);
for kk=1:numel(uyr)
 kwnos(kk)=sum(kw(find(yr==uyr(kk)))>nos(find(id==idkw)));
 kwnws(kk)=sum(kw(find(yr==uyr(kk)))>nws(find(id==idkw)));
end
load clr0.mat

subplot(6,1,4:5)
 axis([1990 2022.5 -1.5 1.5])
 hold on
 plot([1990 2024],nws(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(1,:)])
 plot([1990 2024],nos(find(id==idkw))*[1 1],'--','linewidth',2,'color',[clr0(2,:)])
 ii=find(kw>nws(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markerfacecolor',[clr0(1,:)])
 ii=find(kw>nos(find(id==idkw)));
 scatter(decyear(dn(ii)),kw(ii),25,ones(size(dn(ii))),'filled','markeredgecolor',[clr0(2,:)],'markerfacecolor','none')
 plot(decyear(dn),kw,'k')
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'xticklabel',[],'ytick',-1.5:0.5:1.5)
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('c. Portland water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')

subplot(6,1,6)
 bb=bar(uyr,[kwnos],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(2,:))
 hold on
 bb=bar(uyr,[kwnws],'EdgeColor','none','barwidth',0.95);
 set(bb,'FaceColor',clr0(1,:))
 hold on
 box off
 set(gca,'fontsize',12,'fontweight','normal','xtick',1990:5:2020,'ytick',0:10:20)
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('d. Portland flood days','fontsize',12,'fontweight','normal')
 axis([1990 2022.5 0 20])
 set(gca,'Layer','top')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 5
pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*2;
prpr=[95 75 50 50 25 5];
prcl=[2 3 4 3 2 1];

subplot(8,1,1:2)
 hold on
 % for legend
 for kk=1:numel(myreg)
  scatter(100,100,25,kk,'filled','markerfacecolor',clrbasic(kk,:),'markeredgecolor','none'),
 end
 for kk=1:numel(lat)
  clrpx=[clrbasic(reg(kk),:)*.2+[.8 .8 .8]; clrbasic(reg(kk),:)*.5+[.5 .5 .5]; clrbasic(reg(kk),:)];
  % 5-95
  pp=[prctile(bay(:,kk),prpr(1)) prctile(bay(:,kk),prpr(6))];
  xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
  yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
  c=fill(xx,yy,clrpx(1,:),'edgecolor','none');
  % 25-75
  pp=[prctile(bay(:,kk),prpr(2)) prctile(bay(:,kk),prpr(5))];
  xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
  yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
  c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
  % 50
  xx=[kk-0.5 kk+0.5];
  yy=prctile(bay(:,kk),prpr(3))*[1 1];
  plot(xx,yy,'color',clrpx(3,:),'linewidth',3)
 end
 for kk=1:numel(lat)
  plot(kk,nos(kk),'k.','markersize',5) 
  end
 axis([0 188 0 3])
 set(gca,'xtick',19:21:187,'xticklabel',[],'ytick',0:3)
 title('a. Bayesian model and NOS minor high-tide flooding thresholds (m MHHW)','fontsize',12,'fontweight','normal')
 ylabel('Threshold (m MHHW)','fontsize',12,'fontweight','normal')
 xtickangle(10)
 set(gca,'Layer','top')
 legend(char(myreg),'numcolumns',3,'location','northwest'), legend boxoff

subplot(8,1,3:4)
 hold on
 % for legend
 for kk=1:numel(lat)
  clrpx=[clrbasic(reg(kk),:)*.2+[.8 .8 .8]; clrbasic(reg(kk),:)*.5+[.5 .5 .5]; clrbasic(reg(kk),:)];
  % 5-95
  pp=[prctile(bay(:,kk),prpr(1)) prctile(bay(:,kk),prpr(6))]-nos(kk);
  xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
  yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
  c=fill(xx,yy,clrpx(1,:),'edgecolor','none');
  % 25-75
  pp=[prctile(bay(:,kk),prpr(2)) prctile(bay(:,kk),prpr(5))]-nos(kk);
  xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
  yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
  c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
  % 50
  xx=[kk-0.5 kk+0.5];
  yy=prctile(bay(:,kk),prpr(3))*[1 1]-nos(kk);
  plot(xx,yy,'color',clrpx(3,:),'linewidth',3)
 end
 axis([0 188 -0.5 1])
 set(gca,'xtick',19:21:187,'xticklabel',[],'ytick',-0.5:0.5:1)
 title('b. Difference between Bayesian model and NOS thresholds (m)','fontsize',12,'fontweight','normal')
 ylabel('Difference (m)','fontsize',12,'fontweight','normal')
 plot([0 188],[0 0],'k--')
 legend([{'90% CI'};{'IQR'};{'Median'}],'numcolumns',1,'location','north'), legend boxoff
 set(gca,'Layer','top')

 subplot(8,1,5:6)
 hold on
 for kk=1:numel(lat)
  ll=[]; ll=find(uyr>=2010&uyr<=2020);
  % criterion is at least 8 years with >=330 days of data
  if sum(numday(kk,ll)>330)>=8 
   MM=[]; MM=squeeze(nanmean(nxdbay(:,kk,ll),3));
   clrpx=[clrbasic(reg(kk),:)*.2+[.8 .8 .8]; clrbasic(reg(kk),:)*.5+[.5 .5 .5]; clrbasic(reg(kk),:)];
   % 5-95
   pp=[prctile(MM,prpr(1)) prctile(MM,prpr(6))];
   xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(1,:),'edgecolor','none');
   % 25-75
   pp=[prctile(MM,prpr(2)) prctile(MM,prpr(5))];
   xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
   % 50
   xx=[kk-0.5 kk+0.5];
   yy=prctile(MM,prpr(3))*[1 1];
   plot(xx,yy,'color',clrpx(3,:),'linewidth',3)
   plot(kk,nanmean(nxdnos(kk,ll)),'k.','markersize',5) 
  end
 end
 axis([0 188 0 60])
 set(gca,'xtick',19:21:187,'xticklabel',[],'ytick',0:20:60)
 title('c. Bayesian model and NOS average annual flood days 2010-2020','fontsize',12,'fontweight','normal')
 ylabel('Days','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')

 subplot(8,1,7:8)
 hold on
 for kk=1:numel(lat)
  ll=[]; ll=find(uyr>=2010&uyr<=2020);
  % criterion is at least 8 years with >=330 days of data
  if sum(numday(kk,ll)>330)>=8 
   MM=[]; MM=squeeze(nanmean(nxdbay(:,kk,ll),3));
   clrpx=[clrbasic(reg(kk),:)*.2+[.8 .8 .8]; clrbasic(reg(kk),:)*.5+[.5 .5 .5]; clrbasic(reg(kk),:)];
   % 5-95
   pp=[prctile(MM,prpr(1)) prctile(MM,prpr(6))]-nanmean(nxdnos(kk,ll));
   xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(1,:),'edgecolor','none');
   % 25-75
   pp=[prctile(MM,prpr(2)) prctile(MM,prpr(5))]-nanmean(nxdnos(kk,ll));
   xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
   % 50
   xx=[kk-0.5 kk+0.5];
   yy=prctile(MM,prpr(3))*[1 1]-nanmean(nxdnos(kk,ll));
   plot(xx,yy,'color',clrpx(3,:),'linewidth',3)
   %plot(kk,nanmean(nxdnos(kk,ll)),'k.','markersize',5) 
  end
 end
 axis([0 188 -20 40])
 set(gca,'xtick',19:21:187,'xticklabel',[],'ytick',0:20:60)
 set(gca,'xtick',19:21:187,'xticklabel',char(name(19:21:187)),'ytick',-20:20:40)
 title('d. Difference between Bayesian model and NOS flood days 2010-2020','fontsize',12,'fontweight','normal')
 ylabel('Difference (Days)','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 xtickangle(10)
 plot([0 188],[0 0],'k--')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 6
% compute some statistics
% key west
idgi=8724580; % noaa id for key west
[gi,dn]=noaaSealevel(idgi,1990,2023);
gi=max(reshape(gi,24,numel(gi)/24));
dn=max(reshape(dn,24,numel(dn)/24));
uyr=1990:2023;
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
gi(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
kk=find(id==idgi);

px=double(gi>bay(:,kk));
px=mean(px,1);
ii=find(px~=0);

pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*1.5;
clrA=flipud(hot(100));
subplot(6,1,1:2)
 hold on
 clrpx=sky(4);
 clrpx(1,:)=[1 1 1];
 prpr=[95 75 50 50 25 5];
 prcl=[2 3 4 3 2 1];
 plot(decyear(dn),gi,'k')
 scatter(1,1,25,1,'filled','markerfacecolor',clrA(75,:),'MarkerFaceAlpha',0.75,'markeredgecolor','none');
 scatter(1,1,25,1,'filled','markerfacecolor',clrA(50,:),'MarkerFaceAlpha',0.5,'markeredgecolor','none');
 scatter(1,1,25,1,'filled','markerfacecolor',clrA(25,:),'MarkerFaceAlpha',0.25,'markeredgecolor','none');
 % 5-95
 pp=[prctile(bay(:,find(id==idgi)),prpr(1)) prctile(bay(:,find(id==idgi)),prpr(6))];
 xx=[1990 2024 2024 1990 1990];
 yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
 c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
 % 25-75
 pp=[prctile(bay(:,find(id==idgi)),prpr(2)) prctile(bay(:,find(id==idgi)),prpr(5))];
 xx=[1990 2024 2024 1990 1990];
 yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
 c=fill(xx,yy,clrpx(3,:),'edgecolor','none');
 % 50
 xx=[1990 2024];
 yy=prctile(bay(:,find(id==idgi)),prpr(3))*[1 1];
 plot(xx,yy,'color',clrpx(4,:),'linewidth',3)

 plot(decyear(dn),gi,'k')
 for jj=1:numel(ii)
  ss=scatter(decyear(dn(ii(jj))),gi(ii(jj)),25,1,'filled');
  set(ss,'markerfacecolor',clrA(ceil(px(ii(jj))*100),:),'MarkerFaceAlpha',px(ii(jj)),'markeredgecolor','none');
 end
 ccc=colorbar('location','north');
 ddd=get(ccc,'Position');
 ddd(1)=ddd(1)+0.025;
 ddd(3)=0.25*ddd(3);
 set(ccc,'Position',ddd,'xtick',0:50:100,'xticklabel',[{'0%'};{'50%'};{'100%'}])
 colormap(flipud(hot)); caxis([0 100])
 axis([1990 2022.5 -1 1.5])
 set(gca,'fontsize',12,'fontweight','normal','xtick',1995:5:2020,'ytick',-1:0.5:1.5,'xticklabel',[])
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('a. Key West water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 legend([{'Daily maximum water level'};{'P(flood)=75%'};{'P(flood)=50%'};{'P(flood)=25%'}],'location','southwest','orientation','horizontal','numcolumns',2)
 legend boxoff

TT=squeeze(nxdbay(:,find(id==idgi),:));
subplot(6,1,3)
 hold on
 clrpx=sky(4);
 clrpx(1,:)=[1 1 1];
 prpr=[95 75 50 50 25 5];
 prcl=[2 3 4 3 2 1];
 for kk=1:numel(uyr)
   % 5-95
   pp=[prctile(TT(:,kk),prpr(1)) prctile(TT(:,kk),prpr(6))];
   xx=[uyr(kk)-0.5 uyr(kk)+0.5 uyr(kk)+0.5 uyr(kk)-0.5 uyr(kk)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
   % 25-75
   pp=[prctile(TT(:,kk),prpr(2)) prctile(TT(:,kk),prpr(5))];
   xx=[uyr(kk)-0.5 uyr(kk)+0.5 uyr(kk)+0.5 uyr(kk)-0.5 uyr(kk)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(3,:),'edgecolor','none');
   % 50
   xx=[uyr(kk)-0.5 uyr(kk)+0.5];
   yy=prctile(TT(:,kk),prpr(3))*[1 1];
   plot(xx,yy,'color',clrpx(4,:),'linewidth',3)
   plot(uyr(kk),nxdnos(find(id==idgi),kk),'k.','markersize',5)
 end
 axis([1990 2022.5 0 20])
 set(gca,'fontsize',12,'fontweight','normal','xtick',1995:5:2020,'ytick',0:10:20,'xticklabel',[])
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('b. Key West flood days','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
 legend([{'90% CI'};{'IQR'};{'Median'};{'NOS'}],'location','northwest','orientation','horizontal','numcolumns',2), legend boxoff

% woods hole
idgi=8447930;  % noaa id for woods hole
[gi,dn]=noaaSealevel(idgi,1990,2023);
gi=max(reshape(gi,24,numel(gi)/24));
dn=max(reshape(dn,24,numel(dn)/24));
uyr=1990:2023;
yr=str2num(datestr(dn,10));
mo=str2num(datestr(dn,5));
yr(find(mo<=4))=yr(find(mo<=4))-1;
clear mo
dn(find(yr==max(yr)|yr==min(yr)))=[];
gi(find(yr==max(yr)|yr==min(yr)))=[];
yr(find(yr==max(yr)|yr==min(yr)))=[];
kk=find(id==idgi);

px=double(gi>bay(:,kk));
px=mean(px,1);
ii=find(px~=0);

subplot(6,1,4:5)
 hold on
 clrpx=sky(4);
 clrpx(1,:)=[1 1 1];
 prpr=[95 75 50 50 25 5];
 prcl=[2 3 4 3 2 1];
 plot(decyear(dn),gi,'k')
 scatter(1,1,25,1,'filled','markerfacecolor',clrA(75,:),'MarkerFaceAlpha',0.75,'markeredgecolor','none');
 scatter(1,1,25,1,'filled','markerfacecolor',clrA(50,:),'MarkerFaceAlpha',0.5,'markeredgecolor','none');
 scatter(1,1,25,1,'filled','markerfacecolor',clrA(25,:),'MarkerFaceAlpha',0.25,'markeredgecolor','none');
 % 5-95
 pp=[prctile(bay(:,find(id==idgi)),prpr(1)) prctile(bay(:,find(id==idgi)),prpr(6))];
 xx=[1990 2024 2024 1990 1990];
 yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
 c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
 % 25-75
 pp=[prctile(bay(:,find(id==idgi)),prpr(2)) prctile(bay(:,find(id==idgi)),prpr(5))];
 xx=[1990 2024 2024 1990 1990];
 yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
 c=fill(xx,yy,clrpx(3,:),'edgecolor','none');
 % 50
 xx=[1990 2024];
 yy=prctile(bay(:,find(id==idgi)),prpr(3))*[1 1];
 plot(xx,yy,'color',clrpx(4,:),'linewidth',3)

 plot(decyear(dn),gi,'k')
 for jj=1:numel(ii)
  ss=scatter(decyear(dn(ii(jj))),gi(ii(jj)),25,1,'filled');
  set(ss,'markerfacecolor',clrA(ceil(px(ii(jj))*100),:),'MarkerFaceAlpha',px(ii(jj)),'markeredgecolor','none');
 end
 axis([1990 2022.5 -1 1.5])
 set(gca,'fontsize',12,'fontweight','normal','xtick',1995:5:2020,'ytick',-1:0.5:1.5,'xticklabel',[])
 ylabel('Water level (m MHHW)','fontsize',12,'fontweight','normal')
 title('c. Woods Hole water level','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')

TT=squeeze(nxdbay(:,find(id==idgi),:));
subplot(6,1,6)
 hold on
 clrpx=sky(4);
 clrpx(1,:)=[1 1 1];
 prpr=[95 75 50 50 25 5];
 prcl=[2 3 4 3 2 1];
 for kk=1:numel(uyr)
   % 5-95
   pp=[prctile(TT(:,kk),prpr(1)) prctile(TT(:,kk),prpr(6))];
   xx=[uyr(kk)-0.5 uyr(kk)+0.5 uyr(kk)+0.5 uyr(kk)-0.5 uyr(kk)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
   % 25-75
   pp=[prctile(TT(:,kk),prpr(2)) prctile(TT(:,kk),prpr(5))];
   xx=[uyr(kk)-0.5 uyr(kk)+0.5 uyr(kk)+0.5 uyr(kk)-0.5 uyr(kk)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(3,:),'edgecolor','none');
   % 50
   xx=[uyr(kk)-0.5 uyr(kk)+0.5];
   yy=prctile(TT(:,kk),prpr(3))*[1 1];
   plot(xx,yy,'color',clrpx(4,:),'linewidth',3)
   plot(uyr(kk),nxdnos(find(id==idgi),kk),'k.','markersize',5)
 end
 axis([1990 2022.5 0 10])
 set(gca,'fontsize',12,'fontweight','normal','xtick',1995:5:2020,'ytick',0:5:10)
 ylabel('Flood days','fontsize',12,'fontweight','normal')
 title('d. Woods Hole flood days','fontsize',12,'fontweight','normal')
 set(gca,'Layer','top')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 7
 uyr=1990:2023;
 titleletter='abcdefghij';
 SS=nansum(numday,2)/365.25;
 SS=SS';
 clear xxx
 pause(1), fig=figure('color','white');
 fig.Position(3) = fig.Position(3)*1;
 fig.Position(4) = fig.Position(4)*2;
 for kk=1:numel(myreg)
  ii=[]; ii=find(reg==kk&SS>25); % must have >25 years of data
  s=subplot(5,2,kk);
  hold on, 
  XX=[]; XX=squeeze(nanmean(nxdbay(:,ii,1:end-1),2));
  xxx(kk,:,:)=XX;
  YY=[]; YY=nanmean(nxdnos(ii,1:end-1));
  disp(['Times region ',char(myreg(kk)),' increased was P=',num2str(mean(mean(XX(:,21:31),2)./mean(XX(:,1:11),2))),'.'])

  ylabel('Flood days')
  clrpx=sky(4);
  clrpx(1,:)=[1 1 1];
  prpr=[95 75 50 50 25 5];
  prcl=[2 3 4 3 2 1];
  for ll=1:numel(uyr)

   % 5-95
   pp=[prctile(XX(:,ll),prpr(1)) prctile(XX(:,ll),prpr(6))];
   xx=[uyr(ll)-0.5 uyr(ll)+0.5 uyr(ll)+0.5 uyr(ll)-0.5 uyr(ll)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
   % 25-75
   pp=[prctile(XX(:,ll),prpr(2)) prctile(XX(:,ll),prpr(5))];
   xx=[uyr(ll)-0.5 uyr(ll)+0.5 uyr(ll)+0.5 uyr(ll)-0.5 uyr(ll)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(3,:),'edgecolor','none');
   % 50
   xx=[uyr(ll)-0.5 uyr(ll)+0.5];
   yy=prctile(XX(:,ll),prpr(3))*[1 1];
   plot(xx,yy,'color',clrpx(4,:),'linewidth',3)

   plot(uyr(ll),YY(ll),'k.','markersize',5)
  end
 % these are strings to output for table 1
  aaa=num2str(1e-1*round(1e1*mean(YY(1:11))));
  bbb=num2str(1e-1*round(1e1*prctile(mean(XX(:,1:11),2),50)));
  ccc=num2str(1e-1*round(1e1*prctile(mean(XX(:,1:11),2),5)));
  ddd=num2str(1e-1*round(1e1*prctile(mean(XX(:,1:11),2),95)));

  eee=num2str(1e-1*round(1e1*mean(YY(21:31))));
  fff=num2str(1e-1*round(1e1*prctile(mean(XX(:,21:31),2),50)));
  ggg=num2str(1e-1*round(1e1*prctile(mean(XX(:,21:31),2),5)));
  hhh=num2str(1e-1*round(1e1*prctile(mean(XX(:,21:31),2),95)));

  iii=num2str(1e-1*round(1e1*(mean(YY(21:31))-mean(YY(1:11)))));
  jjj=num2str(1e-1*round(1e1*prctile(mean(XX(:,21:31)-XX(:,1:11),2),50)));
  kkk=num2str(1e-1*round(1e1*prctile(mean(XX(:,21:31)-XX(:,1:11),2),5)));
  lll=num2str(1e-1*round(1e1*prctile(mean(XX(:,21:31)-XX(:,1:11),2),95)));
 % print table
  fprintf([char(myreg(kk)),' & ',aaa,' & ',bbb,' (',ccc,'--',ddd,') & ',eee,' & ',fff,' (',ggg,'--',hhh,') & ',iii,' & ',jjj,' (',kkk,'--',lll,') \\\\ \r',])

  axis([1990 2022.5 0 40])
  set(gca,'xtick',1990:5:2020,'ytick',0:10:60)
  if kk==2|kk==4|kk==6|kk==7|kk==8
   axis([1990 2022.5 0 20])
   set(gca,'xtick',1990:5:2020,'ytick',0:5:60)
  end   

  title([titleletter(kk),'. ',char(myreg(kk)),' (n=',num2str(numel(ii)),')'],'fontsize',12,'fontweight','normal')
  plot([1990 2022],[0 0],'k')
  if kk==1
   legend([{'90% CI'};{'IQR'};{'Median'};{'NOS'}],'location','northwest','orientation','vertical')
   legend boxoff
  end
 set(gca,'Layer','top')
 end
 % now do national average
 ii=[]; ii=find(SS>25);
 yyy=squeeze(nanmean(nxdbay(:,ii,1:end-1),2));
 xxx=nanmean(nxdnos(ii,1:end-1));
  s=subplot(5,2,10);
  hold on, 
  ylabel('Flood days')
  clrpx=sky(4);
  clrpx(1,:)=[1 1 1];
  prpr=[95 75 50 50 25 5];
  prcl=[2 3 4 3 2 1];
  for ll=1:numel(uyr)

   % 5-95
   pp=[prctile(yyy(:,ll),prpr(1)) prctile(yyy(:,ll),prpr(6))];
   xx=[uyr(ll)-0.5 uyr(ll)+0.5 uyr(ll)+0.5 uyr(ll)-0.5 uyr(ll)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
   % 25-75
   pp=[prctile(yyy(:,ll),prpr(2)) prctile(yyy(:,ll),prpr(5))];
   xx=[uyr(ll)-0.5 uyr(ll)+0.5 uyr(ll)+0.5 uyr(ll)-0.5 uyr(ll)-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(3,:),'edgecolor','none');
   % 50
   xx=[uyr(ll)-0.5 uyr(ll)+0.5];
   yy=prctile(yyy(:,ll),prpr(3))*[1 1];
   plot(xx,yy,'color',clrpx(4,:),'linewidth',3)

   plot(uyr(ll),xxx(ll),'k.','markersize',5)
  end

 % these are strings to output for table 1
  aaa=num2str(1e-1*round(1e1*mean(xxx(1:11))));
  bbb=num2str(1e-1*round(1e1*prctile(mean(yyy(:,1:11),2),50)));
  ccc=num2str(1e-1*round(1e1*prctile(mean(yyy(:,1:11),2),5)));
  ddd=num2str(1e-1*round(1e1*prctile(mean(yyy(:,1:11),2),95)));

  eee=num2str(1e-1*round(1e1*mean(xxx(21:31))));
  fff=num2str(1e-1*round(1e1*prctile(mean(yyy(:,21:31),2),50)));
  ggg=num2str(1e-1*round(1e1*prctile(mean(yyy(:,21:31),2),5)));
  hhh=num2str(1e-1*round(1e1*prctile(mean(yyy(:,21:31),2),95)));

  iii=num2str(1e-1*round(1e1*(mean(xxx(21:31))-mean(xxx(1:11)))));
  jjj=num2str(1e-1*round(1e1*prctile(mean(yyy(:,21:31)-yyy(:,1:11),2),50)));
  kkk=num2str(1e-1*round(1e1*prctile(mean(yyy(:,21:31)-yyy(:,1:11),2),5)));
  lll=num2str(1e-1*round(1e1*prctile(mean(yyy(:,21:31)-yyy(:,1:11),2),95)));
 % print
  fprintf([char('National'),' & ',aaa,' & ',bbb,' (',ccc,'--',ddd,') & ',eee,' & ',fff,' (',ggg,'--',hhh,') & ',iii,' & ',jjj,' (',kkk,'--',lll,') \\\\ \r',])

  plot(uyr,xxx,'k.','markersize',5)
  axis([1990 2022.5 0 20])
  plot([1990 2023],[0 0],'k')
  set(gca,'xtick',1990:5:2020,'ytick',0:5:20)
  set(gca,'Layer','top')
  title([titleletter(kk+1),'. National average'],'fontsize',12,'fontweight','normal')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure s4
A=exp(log(ones(1000,1)*nws)-log(bay));

load('bayes_model_solutions/experiment_floodstagepaper.mat')
for kk=1:1000
 bnds(kk)=exp(randn(1)*sqrt(EPSILON_2(kk)));
end

pause(1), fig=figure('color','white');
fig.Position(3) = fig.Position(3)*1;
fig.Position(4) = fig.Position(4)*0.5;
prpr=[95 75 50 50 25 5];
prcl=[2 3 4 3 2 1];

 hold on
 for kk=1:numel(myreg)
  scatter(100,100,25,kk,'filled','markerfacecolor',clrbasic(kk,:),'markeredgecolor','none'),
 end

 for kk=1:numel(lat)
  clrpx=[1 1 1; clrbasic(reg(kk),:)*.2+[.8 .8 .8]; clrbasic(reg(kk),:)*.5+[.5 .5 .5]; clrbasic(reg(kk),:)];
   % 5-95
   pp=[prctile(A(:,kk),prpr(1)) prctile(A(:,kk),prpr(6))];
   xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(2,:),'edgecolor','none');
   % 25-75
   pp=[prctile(A(:,kk),prpr(2)) prctile(A(:,kk),prpr(5))];
   xx=[kk-0.5 kk+0.5 kk+0.5 kk-0.5 kk-0.5];
   yy=[pp(1) pp(1) pp(2) pp(2) pp(1)];
   c=fill(xx,yy,clrpx(3,:),'edgecolor','none');
   % 50
   xx=[kk-0.5 kk+0.5];
   yy=prctile(A(:,kk),prpr(3))*[1 1];
   plot(xx,yy,'color',clrpx(4,:),'linewidth',3)

 end
 plot(1:187,prctile(bnds,5)*ones(size(1:187)),'k--')
 plot(1:187,prctile(bnds,95)*ones(size(1:187)),'k--')
 plot(1:187,prctile(bnds,50)*ones(size(1:187)),'k-')

 axis([0 188 0 2])
 set(gca,'xtick',19:21:187,'xticklabel',char(name(19:21:187)),'ytick',0:0.5:2)
 title('Random local multiplicative noise','fontsize',12,'fontweight','normal')
 %ylabel('Threshold (m MHHW)','fontsize',12,'fontweight','normal')
 xtickangle(10)
 set(gca,'Layer','top')
 legend(char(myreg),'numcolumns',3,'location','southwest'), legend boxoff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%