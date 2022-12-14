% Start%% clear------------------------------------------------------------
clear all;clc;close all;
%--------------------------------------------------------------------------
text{1}='Process 1 of 9 --> Define Variable';
text{2}='Process 2 of 9 --> Get Input Data';
text{3}='Process 3 of 9 --> Calculate Transmission Matrix';
text{4}='Process 4 of 9 --> Calculate Mass Inertia...';
text{5}='Process 5 of 9 --> Calculate KE , PE';
text{6}='Process 6 of 9 --> Calculate System Equation';
text{7}='Process 7 of 9 --> Calculate Point on path';
text{8}='Process 8 of 9 --> Calculate System Equation in point';
text{9}='Process 9 of 9 --> Calculate Torq';
% Define Variables=========================================================
disp(text{1});
%syms m1 m2 m3  L1 L2 L3 b1 b2 b3;
%syms h1 h2 h3 I1X I1Y I1Z I2x I2y I2z;

syms teta1 teta1i teta1ii;
syms teta2 teta2i teta2ii;
syms teta3 teta3i teta3ii;
syms x xi xii;
syms y yi yii;
syms z zi zii;

syms g torq1 torq2 torq3 fx fy fz fx1 fy1 fz1;
syms t tf dxf dyf dzf nAP nAT;

global P tf dxf dyf dzf dtf1 dtf2 dtf3 nAP nAT NP;
global Pos0 Posf Teta TetaError TetaGess pathname;
global LookUpTeta Time Tetazoj LookUpTetazoj LookUpTetazoj1;
clc;

%User Define--------------------------------------------------------------
Body.M=30;
Body.L=2;
Body.H=0.01;
Body.B=2;

P.M=[1 1 1 Body.M/3];
P.L=[.5 .5 1 Body.L];
P.H=[.01 .01 .01 Body.H];
P.B=[.01 .01 .01 Body.B];

TetaGess=[0 -pi/4 -pi/8];
Pos0=[0 P.L(1)*cos(TetaGess(2))+P.L(2)*cos(TetaGess(2)+TetaGess(3)) P.L(1)*sin(TetaGess(2))+P.L(2)*sin(TetaGess(2)+TetaGess(3))];

g=9.81;
Fg=[0;0;-g;0];
Ff=[fx;fy;fz;0];
Ff1=[fx1;fy1;fz1;0];
Torq=[torq1;torq2;torq3];

Q={teta1 teta2 teta3 x y z;
   teta1i teta2i teta3i xi yi zi;
   teta1ii teta2ii teta3ii xii yii zii};
clc;

%Calculate Transimission Matrix============================================
MT01=[1,0,0,x;
      0,1,0,y;
      0,0,1,z;
      0,0,0,1];
MT12=[cos(teta1),-sin(teta1),0,0;
      sin(teta1),cos(teta1),0,0;
      0,0,1,0;
      0,0,0,1];
MT23=[1,0,0,0;
      0,cos(teta2),-sin(teta2),P.L(1);
      0,sin(teta2),cos(teta2),0;
      0,0,0,1];
MT34=[1,0,0,0;
      0,cos(teta3),-sin(teta3),P.L(2);
      0,sin(teta3),cos(teta3),0;
      0,0,0,1];
%-------------------------------------------------------------------------
MTM{1}=simple(MT01*MT12);
MTM{2}=simple(MT01*MT12*MT23);
MTM{3}=simple(MT01*MT12*MT23*MT34);
MTM{4}=simple(MT01);

%=========================================================================
sG{1}=[0;P.L(1)/2;0;1];
sG{2}=[0;P.L(2)/2;0;1];
sG{3}=[0;P.L(3)/2;0;1];
sG{4}=[0;0;0;1];

sP=[0;P.L(3);0;1];
sF=[0;0;0;1];
%--------------------------------------------------------------------------
for i=1:4
SG(i)={MTM{i}*sG{i}}; 
RTM{i}=[MTM{i}(1,1) MTM{i}(1,2) MTM{i}(1,3);
        MTM{i}(2,1) MTM{i}(2,2) MTM{i}(2,3);
        MTM{i}(3,1) MTM{i}(3,2) MTM{i}(3,3)];
end
SP=MTM{3}*sP;
SF=MTM{4}*sF;

%Calculate Inertia--------------------------------------------------------
for i=1:4
    IL{i}=[1/12*P.M(i)*(P.L(i)^2+P.B(i)^2) 0 0;
           0 1/12*P.M(i)*(P.L(i)^2+P.B(i)^2) 0;
           0 0 1/12*P.M(i)*(P.L(i)^2+P.B(i)^2)];
       IG{i}=RTM{i}.'*IL{i}*RTM{i};
end
Isim=IL;
clear RTM;
%{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
%Calculate teta(x,y,x)=0---------------------------------------------------
disp(text{7});

nAP=2;
nAT=6;
ft=10;

dxf=pi/6;
dyf=pi/4;
dzf=cos(pi/8);

dtf1=-pi/12;
dtf2=pi/8;
dtf3=-pi/8;

pathname='soosk';
path
%break
%Calculate teta=teta(t)----------------------------------------------------
    tf=ft/(NP-1);
    traject;
    
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Calculate KE
disp(text{5});
SumKE=0;
for i=1:4
    AdMTM=0;
    for j=1:6
        AdMTM=AdMTM+diff(MTM{i},Q{1,j})*Q{2,j};
    end
    dMTM{i}=AdMTM;
    dSG{i}=simple(dMTM{i}*sG{i});
    w{i}=simple(dMTM{i}*MTM{i}^-1);
    W{i}=[w{i}(3,2);w{i}(1,3);w{i}(2,1)];
KE{i}=simple((1/2*P.M(i)*dSG{i}.'*dSG{i})+(1/2*W{i}.'*IG{i}*W{i}));
            SumKE=SumKE+simple(KE{i});
end
clear AdMTM
%Calculate PE-------------------------------------------------------------
PE=0;PE1=0;
for i=1:3
    PE=PE+Fg.'*(P.M(i)*SG{i});
end
    PE=PE+Torq.'*[teta1;teta2;teta3]+Ff.'*SF;
    
for i=1:3
    PE1=PE1+Fg.'*(P.M(i)*SG{i});
end
    PE1=PE1+Torq.'*[teta1;teta2;teta3]+Ff1.'*SP;
%break

%Lagrangian----------------------------------------------------------------
disp(text{6});
for j=1:6
    Eq1=0;Eq2=0;
    Eq0=diff(SumKE,Q{2,j});
    for i=1:6
        Eq2=Eq2+diff(Eq0,Q{1,i})*Q{2,i};
        Eq1=Eq1+diff(Eq0,Q{2,i})*Q{3,i};

    end
    EQ{j}=simple(Eq1+Eq2-diff(PE,Q{1,j}));
    EQ1{j}=simple(Eq1+Eq2-diff(PE1,Q{1,j}));
end
clear Eq0 Eq1 Eq2;
%break

%##########################################################################
disp(text{8});clc;
for j=1:6
    for k=1:nAT*(NP-1)+1
        clc;disp(text{8});disp([3 nAT*(NP-1)+1]); disp([j k]);
        SEQ{k,j}=subs(EQ{j},x,0);
        SEQ{k,j}=subs(SEQ{k,j},xi,0);
        SEQ{k,j}=subs(SEQ{k,j},xii,0);
        
        SEQ{k,j}=subs(SEQ{k,j},y,0);
        SEQ{k,j}=subs(SEQ{k,j},yi,0);
        SEQ{k,j}=subs(SEQ{k,j},yii,0);
        
        SEQ{k,j}=subs(SEQ{k,j},z,0);
        SEQ{k,j}=subs(SEQ{k,j},zi,0);
        SEQ{k,j}=subs(SEQ{k,j},zii,0);
        
        SEQ{k,j}=subs(SEQ{k,j},teta1,LookUpTeta{1}(k,1));
        SEQ{k,j}=subs(SEQ{k,j},teta1i,LookUpTeta{1}(k,2));
        SEQ{k,j}=subs(SEQ{k,j},teta1ii,LookUpTeta{1}(k,3));
        
        SEQ{k,j}=subs(SEQ{k,j},teta2,LookUpTeta{2}(k,1));
        SEQ{k,j}=subs(SEQ{k,j},teta2i,LookUpTeta{2}(k,2));
        SEQ{k,j}=subs(SEQ{k,j},teta2ii,LookUpTeta{2}(k,3));
        
        SEQ{k,j}=subs(SEQ{k,j},teta3,LookUpTeta{3}(k,1));
        SEQ{k,j}=subs(SEQ{k,j},teta3i,LookUpTeta{3}(k,2));
        SEQ{k,j}=subs(SEQ{k,j},teta3ii,LookUpTeta{3}(k,3));
        
    end
end

%--------------------------------------------------------------------------
for k=1:nAT*(NP-1)+1
    clc;disp(text{9});disp([nAT*(NP-1)+1]);disp([k]);
    NTOR=solve(SEQ{k,:});
    
    LookUpTorq(k,1)=k;LookUpTorq(k,2)=k;LookUpTorq(k,3)=k;
    LookUpTorq(k,1)=NTOR.torq1;
    LookUpTorq(k,2)=NTOR.torq2;
    LookUpTorq(k,3)=NTOR.torq3;
    
    LookUpForce(k,1)=k;LookUpForce(k,2)=k;LookUpForce(k,3)=k;
    LookUpForce(k,1)=NTOR.fx;
    LookUpForce(k,2)=NTOR.fy;
    LookUpForce(k,3)=NTOR.fz;
end
%clear NTOR SEQ;

%##########################################################################
disp(text{8});clc;
for j=1:3
    for k=1:nAT*(NP-1)+1
        clc;disp(text{8});disp([3 nAT*(NP-1)+1]); disp([j k]);
        SEQ1{k,j}=subs(EQ1{j},x,0);
        SEQ1{k,j}=subs(SEQ1{k,j},xi,0);
        SEQ1{k,j}=subs(SEQ1{k,j},xii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},y,0);
        SEQ1{k,j}=subs(SEQ1{k,j},yi,0);
        SEQ1{k,j}=subs(SEQ1{k,j},yii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},z,0);
        SEQ1{k,j}=subs(SEQ1{k,j},zi,0);
        SEQ1{k,j}=subs(SEQ1{k,j},zii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},fx1,LookUpForce(k,1));
        SEQ1{k,j}=subs(SEQ1{k,j},fy1,LookUpForce(k,2));
        SEQ1{k,j}=subs(SEQ1{k,j},fz1,LookUpForce(k,3));
        
        SEQ1{k,j}=subs(SEQ1{k,j},teta1,TetaGess(1));
        SEQ1{k,j}=subs(SEQ1{k,j},teta1i,0);
        SEQ1{k,j}=subs(SEQ1{k,j},teta1ii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},teta2,TetaGess(2));
        SEQ1{k,j}=subs(SEQ1{k,j},teta2i,0);
        SEQ1{k,j}=subs(SEQ1{k,j},teta2ii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},teta3,TetaGess(3));
        SEQ1{k,j}=subs(SEQ1{k,j},teta3i,0);
        SEQ1{k,j}=subs(SEQ1{k,j},teta3ii,0);
      
        
    end
end
%--------------------------------------------------------------------------
for k=1:nAT*(NP-1)+1
    clc;disp(text{9});disp([nAT*(NP-1)+1]);disp([k]);
    NTOR=solve(SEQ1{k,:});
    LookUpTorq1(k,1)=k;LookUpTorq1(k,2)=k;LookUpTorq1(k,3)=k;
    LookUpTorq1(k,1)=NTOR.torq1;
    LookUpTorq1(k,2)=NTOR.torq2;
    LookUpTorq1(k,3)=NTOR.torq3;
end
%    clear NTOR SEQ1;
%##########################################################################
%for i=1:10
%    LookUpTorq(k+i,1)=LookUpTorq(k,1);
%    LookUpTorq(k+i,2)=LookUpTorq(k,2);
%    LookUpTorq(k+i,3)=LookUpTorq(k,3);
%    LookUpTorq1(k+i,1)=LookUpTorq1(k,1);
%    LookUpTorq1(k+i,2)=LookUpTorq1(k,2);
%    LookUpTorq1(k+i,3)=LookUpTorq1(k,3);
    
%    LookUpForce(k+i,1)=LookUpForce(k,1);
%    LookUpForce(k+i,2)=LookUpForce(k,2);
%    LookUpForce(k+i,3)=LookUpForce(k,3);
    
%    Time(k+i)=(k+i)*(Time(2)-Time(1));
    
%    LookUpTeta{1}(k+i,1)=LookUpTeta{1}(k,1);
%    LookUpTeta{2}(k+i,1)=LookUpTeta{2}(k,1);
%    LookUpTeta{3}(k+i,1)=LookUpTeta{3}(k,1);
%end
%--------------------------------------------------------------------------
disp(text{8});clc;
for j=1:6
    for k=1:nAT*(NP-1)+1
        clc;disp(text{8});disp([3 nAT*(NP-1)+1]); disp([j k]);
        SEQ{k,j}=subs(EQ{j},x,0);
        SEQ{k,j}=subs(SEQ{k,j},xi,0);
        SEQ{k,j}=subs(SEQ{k,j},xii,0);
        
        SEQ{k,j}=subs(SEQ{k,j},y,0);
        SEQ{k,j}=subs(SEQ{k,j},yi,0);
        SEQ{k,j}=subs(SEQ{k,j},yii,0);
        
        SEQ{k,j}=subs(SEQ{k,j},z,0);
        SEQ{k,j}=subs(SEQ{k,j},zi,0);
        SEQ{k,j}=subs(SEQ{k,j},zii,0);
        
        SEQ{k,j}=subs(SEQ{k,j},teta1,LookUpTetazoj{1}(k,1));
        SEQ{k,j}=subs(SEQ{k,j},teta1i,LookUpTetazoj{1}(k,2));
        SEQ{k,j}=subs(SEQ{k,j},teta1ii,LookUpTetazoj{1}(k,3));
        
        SEQ{k,j}=subs(SEQ{k,j},teta2,LookUpTetazoj{2}(k,1));
        SEQ{k,j}=subs(SEQ{k,j},teta2i,LookUpTetazoj{2}(k,2));
        SEQ{k,j}=subs(SEQ{k,j},teta2ii,LookUpTetazoj{2}(k,3));
        
        SEQ{k,j}=subs(SEQ{k,j},teta3,LookUpTetazoj{3}(k,1));
        SEQ{k,j}=subs(SEQ{k,j},teta3i,LookUpTetazoj{3}(k,2));
        SEQ{k,j}=subs(SEQ{k,j},teta3ii,LookUpTetazoj{3}(k,3));
        
    end
end

%--------------------------------------------------------------------------
for k=1:nAT*(NP-1)+1
    clc;disp(text{9});disp([nAT*(NP-1)+1]);disp([k]);
    NTOR=solve(SEQ{k,:});
    
    LookUpTorqzoj(k,1)=k;LookUpTorqzoj(k,2)=k;LookUpTorqzoj(k,3)=k;
    LookUpTorqzoj(k,1)=NTOR.torq1;
    LookUpTorqzoj(k,2)=NTOR.torq2;
    LookUpTorqzoj(k,3)=NTOR.torq3;
    
    LookUpForcezoj(k,1)=k;LookUpForcezoj(k,2)=k;LookUpForcezoj(k,3)=k;
    LookUpForcezoj(k,1)=NTOR.fx;
    LookUpForcezoj(k,2)=NTOR.fy;
    LookUpForcezoj(k,3)=NTOR.fz;
end
%clear NTOR SEQ;

%##########################################################################
disp(text{8});clc;
for j=1:3
    for k=1:nAT*(NP-1)+1
        clc;disp(text{8});disp([3 nAT*(NP-1)+1]); disp([j k]);
        SEQ1{k,j}=subs(EQ1{j},x,0);
        SEQ1{k,j}=subs(SEQ1{k,j},xi,0);
        SEQ1{k,j}=subs(SEQ1{k,j},xii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},y,0);
        SEQ1{k,j}=subs(SEQ1{k,j},yi,0);
        SEQ1{k,j}=subs(SEQ1{k,j},yii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},z,0);
        SEQ1{k,j}=subs(SEQ1{k,j},zi,0);
        SEQ1{k,j}=subs(SEQ1{k,j},zii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},fx1,LookUpForcezoj(k,1));
        SEQ1{k,j}=subs(SEQ1{k,j},fy1,LookUpForcezoj(k,2));
        SEQ1{k,j}=subs(SEQ1{k,j},fz1,LookUpForcezoj(k,3));
        
        SEQ1{k,j}=subs(SEQ1{k,j},teta1,TetaGess(1));
        SEQ1{k,j}=subs(SEQ1{k,j},teta1i,0);
        SEQ1{k,j}=subs(SEQ1{k,j},teta1ii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},teta2,TetaGess(2));
        SEQ1{k,j}=subs(SEQ1{k,j},teta2i,0);
        SEQ1{k,j}=subs(SEQ1{k,j},teta2ii,0);
        
        SEQ1{k,j}=subs(SEQ1{k,j},teta3,TetaGess(3));
        SEQ1{k,j}=subs(SEQ1{k,j},teta3i,0);
        SEQ1{k,j}=subs(SEQ1{k,j},teta3ii,0);
      
        
    end
end
%--------------------------------------------------------------------------
for k=1:nAT*(NP-1)+1
    clc;disp(text{9});disp([nAT*(NP-1)+1]);disp([k]);
    NTOR=solve(SEQ1{k,:});
    LookUpTorqzoj1(k,1)=k;LookUpTorqzoj1(k,2)=k;LookUpTorqzoj1(k,3)=k;
    LookUpTorqzoj1(k,1)=NTOR.torq1;
    LookUpTorqzoj1(k,2)=NTOR.torq2;
    LookUpTorqzoj1(k,3)=NTOR.torq3;
end
%    clear NTOR SEQ1;
%##########################################################################
%for i=1:10
%   LookUpTorqzoj(k+i,1)=LookUpTorqzoj(k,1);
%    LookUpTorqzoj(k+i,2)=LookUpTorqzoj(k,2);
%    LookUpTorqzoj(k+i,3)=LookUpTorqzoj(k,3);
%    LookUpTorqzoj1(k+i,1)=LookUpTorqzoj1(k,1);
%    LookUpTorqzoj1(k+i,2)=LookUpTorqzoj1(k,2);
%    LookUpTorqzoj1(k+i,3)=LookUpTorqzoj1(k,3);
%    
%    LookUpForcezoj(k+i,1)=LookUpForcezoj(k,1);
%    LookUpForcezoj(k+i,2)=LookUpForcezoj(k,2);
%    LookUpForcezoj(k+i,3)=LookUpForcezoj(k,3);
    
%    Time(k+i)=(k+i)*(Time(2)-Time(1));
    
%    LookUpTetazoj{1}(k+i,1)=LookUpTetazoj{1}(k,1);
%    LookUpTetazoj{2}(k+i,1)=LookUpTetazoj{2}(k,1);
%    LookUpTetazoj{3}(k+i,1)=LookUpTetazoj{3}(k,1);
%end

%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
Time=Time';
       LookUp(:,1)=Time;
%       LookUp(:,2)=LookUpTeta{1}(:,1);
%       LookUp(:,3)=LookUpTeta{2}(:,1);
%       LookUp(:,4)=LookUpTeta{3}(:,1);
%       LookUp(:,5)=LookUpTorq(:,1);
%       LookUp(:,6)=LookUpTorq(:,2);
%       LookUp(:,7)=LookUpTorq(:,3);
%       LookUp1(:,1)=Time;
%       LookUp1(:,2)=LookUpTeta{1}(:,1);
%       LookUp1(:,3)=LookUpTeta{2}(:,1);
%       LookUp1(:,4)=LookUpTeta{3}(:,1);
%       LookUp1(:,5)=LookUpTorq1(:,1);
%       LookUp1(:,6)=LookUpTorq1(:,2);
%       LookUp1(:,7)=LookUpTorq1(:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       LookUp(:,2)=LookUpTeta{1}(:,1);
%       LookUp(:,3)=LookUpTeta{2}(:,1);
%       LookUp(:,4)=LookUpTeta{3}(:,1);
%       LookUpzoj(:,5)=LookUpTorqzoj(:,1);
%       LookUpzoj(:,6)=LookUpTorqzoj(:,2);
%       LookUpzoj(:,7)=LookUpTorqzoj(:,3);
%       LookUp1(:,1)=Time;
%       LookUp1(:,2)=LookUpTeta{1}(:,1);
%       LookUp1(:,3)=LookUpTeta{2}(:,1);
%       LookUp1(:,4)=LookUpTeta{3}(:,1);
%       LookUpzoj1(:,5)=LookUpTorqzoj1(:,1);
%       LookUpzoj1(:,6)=LookUpTorqzoj1(:,2);
%       LookUpzoj1(:,7)=LookUpTorqzoj1(:,3);
%--------------------------------------------------------------------------
for i=1:19
   LookUp(25+i,1)=LookUp(25,1)+2.5/6*i;
end
%--------------------------------------------------------------------------
zl1(1:44,1)=LookUp(:,1);
zl1(1:19,2)=LookUpTorqzoj1(1:19,1);
zl1(20:44,2)=LookUpTorqzoj(:,1);

zl2(1:44,1)=LookUp(:,1);
zl2(1:19,2)=LookUpTorqzoj1(1:19,2);
zl2(20:44,2)=LookUpTorqzoj(:,2);

zl3(1:44,1)=LookUp(:,1);
zl3(1:19,2)=LookUpTorqzoj1(1:19,3);
zl3(20:44,2)=LookUpTorqzoj(:,3);

zr1(1:44,1)=LookUp(:,1);
zr1(1:19,2)=-LookUpTorqzoj1(1:19,1);
zr1(20:44,2)=-LookUpTorqzoj(:,1);

zr2(1:44,1)=LookUp(:,1);
zr2(1:19,2)=-LookUpTorqzoj1(1:19,2);
zr2(20:44,2)=-LookUpTorqzoj(:,2);

zr3(1:44,1)=LookUp(:,1);
zr3(1:19,2)=-LookUpTorqzoj1(1:19,3);
zr3(20:44,2)=-LookUpTorqzoj(:,3);
%--------------------------------------------------------------------------

fl1(1:44,1)=LookUp(:,1);
fl1(1:25,2)=LookUpTorq(:,1);
fl1(26:44,2)=LookUpTorq1(1:19,1);
fl2(1:44,1)=LookUp(:,1);
fl2(1:25,2)=LookUpTorq(:,2);
fl2(26:44,2)=LookUpTorq1(1:19,2);
fl3(1:44,1)=LookUp(:,1);
fl3(1:25,2)=LookUpTorq(:,3);
fl3(26:44,2)=LookUpTorq1(1:19,3);

fr1(1:44,1)=LookUp(:,1);
fr1(1:25,2)=-LookUpTorq(:,1);
fr1(26:44,2)=-LookUpTorq1(1:19,1);
fr2(1:44,1)=LookUp(:,1);
fr2(1:25,2)=-LookUpTorq(:,2);
fr2(26:44,2)=-LookUpTorq1(1:19,2);
fr3(1:44,1)=LookUp(:,1);
fr3(1:25,2)=-LookUpTorq(:,3);
fr3(26:44,2)=-LookUpTorq1(1:19,3);

%--------------------------------------------------------------------------
%Foot Number 1,3,5
od1l=[LookUp(1:25,1) LookUpTeta{1}(:,1)];
od1li=[LookUp(1:25,1) LookUpTeta{1}(:,2)];
od1lii=[LookUp(1:25,1) LookUpTeta{1}(:,3)];
od2l=[LookUp(1:25,1) LookUpTeta{2}(:,1)];
od2li=[LookUp(1:25,1) LookUpTeta{2}(:,2)];
od2lii=[LookUp(1:25,1) LookUpTeta{2}(:,3)];
od3l=[LookUp(1:25,1) LookUpTeta{3}(:,1)];
od3li=[LookUp(1:25,1) LookUpTeta{3}(:,2)];
od3lii=[LookUp(1:25,1) LookUpTeta{3}(:,3)];
od1r=[LookUp(1:25,1) -LookUpTeta{1}(:,1)];
od1ri=[LookUp(1:25,1) -LookUpTeta{1}(:,2)];
od1rii=[LookUp(1:25,1) -LookUpTeta{1}(:,3)];
od2r=[LookUp(1:25,1) -LookUpTeta{2}(:,1)];
od2ri=[LookUp(1:25,1) -LookUpTeta{2}(:,2)];
od2rii=[LookUp(1:25,1) -LookUpTeta{2}(:,3)];
od3r=[LookUp(1:25,1) -LookUpTeta{3}(:,1)];
od3ri=[LookUp(1:25,1) -LookUpTeta{3}(:,2)];
od3rii=[LookUp(1:25,1) -LookUpTeta{3}(:,3)];
%--------------------------------------------------------------------------
%Foot Number 2,4,6
zoj1l=[7.5+LookUp(1:25,1) LookUpTetazoj{1}(1:25,1)];
zoj1li=[7.5+LookUp(1:25,1) LookUpTetazoj{1}(1:25,2)];
zoj1lii=[7.5+LookUp(1:25,1) LookUpTetazoj{1}(1:25,3)];
zoj2l=[7.5+LookUp(1:25,1) LookUpTetazoj{2}(1:25,1)];
zoj2li=[7.5+LookUp(1:25,1) LookUpTetazoj{2}(1:25,2)];
zoj2lii=[7.5+LookUp(1:25,1) LookUpTetazoj{2}(1:25,3)];
zoj3l=[7.5+LookUp(1:25,1) LookUpTetazoj{3}(1:25,1)];
zoj3li=[7.5+LookUp(1:25,1) LookUpTetazoj{3}(1:25,2)];
zoj3lii=[7.5+LookUp(1:25,1) LookUpTetazoj{3}(1:25,3)];
zoj1r=[7.5+LookUp(1:25,1) -LookUpTetazoj{1}(1:25,1)];
zoj1ri=[7.5+LookUp(1:25,1) -LookUpTetazoj{1}(1:25,2)];
zoj1rii=[7.5+LookUp(1:25,1) -LookUpTetazoj{1}(1:25,3)];
zoj2r=[7.5+LookUp(1:25,1) -LookUpTetazoj{2}(1:25,1)];
zoj2ri=[7.5+LookUp(1:25,1) -LookUpTetazoj{2}(1:25,2)];
zoj2rii=[7.5+LookUp(1:25,1) -LookUpTetazoj{2}(1:25,3)];
zoj3r=[7.5+LookUp(1:25,1) -LookUpTetazoj{3}(1:25,1)];
zoj3ri=[7.5+LookUp(1:25,1) -LookUpTetazoj{3}(1:25,2)];
zoj3rii=[7.5+LookUp(1:25,1) -LookUpTetazoj{3}(1:25,3)];
%--------------------------------------------------------------------------
fsx=[LookUp(1:25,1),LookUpForce(:,2)];
fsy=[LookUp(1:25,1),LookUpForce(:,1)];
fszx=[LookUp(1:25,1),LookUpForcezoj(:,2)];
fszy=[LookUp(1:25,1),LookUpForcezoj(:,1)];
%--------------------------------------------------------------------------
%Foot Number 1,3,5
%for i=1:nAT*(NP-1)+11
%    aa(i,1)=LookUp(i,1);
%    aa(i,2)=LookUp(i,5);
    
%end
% for i=1:nAT*(NP-1)+11
%    bb(i,1)=LookUp(i,1);
    
%    bb(i,2)=LookUp(i,6);
    
%end
%for i=1:nAT*(NP-1)+11
%    cc(i,1)=LookUp(i,1);
    
%    cc(i,2)=LookUp(i,7);
    
%end
%--------------------------------------------------------------------------
%Foot Number odd
%for i=1:nAT*(NP-1)+11
%    dd(i,1)=LookUp(i,1);
   
%    dd(i,2)=-LookUp(i,5);
   
%end
%for i=1:nAT*(NP-1)+11
%    ee(i,1)=LookUp(i,1);
    
%    ee(i,2)=-LookUp(i,6);
  
   
%end
%for i=1:nAT*(NP-1)+11
%    ff(i,1)=LookUp(i,1);
   
%    ff(i,2)=-LookUp(i,7);
%end
 
%--------------------------------------------------------------------------
%Foot Number odd
% for i=1:nAT*(NP-1)+11
%    zz(i,1)=LookUp(i,1);
   
%    zz(i,2)=LookUp1(i,5);
   
%end
%for i=1:nAT*(NP-1)+11
%    xx(i,1)=LookUp(i,1);
    
%    xx(i,2)=LookUp1(i,6);
  
   
%end
%for i=1:nAT*(NP-1)+11
%    vv(i,1)=LookUp(i,1);
   
%    vv(i,2)=LookUp1(i,7);
%end
 %-------------------------------------------------------------------------
%  for i=1:nAT*(NP-1)+11
%    jj(i,1)=LookUp(i,1);
   
%    jj(i,2)=-LookUp1(i,5);
   
%end
%for i=1:nAT*(NP-1)+11
%    kk(i,1)=LookUp(i,1);
    
%    kk(i,2)=-LookUp1(i,6);
  
  
%end
%for i=1:nAT*(NP-1)+11
%    ll(i,1)=LookUp(i,1);
   
%    ll(i,2)=-LookUp1(i,7);
%end
disp('Finish.');