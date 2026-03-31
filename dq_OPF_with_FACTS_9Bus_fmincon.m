function dq_PowerFlow_with_FACTS_fmincon_9BUS_modified_RoyaltyChihava

%% 
clc
nN=9; %Number of nodes
nB=9; %Number of branches
Sb = 100;
ZLdT1pu=(0.0+0.0576j);
ZLdT2pu=(0.0+0.0625j);
ZLdT3pu=(0.0+0.0586j);
ZLdT4pu=(0.01+0.085j);
ZLdT5pu=(0.017+0.092j);
ZLdT6pu=(0.032+0.161j);
ZLdT7pu=(0.039+0.17j);
ZLdT8pu=(0.0085+0.072j);
ZLdT9pu=(0.0119+0.1008j);

%% branch data
% 1 - fbus - “from” bus number
% 2 - tbus - “to” bus number
% 3 - r - resistance (p.u.)
% 4 - x - reactance (p.u.)
% 5 - b - total line charging susceptance (p.u.)
% 6 - rating – p.u. rating ("A”, long term rating), set to 0 for unlimited
% 7 - tap - transformer tap
linedata = [
	1	4	0	    0.0576	    0   250;
    2	7	0	    0.0625	    0   250;
    3	9	0	    0.0586	    0   300;
    4	5	0.01	0.085	0.088   250;
	4	6	0.017	0.092	0.079   250;
    5	7	0.032	0.161	0.153   250;
	6	9	0.039	0.17	0.179   150;
	7	8	0.0085	0.072	0.0745  250;
	8	9	0.0119	0.1008	0.1045  150;
];
%total shunt impedance on the left side of the line
linedataL = [
	1	4	0	    0.0576	    0   250;
    2	7	0	    0.0625	    0   250;
    3	9	0	    0.0586	    0   300;
    4	5	0.01	0.085	0.167   250;
	4	6	0.017	0.092	0.167   250;
    5	7	0.032	0.161	0.241   250;
	6	9	0.039	0.17	0.258   150;
	7	8	0.0085	0.072	0.2275  250;
	8	9	0.0119	0.1008	0.179   150;
];
%total shunt impedance on the right side of the line
linedataR = [
	1	4	0	    0.0576	    0   250;
    2	7	0	    0.0625	    0   250;
    3	9	0	    0.0586	    0   300;
    4	5	0.01	0.085	0.241   250;
	4	6	0.017	0.092	0.258   250;
    5	7	0.032	0.161	0.2275  250;
	6	9	0.039	0.17	0.2835  150;
	7	8	0.0085	0.072	0.179   250;
	8	9	0.0119	0.1008	0.2835  150;
];
   
ZshdT1pu = 1e4 + 1j*1e4;                                                    %disable line shunt impedance for the first 3 lines
ZshdT2pu = 1e4 + 1j*1e4;
ZshdT3pu = 1e4 + 1j*1e4;
ZshdT4pu = 1/(1j*linedata(4,5)); 
ZshdT5pu = 1/(1j*linedata(5,5));
ZshdT6pu = 1/(1j*linedata(6,5));
ZshdT7pu = 1/(1j*linedata(7,5));
ZshdT8pu = 1/(1j*linedata(8,5));
ZshdT9pu = 1/(1j*linedata(9,5));

ZshdL1pu = ZshdT1pu;              ZshdLL1pu = ZshdL1pu;                     %disable line shunt impedance for the first 3 lines
ZshdL2pu = ZshdT2pu;              ZshdLL2pu = ZshdL2pu;
ZshdL3pu = ZshdT3pu;              ZshdLL3pu = ZshdL3pu;
ZshdL4pu = 1/(1j*linedataL(4,5)); ZshdLL4pu = (ZshdT4pu/ZshdL4pu)* ZshdL4pu;
ZshdL5pu = 1/(1j*linedataL(5,5)); ZshdLL5pu = (ZshdT5pu/ZshdL5pu)* ZshdL5pu;
ZshdL6pu = 1/(1j*linedataL(6,5)); ZshdLL6pu = (ZshdT6pu/ZshdL6pu)* ZshdL6pu;
ZshdL7pu = 1/(1j*linedataL(7,5)); ZshdLL7pu = (ZshdT7pu/ZshdL7pu)* ZshdL7pu;
ZshdL8pu = 1/(1j*linedataL(8,5)); ZshdLL8pu = (ZshdT8pu/ZshdL8pu)* ZshdL8pu;
ZshdL9pu = 1/(1j*linedataL(9,5)); ZshdLL9pu = (ZshdT9pu/ZshdL9pu)* ZshdL9pu;

ZshdR1pu = ZshdT1pu;              ZshdLR1pu = ZshdR1pu;                     %disable line shunt impedance for the first 3 lines
ZshdR2pu = ZshdT2pu;              ZshdLR2pu = ZshdR2pu;
ZshdR3pu = ZshdT3pu;              ZshdLR3pu = ZshdR3pu;
ZshdR4pu = 1/(1j*linedataR(4,5)); ZshdLR4pu = (ZshdT4pu/ZshdR4pu)* ZshdR4pu;
ZshdR5pu = 1/(1j*linedataR(5,5)); ZshdLR5pu = (ZshdT5pu/ZshdR5pu)* ZshdR5pu;
ZshdR6pu = 1/(1j*linedataR(6,5)); ZshdLR6pu = (ZshdT6pu/ZshdR6pu)* ZshdR6pu;
ZshdR7pu = 1/(1j*linedataR(7,5)); ZshdLR7pu = (ZshdT7pu/ZshdR7pu)* ZshdR7pu;
ZshdR8pu = 1/(1j*linedataR(8,5)); ZshdLR8pu = (ZshdT8pu/ZshdR8pu)* ZshdR8pu;
ZshdR9pu = 1/(1j*linedataR(9,5)); ZshdLR9pu = (ZshdT9pu/ZshdR9pu)* ZshdR9pu;

%Here we initialize the maximun an minimun values of the voltage and
%current and we wrap the angle between +-pi
Vmax_st=1.2;
Vmin_st=0;
Imax_st=1.2;
Imin_st=0;
thetamax_st=pi;
thetamin_st=-pi;

Vse_max=1.2;
Vse_min=0;
Ise_max=1.2;
Ise_min=0;
phise_min=-pi;
phise_max=pi;

Gamma=[1 0 0 -1 0 0 0 0 0;0 1 0 0 0 0 -1 0 0; 0 0 1 0 0 0 0 0 -1; 0 0 0 1 -1 0 0 0 0; 0 0 0 1 0 -1 0 0 0; 0 0 0 0 1 0 -1 0 0; 0 0 0 0 0 1 0 0 -1; 0 0 0 0 0 0 1 -1 0; 0 0 0 0 0 0 0 1 -1];
Gamma_sh_L = zeros(nB,nN);
Gamma_sh_R = zeros(nB,nN);

for r0 = 1:nB
    for c0 = 1:nN
        if Gamma(r0,c0)== 1
            Gamma_sh_L(r0,c0) = 1;
        else
            Gamma_sh_L(r0,c0) = 0;
        end
    end
end

for r1 = 1:nB
    for c1 = 1:nN
        if Gamma(r1,c1)== -1
            Gamma_sh_R(r1,c1) = 1;
        else
            Gamma_sh_R(r1,c1) = 0;
        end
    end
end

RL=[real(ZLdT1pu);real(ZLdT2pu) ;real(ZLdT3pu) ;real(ZLdT4pu) ;real(ZLdT5pu) ;real(ZLdT6pu) ;real(ZLdT7pu) ;real(ZLdT8pu) ;real(ZLdT9pu)];
XL=[imag(ZLdT1pu);imag(ZLdT2pu) ;imag(ZLdT3pu) ;imag(ZLdT4pu) ;imag(ZLdT5pu) ;imag(ZLdT6pu) ;imag(ZLdT7pu) ;imag(ZLdT8pu) ;imag(ZLdT9pu)];

Rse=zeros(nB,1);
Xse=zeros(nB,1);
Rsh=1e4*ones(nN,1);
Xsh=1e4*ones(nN,1);
RLshL= [real(ZshdLL1pu);real(ZshdLL2pu) ;real(ZshdLL3pu) ;real(ZshdLL4pu) ;real(ZshdLL5pu) ;real(ZshdLL6pu) ;real(ZshdLL7pu) ;real(ZshdLL8pu) ;real(ZshdLL9pu)];
XCshL= -1*[imag(ZshdLL1pu);imag(ZshdLL2pu) ;imag(ZshdLL3pu) ;imag(ZshdLL4pu) ;imag(ZshdLL5pu) ;imag(ZshdLL6pu) ;imag(ZshdLL7pu) ;imag(ZshdLL8pu) ;imag(ZshdLL9pu)];
RLshR= [real(ZshdLR1pu);real(ZshdLR2pu) ;real(ZshdLR3pu) ;real(ZshdLR4pu) ;real(ZshdLR5pu) ;real(ZshdLR6pu) ;real(ZshdLR7pu) ;real(ZshdLR8pu) ;real(ZshdLR9pu)];
XCshR= -1*[imag(ZshdLR1pu);imag(ZshdLR2pu) ;imag(ZshdLR3pu) ;imag(ZshdLR4pu) ;imag(ZshdLR5pu) ;imag(ZshdLR6pu) ;imag(ZshdLR7pu) ;imag(ZshdLR8pu) ;imag(ZshdLR9pu)];

iBd=zeros(1,nB);
iBq=zeros(1,nB);
ishd=zeros(1,nN);
ishq=zeros(1,nN);
ishdLL=zeros(1,nB);
ishqLL=zeros(1,nB);
ishdLR=zeros(1,nB);
ishqLR=zeros(1,nB);
iNd=zeros(1,nN);
iNq=zeros(1,nN);
esed=zeros(1,nB);
eseq=zeros(1,nB);
eshd=zeros(1,nN);
eshq=zeros(1,nN);
vd=ones(1,nN);
vq=ones(1,nN);

Rsh(8)=0;     %No Losses                         
Xsh(8)=0.01;  % 1% reactance

Rse(4)=0;
Xse(4)=0.01;

esed(4)=1e-5;                                             

X=[iBd iBq ishd ishq ishdLL ishqLL ishdLR ishqLR iNd iNq esed eseq eshd eshq vd vq];

aux1=horzcat(blkdiag([diag(Rse+RL) -diag(Xse+XL); diag(Xse+XL) diag(Rse+RL)], [diag(Rsh) -diag(Xsh); diag(Xsh) diag(Rsh)], [diag(RLshL) diag(XCshL); -diag(XCshL) diag(RLshL)],[diag(RLshR) diag(XCshR); -diag(XCshR) diag(RLshR)]),zeros(6*nB+2*nN,2*nN));
aux2=horzcat(blkdiag(transpose(Gamma),transpose(Gamma)),blkdiag(diag(ones(1,nN)),diag(ones(1,nN))),blkdiag(transpose(Gamma_sh_L),transpose(Gamma_sh_L)),blkdiag(transpose(Gamma_sh_R),transpose(Gamma_sh_R)),blkdiag(-diag(ones(1,nN)),-diag(ones(1,nN))));
aux3=vertcat(horzcat(vertcat(blkdiag(diag(ones(1,nB)),diag(ones(1,nB)),diag(ones(1,nN)),diag(ones(1,nN))),zeros(4*nB,2*nB + 2*nN)),vertcat(blkdiag(-Gamma,-Gamma),blkdiag(-diag(ones(1,nN)),-diag(ones(1,nN))),blkdiag(-Gamma_sh_L,-Gamma_sh_L),blkdiag(-Gamma_sh_R,-Gamma_sh_R))),zeros(2*nN, 2*nB+4*nN));


M=horzcat(vertcat(aux1,aux2),aux3);
%% 

% Variable Initialization
P=[0,1.63,0.85, 0, -1.25, -0.9, 0, -1, 0];
Q=[0,0,0,0,-0.5 ,-0.3,0,-0.35,0];
V=[1.04,1.025,1.025,1, 1, 1, 1, 1, 1];
del=[0,0,0,0,0,0,0,0,0];

A=[]; Aeq=M; b=[]; beq=zeros(length(M(:,1)),1); 
lb=-3*ones(size(X))';
ub=3*ones(size(X))'; 

options=optimset('MaxFunEvals',10e6,'MaxIter',10e4,'Display','Iter','TolX',1e-5,'TolFun',1e-5);
[SOL,fval,exitflag]=fmincon(@myfun,X,A,b,Aeq,beq,lb,ub,@mycon,options);

 exitflag
    iBd= SOL(1:nB);
    iBq= SOL(nB+1:2*nB);
    ishd=SOL(2*nB+1:2*nB+nN);
    ishq=SOL(2*nB+nN+1:2*nB+2*nN);
    ishdLL=SOL(2*nB+2*nN+1:3*nB+2*nN);
    ishqLL=SOL(3*nB+2*nN+1:4*nB+2*nN);
    ishdLR=SOL(4*nB+2*nN+1:5*nB+2*nN);
    ishqLR=SOL(5*nB+2*nN+1:6*nB+2*nN);
    iNd= SOL(6*nB+2*nN+1:6*nB+3*nN);
    iNq= SOL(6*nB+3*nN+1:6*nB+4*nN);
    esed=SOL(6*nB+4*nN+1:7*nB+4*nN);
    eseq=SOL(7*nB+4*nN+1:8*nB+4*nN);
    eshd=SOL(8*nB+4*nN+1:8*nB+5*nN);
    eshq=SOL(8*nB+5*nN+1:8*nB+6*nN);
    vd= SOL(8*nB+6*nN+1:8*nB+7*nN);
    vq= SOL(8*nB+7*nN+1:8*nB+8*nN);

vd
vq

V = sqrt(vd.^2+vq.^2)
del=(180/pi)*atan(vq./vd)
IB = sqrt(iBd.^2+iBq.^2);
IN = sqrt(iNd.^2+iNq.^2);

for i=1:nB
    for j=1:nN
        PB(i,j)=iBd(i)*vd(j)*Gamma(i,j)+iBq(i)*vq(j)*Gamma(i,j);
        QB(i,j)=iBd(i)*vq(j)*Gamma(i,j)-iBq(i)*vd(j)*Gamma(i,j);
        QBshL(i,j)=ishdLL(i)*vq(j)*Gamma_sh_L(i,j)-ishqLL(i)*vd(j)*Gamma_sh_L(i,j);
        QBshR(i,j)=ishdLR(i)*vq(j)*Gamma_sh_R(i,j)-ishqLR(i)*vd(j)*Gamma_sh_R(i,j);
       
    end
end
SB=PB+1j*QB+(-1j)*QBshL+(-1j)*QBshR;
Losses=sum(SB,'all');

Loss_P=real(Losses);
Loss_Q=imag(Losses);

P1=((vd(1)*iNd(1) + (vq(1)*iNq(1)))*Sb)
P2=((vd(2)*iNd(2)) + (vq(2)*iNq(2))*Sb)
P3=((vd(3)*iNd(3)) + (vq(3)*iNq(3))*Sb)
P4=((P(5) + P(6) + P(8))*Sb)
PLosses = Loss_P*Sb;

Qsh1 = abs(eshq(8)*ishd(8)-eshd(8)*ishq(8))
Qse1 = abs(eseq(4)*iBd(4)-esed(4)*iBq(4))

C_1=100+10.5*P1;
C_2=110+9.85*P2;
C_3=100+10*P3;
C_4 = 10*PLosses;
SerC = (25 + (4*Qse1));
ShunC = (50 + (5*Qsh1));

C=C_1+C_2 + C_3 + C_4  + ShunC + SerC

Pi=vd.*iNd+vq.*iNq
Qi=vq.*iNd-vd.*iNq

Pstat_1=eshd(8)*ishd(8)+eshq(8)*ishq(8)
Qstat_1=eshq(8)*ishd(8)-eshd(8)*ishq(8)     

Pse_1=(esed(4)*iBd(4)+eseq(4)*iBq(4))*1     
Qse_1=(eseq(4)*iBd(4)-esed(4)*iBq(4))*1

P_14=vd(1)*iBd(1)+vq(1)*iBq(1); Q_14=vq(1)*iBd(1)-vd(1)*iBq(1);
P_27=vd(2)*iBd(2)+vq(2)*iBq(2); Q_27=vq(2)*iBd(2)-vd(2)*iBq(2);
P_39=vd(3)*iBd(3)+vq(3)*iBq(3); Q_39=vq(3)*iBd(3)-vd(3)*iBq(3);
P_45=vd(4)*iBd(4)+vq(4)*iBq(4); Q_45=vq(4)*iBd(4)-vd(4)*iBq(4);
P_46=vd(5)*iBd(5)+vq(5)*iBq(5); Q_46=vq(5)*iBd(5)-vd(5)*iBq(5);
P_57=vd(6)*iBd(6)+vq(6)*iBq(6); Q_57=vq(6)*iBd(6)-vd(6)*iBq(6);
P_69=vd(7)*iBd(7)+vq(7)*iBq(7); Q_69=vq(7)*iBd(7)-vd(7)*iBq(7);
P_78=vd(8)*iBd(8)+vq(8)*iBq(8); Q_78=vq(8)*iBd(8)-vd(8)*iBq(8);
P_89=vd(9)*iBd(9)+vq(9)*iBq(9); Q_89=vq(9)*iBd(9)-vd(9)*iBq(9);

S_14 = abs(P_14+(1*j*Q_14))
S_27 = abs(P_27+(1*j*Q_27))
S_39 = abs(P_39+(1*j*Q_39))
S_45 = abs(P_45+(1*j*Q_45))
S_46 = abs(P_46+(1*j*Q_46))
S_57 = abs(P_57+(1*j*Q_57))
S_69 = abs(P_69+(1*j*Q_69))
S_78 = abs(P_78+(1*j*Q_78))
S_89 = abs(P_89+(1*j*Q_89))

function C=myfun(X)

    iBd= X(1:nB);
    iBq= X(nB+1:2*nB);
    ishd=X(2*nB+1:2*nB+nN);
    ishq=X(2*nB+nN+1:2*nB+2*nN);
    ishdLL=X(2*nB+2*nN+1:3*nB+2*nN);
    ishqLL=X(3*nB+2*nN+1:4*nB+2*nN);
    ishdLR=X(4*nB+2*nN+1:5*nB+2*nN);
    ishqLR=X(5*nB+2*nN+1:6*nB+2*nN);
    iNd= X(6*nB+2*nN+1:6*nB+3*nN);
    iNq= X(6*nB+3*nN+1:6*nB+4*nN);
    esed=X(6*nB+4*nN+1:7*nB+4*nN);
    eseq=X(7*nB+4*nN+1:8*nB+4*nN);
    eshd=X(8*nB+4*nN+1:8*nB+5*nN);
    eshq=X(8*nB+5*nN+1:8*nB+6*nN);
    vd= X(8*nB+6*nN+1:8*nB+7*nN);
    vq= X(8*nB+7*nN+1:8*nB+8*nN);

for i=1:nB
    for j=1:nN
        PB(i,j)=iBd(i)*vd(j)*Gamma(i,j)+iBq(i)*vq(j)*Gamma(i,j);
        QB(i,j)=iBd(i)*vq(j)*Gamma(i,j)-iBq(i)*vd(j)*Gamma(i,j);
        QBshL(i,j)=ishdLL(i)*vq(j)*Gamma_sh_L(i,j)-ishqLL(i)*vd(j)*Gamma_sh_L(i,j);
        QBshR(i,j)=ishdLR(i)*vq(j)*Gamma_sh_R(i,j)-ishqLR(i)*vd(j)*Gamma_sh_R(i,j);
       
    end
end
SB=PB+1j*QB+(-1j)*QBshL+(-1j)*QBshR;
Losses=sum(SB,'all');

Loss_P=real(Losses);
Loss_Q=imag(Losses);

P1=((vd(1)*iNd(1) + (vq(1)*iNq(1)))*Sb);
P2=((vd(2)*iNd(2)) + (vq(2)*iNq(2))*Sb);
P3=((vd(3)*iNd(3)) + (vq(3)*iNq(3))*Sb);
P4=((P(5) + P(6) + P(8))*Sb);
PLosses = Loss_P*Sb;

Qsh1 = abs(eshq(8)*ishd(8)- eshd(8)*ishq(8));
Qse1 = abs(eseq(4)*iBd(4)-esed(4)*iBq(4));

C_1=100+10.5*P1;
C_2=110+9.85*P2;
C_3=100+10*P3;
C_4 = 10*PLosses;
SerC = (25 + (4*Qse1));
ShunC = (50 + (5*Qsh1));

C=C_1+C_2 + C_3 + C_4  + ShunC + SerC;

end


function [c,ceq]=mycon(X)

    iBd= X(1:nB);
    iBq= X(nB+1:2*nB);
    ishd=X(2*nB+1:2*nB+nN);
    ishq=X(2*nB+nN+1:2*nB+2*nN);
    ishdLL=X(2*nB+2*nN+1:3*nB+2*nN);
    ishqLL=X(3*nB+2*nN+1:4*nB+2*nN);
    ishdLR=X(4*nB+2*nN+1:5*nB+2*nN);
    ishqLR=X(5*nB+2*nN+1:6*nB+2*nN);
    iNd= X(6*nB+2*nN+1:6*nB+3*nN);
    iNq= X(6*nB+3*nN+1:6*nB+4*nN);
    esed=X(6*nB+4*nN+1:7*nB+4*nN);
    eseq=X(7*nB+4*nN+1:8*nB+4*nN);
    eshd=X(8*nB+4*nN+1:8*nB+5*nN);
    eshq=X(8*nB+5*nN+1:8*nB+6*nN);
    vd= X(8*nB+6*nN+1:8*nB+7*nN);
    vq= X(8*nB+7*nN+1:8*nB+8*nN);

r=1;

%Slack
FBT(r,1)=vd(1)-V(1);     r=r+1;
FBT(r,1)=vq(1);          r=r+1;

%PV bus specified variables

%FBT(r,1)=vd(2)*iNd(2)+vq(2)*iNq(2)-P(2);      r=r+1;
FBT(r,1)=sqrt((vd(2)^2+vq(2)^2))-V(2);        r=r+1;
%FBT(r,1)=vd(3)*iNd(3)+vq(3)*iNq(3)-P(3);      r=r+1;
FBT(r,1)=sqrt((vd(3)^2+vq(3)^2))-V(3);        r=r+1;

%PQ bus specified variables
FBT(r,1)=vd(4)*iNd(4)+vq(4)*iNq(4);      r=r+1;
FBT(r,1)=vq(4)*iNd(4)-vd(4)*iNq(4);      r=r+1;
FBT(r,1)=vd(5)*iNd(5)+vq(5)*iNq(5)-P(5);      r=r+1;
FBT(r,1)=vq(5)*iNd(5)-vd(5)*iNq(5)-(Q(5));      r=r+1;
FBT(r,1)=vd(6)*iNd(6)+vq(6)*iNq(6)-P(6);      r=r+1;
FBT(r,1)=vq(6)*iNd(6)-vd(6)*iNq(6)-(Q(6));      r=r+1;
FBT(r,1)=vd(7)*iNd(7)+vq(7)*iNq(7);      r=r+1;
FBT(r,1)=vq(7)*iNd(7)-vd(7)*iNq(7);      r=r+1;
FBT(r,1)=vd(8)*iNd(8)+vq(8)*iNq(8)-P(8);      r=r+1;
FBT(r,1)=vq(8)*iNd(8)-vd(8)*iNq(8)-(Q(8));      r=r+1;
FBT(r,1)=vd(9)*iNd(9)+vq(9)*iNq(9);      r=r+1;
FBT(r,1)=vq(9)*iNd(9)-vd(9)*iNq(9);      r=r+1;

%FSE=[esed'; eseq'];
%FSH=[eshd'; eshq'];

FSE=[esed(1);eseq(1);esed(2);eseq(2);esed(3);eseq(3);esed(5);eseq(5);esed(6);eseq(6);esed(7);eseq(7);esed(8);eseq(8);esed(9);eseq(9)];

FSH=[eshd(1);eshq(1);eshd(2);eshq(2);eshd(3);eshq(3);eshd(4);eshq(4);eshd(5);eshq(5);eshd(6);eshq(6);eshd(7);eshq(7);eshd(9);eshq(9)];

% %STATCOM constraints

% % STATCOM Active Power forced to be 0
FSTAT(1,1)=eshd(8)*ishd(8)+eshq(8)*ishq(8);        

% %SSSC constraints
% % SSSC Active Power forced to be 0
FSSC(1,1)=esed(4)*iBd(4)+eseq(4)*iBq(4); %Active Power of the SSSC=0         

%equality constraints column vector
ceq=[FBT;FSH;FSTAT;FSE;FSSC];
%ceq=[FBT;FSH;FSTAT];


p=1;

%STATCOM Limits
c(p)=abs(eshd(8)+1j*eshq(8))-Vmax_st;p=p+1;
c(p)=-abs(eshd(8)+1j*eshq(8))+Vmin_st;p=p+1;
c(p)=abs(ishd(8)+1j*ishq(8))-Imax_st;p=p+1;
c(p)=-abs(ishd(8)+1j*ishq(8))+Imin_st;p=p+1;                       
c(p)=angle(eshd(8)+1j*eshq(8))-thetamax_st;p=p+1;
c(p)=-angle(eshd(8)+1j*eshq(8))+thetamin_st;p=p+1;

% SSSC limits

c(p)=sqrt(esed(4)^2+eseq(4)^2)-Vse_max;p=p+1;
c(p)=-sqrt(esed(4)^2+eseq(4)^2)+Vse_min;p=p+1;
c(p)=sqrt(iBd(4)^2+iBq(4)^2)-Ise_max;p=p+1;
c(p)=-sqrt(iBd(4)^2+iBq(4)^2)+Ise_min;p=p+1;                       
c(p)=atan(eseq(4)/esed(4))-phise_max;p=p+1;
c(p)=-atan(eseq(4)/esed(4))+phise_min;p=p+1;


c(p)=abs((vd(1)*iBd(1)+vq(1)*iBq(1))+ (1j*(vq(1)*iBd(1)-vd(1)*iBq(1))))-(250/Sb); p =p+1;
c(p)=abs((vd(2)*iBd(2)+vq(2)*iBq(2))+ (1j*(vq(2)*iBd(2)-vd(2)*iBq(2))))-(250/Sb); p =p+1;
c(p)=abs((vd(3)*iBd(3)+vq(3)*iBq(3))+ (1j*(vq(3)*iBd(3)-vd(3)*iBq(3))))-(300/Sb); p =p+1;
c(p)=abs((vd(4)*iBd(4)+vq(4)*iBq(4))+ (1j*(vq(4)*iBd(4)-vd(4)*iBq(4))))-(250/Sb); p =p+1;
c(p)=abs((vd(5)*iBd(5)+vq(5)*iBq(5))+ (1j*(vq(5)*iBd(5)-vd(5)*iBq(5))))-(250/Sb); p =p+1;
c(p)=abs((vd(6)*iBd(6)+vq(6)*iBq(6))+ (1j*(vq(6)*iBd(6)-vd(6)*iBq(6))))-(250/Sb); p =p+1;
c(p)=abs((vd(7)*iBd(7)+vq(7)*iBq(7))+ (1j*(vq(7)*iBd(7)-vd(7)*iBq(7))))-(150/Sb); p =p+1;
c(p)=abs((vd(8)*iBd(8)+vq(8)*iBq(8))+ (1j*(vq(8)*iBd(8)-vd(8)*iBq(8))))-(250/Sb); p =p+1;
c(p)=abs((vd(9)*iBd(9)+vq(9)*iBq(9))+ (1j*(vq(9)*iBd(9)-vd(9)*iBq(9))))-(150/Sb); p =p+1;

c(p)=sqrt(vd(1)^2+vq(1)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(1)^2+vq(1)^2)+1.02;p=p+1;
c(p)=sqrt(vd(2)^2+vq(2)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(2)^2+vq(2)^2)+1.02;p=p+1;
c(p)=sqrt(vd(3)^2+vq(3)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(3)^2+vq(3)^2)+1.02;p=p+1;
c(p)=sqrt(vd(4)^2+vq(4)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(4)^2+vq(4)^2)+1.02;p=p+1;
c(p)=sqrt(vd(5)^2+vq(5)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(5)^2+vq(5)^2)+1.02;p=p+1;
c(p)=sqrt(vd(6)^2+vq(6)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(6)^2+vq(6)^2)+1.02;p=p+1;
c(p)=sqrt(vd(7)^2+vq(7)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(7)^2+vq(7)^2)+1.02;p=p+1;
c(p)=sqrt(vd(8)^2+vq(8)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(8)^2+vq(8)^2)+1.02;p=p+1;
c(p)=sqrt(vd(9)^2+vq(9)^2)-1.05;p=p+1;
c(p)=-sqrt(vd(9)^2+vq(9)^2)+1.02;p=p+1;

c(p)=sqrt(iBd(1)^2+iBq(1)^2)-((1/(sqrt(3)*1.02))*(linedata(1,6)/Sb));p=p+1; 
c(p)=-sqrt(iBd(1)^2+iBq(1)^2)+((-1/(sqrt(3)*1.02))*(linedata(1,6)/Sb));p=p+1;
c(p)=sqrt(iBd(2)^2+iBq(2)^2)-((1/(sqrt(3)*1.02))*(linedata(2,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(2)^2+iBq(2)^2)+((-1/(sqrt(3)*1.02))*(linedata(2,6)/Sb));p=p+1;
c(p)=sqrt(iBd(3)^2+iBq(3)^2)-((1/(sqrt(3)*1.02))*(linedata(3,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(3)^2+iBq(3)^2)+((-1/(sqrt(3)*1.02))*(linedata(3,6)/Sb));p=p+1;
c(p)=sqrt(iBd(4)^2+iBq(4)^2)-((1/(sqrt(3)*1.02))*(linedata(4,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(4)^2+iBq(4)^2)+((-1/(sqrt(3)*1.02))*(linedata(4,6)/Sb));p=p+1;
c(p)=sqrt(iBd(5)^2+iBq(5)^2)-((1/(sqrt(3)*1.02))*(linedata(5,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(5)^2+iBq(5)^2)+((-1/(sqrt(3)*1.02))*(linedata(5,6)/Sb));p=p+1;
c(p)=sqrt(iBd(6)^2+iBq(6)^2)-((1/(sqrt(3)*1.02))*(linedata(6,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(6)^2+iBq(6)^2)+((-1/(sqrt(3)*1.02))*(linedata(6,6)/Sb));p=p+1;
c(p)=sqrt(iBd(7)^2+iBq(7)^2)-((1/(sqrt(3)*1.02))*(linedata(7,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(7)^2+iBq(7)^2)+((-1/(sqrt(3)*1.02))*(linedata(7,6)/Sb));p=p+1;
c(p)=sqrt(iBd(8)^2+iBq(8)^2)-((1/(sqrt(3)*1.02))*(linedata(8,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(8)^2+iBq(8)^2)+((-1/(sqrt(3)*1.02))*(linedata(8,6)/Sb));p=p+1;
c(p)=sqrt(iBd(9)^2+iBq(9)^2)-((1/(sqrt(3)*1.02))*(linedata(9,6)/Sb));p=p+1;
c(p)=-sqrt(iBd(9)^2+iBq(9)^2)+((-1/(sqrt(3)*1.02))*(linedata(9,6)/Sb));p=p+1;

 
end

end