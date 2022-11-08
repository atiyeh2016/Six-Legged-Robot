function p=path()
global nAP Pos0 Posf dxf dyf dzf dtf1 dtf2 dtf3 Teta TetaError TetaGess NP pathname;

switch pathname
%--------------------------------------------------------------------------
    case('soosk')
        for i=1:nAP
            Teta(0*nAP+i,:)=TetaGess+[0 dtf2/(nAP-1)*(i-1) dtf3/(nAP-1)*(i-1)];
        end
        for i=1:nAP-1
            Teta(1*nAP+i,:)=Teta(nAP,:)+[dtf1/(nAP-1)*i 0 0];
        end
        for i=1:nAP-1
            Teta(2*nAP+i-1,:)=Teta(2*nAP-1,:)-[0 dtf2/(nAP-1)*(i) dtf3/(nAP-1)*(i)];
        end
        for i=1:nAP-1
            Teta(3*nAP+i-2,:)=Teta(3*nAP-2,:)-[dtf1/(nAP-1)*i 0 0];
        end
        
        NP=4*nAP-3;
end
    