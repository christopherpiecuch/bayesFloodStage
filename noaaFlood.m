function [flood]=noaaFlood(station)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [datum]=noaaDatums(station)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Downloads datums from NOAA at tide gauge 
% given by "station" ID (e.g., WHOI is 8447930) 
% all values are in m relative to 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% first get metadata for station
clear URL filename status X
%station=8447930;
URL=['https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations/',num2str(station),'/floodlevels.json?units=metric&datum=MHHW'];
filename='data.txt';
[~,status]=urlwrite(URL, filename);
if (status==1)
    % load metadata
    X=importdata(filename);
    %X=char(X);
    
    % now find where the metadata are
    % they're all enclosed within quotes
    x=char(X(2));
    z=16;
    if strcmp('null',x(z:end-1))
        flood.nos_minor=nan;
    else
        flood.nos_minor=str2num(x(z:end-1));
    end
    
    x=char(X(3));
    z=19;
   if strcmp('null',x(z:end-1))
        flood.nos_moderate=nan;
    else
        flood.nos_moderate=str2num(x(z:end-1));
    end
    
    x=char(X(4));
    z=16;
   if strcmp('null',x(z:end-1))
        flood.nos_major=nan;
   else
        flood.nos_major=str2num(x(z:end-1));
   end
    
	x=char(X(5));
    z=16;
    if strcmp('null',x(z:end-1))
        flood.nws_minor=nan;
    else
        flood.nws_minor=str2num(x(z:end-1));
    end
    
    x=char(X(6));
    z=19;
   if strcmp('null',x(z:end-1))
        flood.nws_moderate=nan;
    else
        flood.nws_moderate=str2num(x(z:end-1));
    end
    
    x=char(X(7));
    z=16;
   if strcmp('null',x(z:end-1))
        flood.nws_major=nan;
   else
        flood.nws_major=str2num(x(z:end-1));
   end
end
flood.units='m STND';