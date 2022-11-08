function T=traject(t)
global nAP nAT Teta tf LookUpTeta Time NP  LookUpTetazoj Tetazoj 
syms t
for i=1:3
    for k=1:NP-1
        x1=Teta(k,i);
        v1=0;
        a1=0;
        
        x2=Teta(k+1,i);
        v2=0;
        a2=0;
        
A=[1 0 0 0 0 0;
   0 1 0 0 0 0;
   0 0 2 0 0 0;
   1 tf tf^2 tf^3 tf^4 tf^5;
   0 1 2*tf^1 3*tf^2 4*tf^3 5*tf^4;
   0 0 2 6*tf^1 12*tf^2 20*tf^3];
B=[x1;
   v1;
   a1;
   x2;
   v2;
   a2];
            a=(A^-1*B).';
        Z=a(1)*t^0+a(2)*t^1+a(3)*t^2+a(4)*t^3+a(5)*t^4+a(6)*t^5;
      for j=1:nAT+1
          Time(nAT*(k-1)+j)=tf*(k-1)+tf/nAT*(j-1);
          RR(1,nAT*(k-1)+j)=subs(diff(Z,t,0),t,tf/nAT*(j-1));
          RR(2,nAT*(k-1)+j)=subs(diff(Z,t,1),t,tf/nAT*(j-1));
          RR(3,nAT*(k-1)+j)=subs(diff(Z,t,2),t,tf/nAT*(j-1));   
      end
      LookUpTeta{i}=RR';
    end
end
Tetazoj=[0 -pi/4 -pi/8;-pi/12 -pi/4 -pi/8;-pi/12 -pi/8 -pi/4;0 -pi/8 -pi/4;0 -pi/4 -pi/8];
for i=1:3
    for k=1:NP-1
        x1=Tetazoj(k,i);
        v1=0;
        a1=0;
        
        x2=Tetazoj(k+1,i);
        v2=0;
        a2=0;
        
A=[1 0 0 0 0 0;
   0 1 0 0 0 0;
   0 0 2 0 0 0;
   1 tf tf^2 tf^3 tf^4 tf^5;
   0 1 2*tf^1 3*tf^2 4*tf^3 5*tf^4;
   0 0 2 6*tf^1 12*tf^2 20*tf^3];
B=[x1;
   v1;
   a1;
   x2;
   v2;
   a2];
            a=(A^-1*B).';
        Z=a(1)*t^0+a(2)*t^1+a(3)*t^2+a(4)*t^3+a(5)*t^4+a(6)*t^5;
      for j=1:nAT+1
          Time(nAT*(k-1)+j)=tf*(k-1)+tf/nAT*(j-1);
          RR(1,nAT*(k-1)+j)=subs(diff(Z,t,0),t,tf/nAT*(j-1));
          RR(2,nAT*(k-1)+j)=subs(diff(Z,t,1),t,tf/nAT*(j-1));
          RR(3,nAT*(k-1)+j)=subs(diff(Z,t,2),t,tf/nAT*(j-1));   
      end
      LookUpTetazoj{i}=RR';
    end
end
for i=1:10
     LookUpTetazoj{1}(25+i,1)=LookUpTetazoj{1}(25,1);
    LookUpTetazoj{2}(25+i,1)=LookUpTetazoj{2}(25,1);
    LookUpTetazoj{3}(25+i,1)=LookUpTetazoj{3}(25,1);
end