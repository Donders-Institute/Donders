
function LifeGame2D
tic
% LifeGame2D is a traditional version of Conway's Game of Life,
% developed on a toroidal universe. This one is faster than LifeGame.m
% for large universes and a bit slower for small ones. 
%
% The aim of this code is being as simple as possible and provide 
% a file with data for statistical analysis after the simulation. 
%
% Author: Vladimiro Boselli, mail boselli(DOT)vladimiro {AT} gmail[DOT]com
% Share freely, attribution is appreciated.
% ######################
% ### INITIAL SET UP ###
% ######################
% Choose torus dimesion 'L' and run the simulation for a number 'gen'
% of generations.
L=50;                      
gen=200;
% Create array to store statistical data.
Stat=zeros(gen, 4);
%Hypertorus
T = zeros(L+1,L+1);
Tnew = T;
Adv=[2:L 1];
Ret=[L 1:L-1];
% ####################################
% ### LIFE RULE AND STARTING CELLS ###
% ####################################
% Life Rule - CLASSICAL RULE: S23/B3
Sur = [1 3];  % Exact # cells to survive
Bor = 3;      % Exact # cells to create a new one
% % Initial Set - DEFAULT: GLIDER S23/B3    
% T(1:3,1)=1;
% T(3,2)=1;
% T(2,3)=1;
% % Initial Set - DEFAULT: GLIDER S245/B3
% T(11,1:3)=1;
% T(12,1:2)=1;
% T(13,1)=1;
% Initial Set - DEFAULT: GLIDER S13/B3
T(1,1:3)=1;
T(3,1:3)=1;
T(2,4:5)=1;
% ########################
% ### START SIMULATION ###
% ########################      
% Start Plot
   sub=(L+1)^2;
   SUB=[L+1,L+1];
       K = find(T,sub);   
       [x,y] = ind2sub(SUB,K);
   axis([0 L 0 L]);
   
       Cells = [[Ret(x)',Ret(y)']' [x,Ret(y)']' [Adv(x)',Ret(y)']'  ...
                [Ret(x)',y]'       [x,y]'       [Adv(x)',y,]'        ...
                [Ret(x)',Adv(y)']' [x,Adv(y)']' [Adv(x)',Adv(y)']']';
       Next = unique(Cells,'rows');
       n=length(Next(:,1));
   for g = 1:gen            % Cycle on generation     #TAG
      for c = 1:n
          i=Next(c,1);
          j=Next(c,2);
                  
% Moore's Hyperneighbourhood               
N=T(Ret(i),Ret(j)) + T(i,Ret(j)) + T(Adv(i),Ret(j)) + ...
  T(Ret(i),j)      + 0           + T(Adv(i),j)    + ...
  T(Ret(i),Adv(j)) + T(i,Adv(j)) + T(Adv(i),Adv(j));
            if T(i,j)==1
            Tnew(i,j) =  ~all(N~=Sur); % Survive? 
            else
            Tnew(i,j) =  ~all(N~=Bor); % Create cells?
            end
            
      end    
Told=T;
T=Tnew;  
      % Exit if static
      if Told==Tnew
         break;
      end
      
      % Select the next changing cells
       K = find(T,sub);   
       [x,y] = ind2sub(SUB,K);
              Cells = [[Ret(x)',Ret(y)']' [x,Ret(y)']' [Adv(x)',Ret(y)']'  ...
                       [Ret(x)',y]'       [x,y]'       [Adv(x)',y,]'        ...
                       [Ret(x)',Adv(y)']' [x,Adv(y)']' [Adv(x)',Adv(y)']']';
       Next = unique(Cells,'rows');
       n=length(Next(:,1));
       % Update plot.
       scatter(x,y,...
               'MarkerFaceColor',[0 1 1],...
               'MarkerEdgeColor','none');
       axis([0 L 0 L])
   set(gca,'XTickLabel', [], 'YTickLabel', [], 'XTick', [], 'YTick', []);
   box on
   grid on
   Stat(g,:)=[g sum(T(:)) (mean(T(:))*100) (mean(T(:))-mean(Told(:)))*100];
   title(sprintf('Gen: %d  #Cells: %d  Density: %5.2f%%  Growth: %5.2f%%',...
         g,sum(T(:)),(mean(T(:))*100),(mean(T(:))-mean(Told(:)))*100))
   whitebg(1,'k')
   drawnow
   end                      % End cycle on generation #TAG
   save Stat2D.txt Stat -ASCII -TABS;
   toc