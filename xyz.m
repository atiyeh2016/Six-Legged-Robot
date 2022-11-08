function F=xyz(x)
global P Pos;
F(1)=-sin(x(1))*(cos(x(3)+x(2))*L(3)+cos(x(2))*L(2)+L(1))-Pos(1);
F(2)=+cos(x(1))*(cos(x(3)+x(2))*L(3)+cos(x(2))*L(2)+L(1))-Pos(2);
F(3)=+sin(x(3)+x(2))*L(3)+sin(x(2))*L(2)-Pos(3);
End
