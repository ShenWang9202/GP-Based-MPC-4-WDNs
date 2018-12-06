%adjust a figure with subplot in order to have a better look. It will set
%the same scale if specified in the optional argument same scale (for x or
%y), and it will delete the label of the redundant axes when needed.
%EXAMPLE
%
% k=1;
% for i=1:8
% subplot(2,4,k);
% k=k+1;
% plot(normrnd(10,20,10,1), normrnd(10,20,10,1),'r*');
% grid on; 
% end
%scaleSubplot(gcf,'sameScale',{'x'},'xlimit',[-20 40]); %being redundant, the x axis label 
%of the intermediate plots are not shown anymore
%OR
%scaleSubplot(gcf,'xlimit',[0 200])
%

function scaleSubplot(fig, varargin)
p=inputParser;
addParamValue(p, 'xlimit',[]); %ex. [-100 200]
addParamValue(p, 'ylimit',[]); 
%which scales have to be adjusted? 
%notice that if you specify xlimit and then 'sameScale', 'y', xlimit will
%not be considered (the subplot will have different scales)
%(same for the opposite)
addParamValue(p, 'sameScale', {'x','y'}); 
parse(p, varargin{:});
sameScale=p.Results.sameScale;
xlimit=p.Results.xlimit;
ylimit=p.Results.ylimit; 

if nargin<1
    fig=gcf;
end

AH=fig.Children;


%retrieve maximum/minimum values for x and y amongst all the subplots
data=findobj(AH,'Type','axes')

%{
xmin=min([AH.XLim]);
xmax=max([AH.XLim]);
ymin=min([AH.YLim]); ymax=max([AH.YLim]);
%}
xmin=min([data.XLim]);
xmax=max([data.XLim]);
ymin=min([data.YLim]); ymax=max([data.YLim]);

%now find the leftmost axes and the bottom ones.
xpos=cellfun(@(cell) cell(1),{data.Position}); mpos=min(xpos); leftmost=find(mpos==xpos);
ypos=cellfun(@(cell) cell(2),{data.Position}); mpos=min(ypos); bottom=find(mpos==ypos);


%if appropriate, put the same scale everywhere
for i=1:numel(data)
    axes(data(i));
    if any(ismember(sameScale,'x'))
        if isempty(xlimit)
            xlimin=xmin;  xlimax=xmax;
        else
            xlimin=xlimit(1); xlimax=xlimit(2);
            if xlimit(1)==-Inf  xlimin=xmin; end
            if xlimit(2)==Inf xlimax=xmax; end
        end
        
        set(gca, 'xlim',[xlimin xlimax]);
    end
    if any(ismember(sameScale,'y'))
        if isempty(ylimit)
            ylimin=ymin;  ylimax=ymax;
        else
            ylimin=ylimit(1); ylimax=ylimit(2);
            if ylimit(1)==-Inf  ylimin=ymin; end
            if ylimit(2)==Inf ylimax=ymax; end
        end
        
        set(gca, 'ylim',[ylimin ylimax]);
    end
end

%now we cicle through axis and delete the x/y label if required
for i=1:numel(data)
    axes(data(i));
    set(gca,'XTickLabelMode', 'auto');set(gca,'YTickLabelMode', 'auto');
    if any(ismember(sameScale,'y')) %if y it's always the same scale, we don't repeat it
        if  ~ismember(i, leftmost)
            set(gca, 'YTickLabel',[]);
        end
    end
    if any(ismember(sameScale,'x')) %if x it's always the same scale, we don't repeat it
        if ~ismember(i, bottom)
            set(gca,'XTickLabel',[]);
        end
    end
end
