% generateResults.m
% this is the code i used used to generate the results.
% all the *.mat files saved are included in the download.
% to run the code yourself, remove all "%%%" commenting,
% but note that due to data changes over time (e.g., in nws thresholds)
% you may obtain very slight different results
clear all, close all, clc

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % load task team locations
%%% % this is cut and paste from table a1.3 in the report
%%% % modified by table 1 in kavanaugh
disp('load task team locations')
%%% load('20240602_taskteam_regions.mat')
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % create all-location file for posterior prediction (below)
disp('create all-location file for posterior prediction')
%%% alllat=Lat;
%%% alllon=Lon;
%%% allid=NOAAID';
%%% save('allstations.mat','allid','alllat','alllon')
%%% clear all*
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % get available datum and flood stage information
disp('get available datum and flood stage information')
%%% % initialize
%%% mhhw=nan*Lat;
%%% gt=nan*Lat;
%%% nws_minor=nan*Lat;
%%% nos_minor=Threshold'; % cut and paste from the report
%%% % loop
%%% for kk=1:numel(NOAAID), disp(num2str(kk))
%%%  dt=noaaDatums(NOAAID(kk));
%%%  fl=noaaFlood(NOAAID(kk));
%%%  % get datums
%%%  if isfield(dt,'MHHW')
%%%   	mhhw(kk)=dt.MHHW;
%%%  end
%%%  if isfield(dt,'MLLW')
%%%   	mllw(kk)=dt.MLLW;
%%%  end
%%%  if isfield(dt,'GT')
%%%   	gt(kk)=dt.GT;
%%%  end
%%%  % get flood information
%%%  if isfield(fl,'nws_minor')
%%%   	nws_minor(kk)=fl.nws_minor;
%%%  end
%%% end
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % now save files
disp('now save minor flood stage file')
%%% nws_minor=nws_minor-mhhw;
%%% ii=[]; ii=find(~isnan(nws_minor));
%%% id=NOAAID(ii)';
%%% lat=Lat(ii);
%%% lon=Lon(ii);
%%% nos=nos_minor(ii);
%%% nws=nws_minor(ii);
%%% save('minorfloodstage.mat','id','lat','lon','nos','nws')
%%% clear
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % run bayesian model
disp('run bayesian model')
%%% bayes_main_code
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % do posterior prediction
disp('do posterior prediction')
%%% load('bayes_model_solutions/experiment_floodstagepaper.mat')
%%% load('minorfloodstage.mat')
%%% load('allstations.mat')

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % set up vectors and matrices
%%% reglon=alllon';
%%% reglat=alllat';
%%% ELL_N=abs(lat');
%%% ELL_NN=abs(alllat');
%%% ONE_N=ones(numel(lon),1);
%%% ONE_NN=ones(numel(reglon),1);
%%% DTOT=EarthDistances([[lon reglon']' [lat reglat']']);
%%% Dxx=DTOT(1:numel(lon),1:numel(lon));
%%% Dxsxs=DTOT((numel(lon)+1):end,(numel(lon)+1):end);
%%% Dxxs=DTOT(1:numel(lon),(numel(lon)+1):end);
%%% Dxsx=Dxxs';

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % perform posterior prediction
%%% bay=zeros(numel(ALPHA),numel(reglon));
%%% for nn=1:numel(ALPHA), disp(num2str(nn))
%%%  Kxx=OMEGA_2(nn)*exp(-RHO(nn)*Dxx)+EPSILON_2(nn)*eye(numel(lon));
%%%  Kxsxs=OMEGA_2(nn)*exp(-RHO(nn)*Dxsxs);
%%%  Kxxs=OMEGA_2(nn)*exp(-RHO(nn)*Dxxs);
%%%  Kxsx=OMEGA_2(nn)*exp(-RHO(nn)*Dxsx);

%%%  fstarbar=ALPHA(nn)*ONE_NN+BETA(nn)*ELL_NN+Kxsx*inv(Kxx)*(V(nn,:)'-ALPHA(nn)*ONE_N-BETA(nn)*ELL_N);
%%%  covfstar=Kxsxs-Kxsx*inv(Kxx)*Kxxs;
%%%  covfstar=0.5*(covfstar+covfstar');
%%%  fstar=mvnrnd(fstarbar,covfstar);
%%%  bay(nn,:)=fstar;
%%% end

%%% NOS=nos; NWS=nws; LON=lon; LAT=lat; ID=id;
%%% clearvars -except bay all* NOS NWS LON LAT ID
%%% bay=exp(bay); % exponentiate to bring back into meters above mhhw
%%% id=allid; 
%%% lat=alllat;
%%% lon=alllon;
%%% clear all*
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % count flood days
disp('count flood days (this is the part that takes the longest)')
%%% year0=1990; yearf=2024;
%%% nxdbay=nan*zeros(1000,numel(id),numel(year0:yearf));
%%% nxdnos=nan*zeros(numel(id),numel(year0:yearf));
%%% nxdnws=nan*zeros(numel(id),numel(year0:yearf));
%%% numday=nan*zeros(numel(id),numel(year0:yearf));
%%% 
%%% % load nos thresholds again
%%% load('20240602_taskteam_regions.mat','Threshold')
%%% nos_minor=Threshold';
%%% clear Threshold
%%% maxyr=2024;
%%% minyr=1989;

%%% % now count floods
%%% for kk=1:numel(id), disp(num2str(kk))
%%%  [sl,dn]=noaaSealevel(id(kk),year0,yearf);
%%%  sl=max(reshape(sl,24,numel(sl)/24));
%%%  dn=max(reshape(dn,24,numel(dn)/24));
%%%  yr=str2num(datestr(dn,10));
%%%  mo=str2num(datestr(dn,5));
%%%  yr(find(mo<=4))=yr(find(mo<=4))-1;
%%%  clear mo
%%%  dn(find(yr==maxyr|yr==minyr))=[];
%%%  sl(find(yr==maxyr|yr==minyr))=[];
%%%  yr(find(yr==maxyr|yr==minyr))=[];
%%%  uyr=unique(yr);
%%%  for ll=1:numel(uyr)
%%%   ii=find(yr==uyr(ll)&~isnan(sl'));
%%%   numday(kk,ll)=numel(ii);
%%%   nxdbay(:,kk,ll)=sum((ones(1000,1)*sl(ii))>(bay(:,kk)*ones(1,numel(ii))),2);
%%%   ijk=[]; ijk=find(ID==id(kk));
%%%   nxdnos(kk,ll)=sum(sl(ii)>nos_minor(kk));
%%%   if ~isempty(ijk)
%%%    nxdnws(kk,ll)=sum(sl(ii)>NWS(ijk));
%%%   end
%%%  end
%%% end
%%% save('nxd.mat','nxd*','id','lon','lat','bay','NOS','NWS','ID','LON','LAT','numday')
%%% clearvars -except nos_minor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% % create main data file for plotting
%%% % load data
disp('now bring all this together in a single file to be loaded into your plotting code')
%%% load('nxd.mat')

%%% % sort flood stages
%%% for kk=1:numel(id)
%%%  ii=[]; ii=find(id(kk)==ID);
%%%  if ~isempty(ii)
%%%   nws(kk)=NWS(ii);
%%%  else
%%%   nws(kk)=nan;
%%%  end
%%% end
%%% nos=nos_minor;
%%% clearvars -except nws nos nxd* lon lat id bay numday

%%% % obtain regions
%%% load('20240602_taskteam_regions.mat')
%%% myreg(8)={'Alaska'};
%%% myreg(7)={'Northwest'};
%%% myreg(6)={'Southwest'};
%%% myreg(5)={'Western Gulf'};
%%% myreg(4)={'Eastern Gulf'};
%%% myreg(3)={'Southeast'};
%%% myreg(2)={'Northeast'};
%%% myreg(9)={'Caribbean'};
%%% myreg(1)={'Pacific'};
%%% Reg=nan*ones(size(Lon));
%%% for kk=1:numel(Reg)
%%%  for ll=1:numel(myreg)
%%%   if strcmp(char(myreg(ll)),char(Region(kk)))
%%%    reg(kk)=ll;
%%%   end
%%%  end
%%% end
%%% name=Name;
%%% clearvars -except nws nos nxd* lon lat id bay reg myreg numday name

%%% % re-get datums
%%% for kk=1:numel(id), disp(num2str(kk))
%%%  dt=noaaDatums(id(kk));
%%%  % get datums
%%%  if isfield(dt,'MHHW')
%%%   mhhw(kk)=dt.MHHW;
%%%  end
%%%  if isfield(dt,'GT')
%%%   gt(kk)=dt.GT;
%%%  end
%%% end
%%% clear kk dt 
%%% clearvars -except nws nos nxd* lon lat id bay reg mhhw gt numday name myreg

%%% % get geography
%%% land=shaperead('landareas.shp');
%%% land2=land;
%%% for kk=1:numel(land2)
%%%  land2(kk).X=land2(kk).X+360;
%%% end

%%% % make color map
%%% clrbr=[];
%%% for jj=1:numel(reg)
%%%  ii=find(reg==jj);
%%%  clrtemp=turbo(numel(reg)*numel(ii));
%%%  % delete initial
%%%  clrtemp(1:((jj-1)*numel(ii)),:)=[];
%%%  clrtemp((numel(ii)+1):end,:)=[];
%%%  clrbr=[clrbr; clrtemp];
%%% end

%%% % save out
%%% save('maindata.mat','nws','nos','nxd*','lon','lat','id','bay','reg','mhhw','gt','land*','clrbr','numday','name','myreg')