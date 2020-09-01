function [sasiedzi]=Fun_neighbors(c,x,y,z,sasiedztwo)
%% LABORATORIUM PRZETWARZANIA OBRAZ�W
%% Pawe� Badura 2009
%% 
%% Funkcja zwracaj�ca indeksy sasiad�w piksela c

switch sasiedztwo
%     case 4
%         sasiedzi=[                  c(1)-1,c(2);
%                     c(1),c(2)-1;                    c(1),c(2)+1;
%                                     c(1)+1,c(2)];
%     case 8
%         sasiedzi=[  c(1)-1,c(2)-1;  c(1)-1,c(2);    c(1)-1,c(2)+1;
%                     c(1),c(2)-1;                    c(1),c(2)+1;
%                     c(1)+1,c(2)-1;  c(1)+1,c(2);    c(1)+1,c(2)+1];
    case 26
        sasiedzi=[  c(1)-1,c(2)+1,c(3)+1; c(1),c(2)+1,c(3)+1; c(1)+1,c(2)+1,c(3)+1;
                    c(1)-1,c(2)+1,c(3); c(1),c(2)+1,c(3); c(1)+1,c(2)+1,c(3);
                    c(1)-1,c(2)+1,c(3)-1; c(1),c(2)+1,c(3)-1; c(1)+1,c(2)+1,c(3)-1;
                    
                    c(1)-1,c(2),c(3)+1; c(1),c(2),c(3)+1; c(1)+1,c(2),c(3)+1;       %z=2  y=1 
                    c(1)-1,c(2),c(3);                     c(1)+1,c(2),c(3);         %z=1
                    c(1)-1,c(2),c(3)-1; c(1),c(2),c(3)-1; c(1)+1,c(2),c(3)-1;       %z=0
                    
                    c(1)-1,c(2)-1,c(3)+1; c(1),c(2)-1,c(3)+1; c(1)+1,c(2)-1,c(3)+1;
                    c(1)-1,c(2)-1,c(3); c(1),c(2)-1,c(3); c(1)+1,c(2)-1,c(3);
                    c(1)-1,c(2)-1,c(3)-1; c(1),c(2)-1,c(3)-1; c(1)+1,c(2)-1,c(3)-1];
%  case 26
%         sasiedzi=[  c(1)-1,c(2)-1,c(3)+1; c(1),c(2)-1,c(3)+1; c(1)+1,c(2)-1,c(3)+1;
%                     c(1)-1,c(2),c(3)+1;   c(1),c(2),c(3)+1;   c(1)+1,c(2),c(3)+1;
%                     c(1)-1,c(2)+1,c(3)+1; c(1),c(2)+1,c(3)+1; c(1)+1,c(2)+1,c(3)+1;
%                     
%                     c(1)-1,c(2)-1,c(3); c(1),c(2)-1,c(3); c(1)+1,c(2)-1,c(3);       %z=2  y=1 
%                     c(1)-1,c(2),c(3);                     c(1)+1,c(2),c(3);         %z=1
%                     c(1)-1,c(2)+1,c(3); c(1),c(2)+1,c(3); c(1)+1,c(2)+1,c(3);       %z=0
%                     
%                     c(1)-1,c(2)-1,c(3)-1; c(1),c(2)-1,c(3)-1; c(1)+1,c(2)-1,c(3)-1;
%                     c(1)-1,c(2),c(3)-1;   c(1),c(2),c(3)-1;   c(1)+1,c(2),c(3)-1;
%                     c(1)-1,c(2)+1,c(3)-1; c(1),c(2)+1,c(3)-1; c(1)+1,c(2)+1,c(3)-1];
end
% kontrola brzeg�w obrazu
ind_OK=find((sasiedzi(:,1)>0) & (sasiedzi(:,1)<=x) & (sasiedzi(:,2)>0) & (sasiedzi(:,2)<=y) & (sasiedzi(:,3)>0) & (sasiedzi(:,3)<=z));
sasiedzi=sasiedzi(ind_OK,:);
 
 
 