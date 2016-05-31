% Splitlab Configureation GUI helper function

Plist={'P','S','Pdiff','Sdiff','PP','SS','PPP','PcP','PcS','ScS','ScP','PS','SP',...
    'SKP','PKS','SKS','SKiKS','SKJKS','PKiKP','PKJKP','sSKS','pSKS', ...
    'PKKP', 'PKKS','SKKS', 'SKKP'};

if isempty(config.phases)
    phaseval=15;
else
    phaseval =[];
    %find selected phases in Plist
    for k= 1:length(config.phases)
        ind = strmatch(config.phases(k), Plist, 'exact');
    phaseval = [phaseval ind];
    end
end
config.phases=Plist(phaseval);

    %% Phase data
    h.panel(2) = uipanel('Units','pixel','Title','Phases','Position',[130 5 425 410], 'BackgroundColor', [224   223   227]/255 , 'Visible','off');

                                              
    h.phase(2) = uicontrol('Parent',h.panel(2),'Units','pixel',...
                             'Style','List','Min',1,'Max',50,...
                             'BackgroundColor','w',...
                             'Position',[15 15 70 pos(4)-50],...
                             'Value',phaseval,...
                             'String', Plist,...
                             'Callback', 'val=get(gcbo,''Value''); str=get(gcbo,''String''); config.phases=str(val);clear val str ');

                         

%% Homogeneous Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.panel(10) = uipanel('Units','pixel','Title','Homogeneous model','Position',[110 5 290 160],'Parent',h.panel(2), 'BackgroundColor', [224   223   227]/255 );
    
string = {'Please enter Vp and Vs velocity of your study area.',
          'These are used to calculate the approximate P- and S arrival times.'};
uicontrol('Parent',h.panel(10),'Units','pixel',...
        'Style','text',...
         'Position',[10 55 270 80],...
        'String', string,...
        'HorizontalAlignment','Left'); 

hndl = uicontrol('Units','pixel', 'Style','text','Parent',h.panel(10),...
    'Position',[100 10 85 15], 'String', ['Vp/Vs = ' num2str(config.Vp/config.Vs)]);

hndl1 = uicontrol('Units','pixel', 'Style','edit','Parent',h.panel(10),...
    'backgroundColor','w','tooltipstring','Enter P-wave velocity',...
    'Position',[20 35 45 20], 'String', num2str(config.Vp),...
    'UserData', hndl,...
    'Callback', 'config.Vp = str2num(get(gcbo,''String'')); set(get(gcbo,''UserData''), ''String'', [''Vp/Vs = '' num2str(config.Vp/config.Vs)])');


hndl2 = uicontrol('Units','pixel', 'Style','edit','Parent',h.panel(10),...
    'backgroundColor','w','tooltipstring','Enter S-wave velocity',  ...
    'Position',[190 35 45 20], 'String', num2str(config.Vs),...
    'UserData', hndl,...
    'Callback', 'config.Vs = str2num(get(gcbo,''String''));; set(get(gcbo,''UserData''), ''String'', [''Vp/Vs = '' num2str(config.Vp/config.Vs)])');


uicontrol('Units','pixel', 'Style','text','Parent',h.panel(10),...
    'Position',[70 35 25 15], 'String', 'km/s');
uicontrol('Units','pixel', 'Style','text','Parent',h.panel(10),...
    'Position',[240 35 25 15], 'String', 'km/s');

uicontrol('Units','pixel', 'Style','text','Parent',h.panel(10),...
    'Position',[20 55 45 15], 'String', 'Vp');
uicontrol('Units','pixel', 'Style','text','Parent',h.panel(10),...
    'Position',[180 55 45 15], 'String', 'Vs');


%% Global model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 h.button(1) = uicontrol('Parent',h.panel(2),'Units','pixel',...
                             'Style','Pushbutton',...
                             'Position',[105 280 100 20],...
                             'String', 'View travel times',...
                             'Callback','SL_ttcurves(config.earthmodel,config.phases, config.z_win(1), mean(config.eqwin), config.eqwin)');
modelstring = {...
			   'AK135 (Kennett, Engdahl & Buland,1995)',...
			   'SP6 (Morelli & Dziewonski,1993)',...
			   'IASP91 (Kennett & Engdahl,1991)',...
               'PREM (Dziewonski & Anderson,1984)',...
			   'HERRIN (Herrin, 1968)',...
			   'JB (Jeffreys & Bullen,1940)',...
			   'Homogeneous (regional/local)'};
			   %% These models give problems in matTaup:
			   % 'PWDK (Weber & Davis,1990)',...
			   % '1066a (Gilbert & Dziewonski,1975)',...
			   % '1066b (Gilbert & Dziewonski,1975)',...
    val        = strmatch(config.earthmodel, lower(modelstring));
    h.phase(1) = uicontrol('Parent',h.panel(2),'Units','pixel',...
                             'Style','PopupMenu',...
                             'BackgroundColor','w',...
                             'Position',[105 350 250 20],...
                             'String',modelstring ,...
                             'UserData',[h.button(1) h.panel(10) ],...
                             'Value', val,...
                             'CallBack',...
                             ... % Earthmode is the lower-case of EARTHMODEL up to the first space character
                             ['tmp1=get(gcbo,''Value'');tmp2=get(gcbo,''UserData'');',....
                             'if tmp1==7;  set(get(tmp2(2),''Children''), ''Enable'' ,''on'');  set(tmp2(1), ''Enable'' ,''off''); ',...
                             'else,        set(get(tmp2(2),''Children''), ''Enable'' ,''off''); set(tmp2(1), ''Enable'' ,''on''); ',...
                             'end;',... 
                             'tmp2=lower(get(gcbo,''String''));',...
                             'tmp3=char(tmp2(tmp1));',...
                             'config.earthmodel=strtok(tmp3, '' '');',...
                             'clear tmp1 tmp2 tmp3']);
                         if val ==7
                             set(get(h.panel(10), 'Children'), 'Enable','on');
                             set(h.button(1), 'Enable','off');
                         else
                             set(get(h.panel(10), 'Children'), 'Enable','off');
                             set(h.button(1), 'Enable','on');
                         end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                         
uicontrol('Parent',h.panel(2),'Units'  ,'pixel',...
    'Style'    ,'checkbox',...
    'Value'    ,config.calcphase,...
    'Position' ,[105 310 138 20],...
    'UserData', [ h.button(1), h.phase(2)],...
    'String'   , 'Calculate phase arrivals',...
    'Tooltip'  ,'Phase arrivals as selected in the ''Phase''-panel',...
    'Callback' ,['config.calcphase=get(gcbo,''Value'');',....
                             'if config.calcphase;  set(get(gcbo,''UserData''), ''Enable'' ,''on'');',...
                             'else,     set(get(gcbo,''UserData''), ''Enable'' ,''off'');',...
                             'end;']);
                         
if config.calcphase
    set([ h.button(1), h.phase(2)],'enable','on')
else
    set([ h.button(1), h.phase(2)],'enable','off')
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     uicontrol('Parent',h.panel(2),'Units','pixel',...
        'Style','text',...
         'Position',[110 180 220 80],...
        'String', {'Not the phase you were looking for?', 'Edit the file',' "/Splitlab/private/configpanelPHASES.m"', 'The available phases are limited to those who exist in matTaup.'},...
        'HorizontalAlignment','Left'); 

                         
axes( 'parent',h.panel(2), 'Units','pixel','position', [320 260 90 90] )
image(icon.Wclock)
axis off