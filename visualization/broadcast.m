function [txt] = broadcast(event, last_txt)
% Output: string, broadcast of the event
%   此处显示详细说明
    last_txt=last_txt{1};
    %disp(last_txt(max(1,end-4):end));
    if ((strcmp(last_txt(max(1,end-4):end),'sleep')||strcmp(last_txt(max(1:end-2):end),'Obs')||strcmp(last_txt(max(1,end-3):end),'idle'))&&(strcmp(event.name,'sleep')||strcmp(event.name,'idle')||strcmp(event.name,'Obs')))
        txt=[];
    
    else
        cur_time=floor(event.time*1000);
        cur_time=cur_time/1000;
        txt=[num2str(cur_time),'s: ',event.type, ' ', num2str(event.ind), ' ', event.name];
    end

end

