% This code implements our algorithm in SPAWC
% 2017 paper 
% N.J. Myers and R.W. Heath Jr., "A compressive channel estimation robust to synchronization
% impairments".
% This is actually a simpler version of our code that does not require any tensor
% libraries and is easy to understand.
% This code is based on the equivalence of tensor based approach with the 
% lifting technique discussed in Sec. V.E of our SPAWC paper
clear all;
clc;
tic
Nr=16;              % # of antennas at the RX
Nt=32;              % # of antennas at the TX
sf=2;               % oversampling factor for dictionary
Gr=sf*Nr;           
Gt=sf*Nt;
UNt=ntnmtx(Gt,Nt);  % GtxNt is the dictionary used at the Tx. For Gt=Nt, it is simply the DFT
UNr=ntnmtx(Gr,Nr);
type=1;             %1-a realistic mmWave channel used in SPAWC paper , 2- on grid channel , 3- off grid channel with few components
L=2;                % number of clusters in mmWave channel
cfoflag=1;          % Use 1 for our algorithm- tensor based CS, 0 for standard CS that ignores CFO;
pn_sig=0.27;         % Standard deviation of Wiener phase noise 

M=64;              % Number of channel measurements used by algorithm

qb=3;               % resolution of the phase shifters used at the TX and the RX
fe_max=280;         % KHz less than fs/2 - 40 meas considered
gamma=2;            % To model leakage effect along the CFO dimension
f_s=2000;           % Sampling frequency in KHz

f_e=(2000/M)*8.5;   % Off-Grid CFO that is close to the maximum possible CFO

we=2*pi*f_e/f_s;    % CFO represented in radians

SNRvec=[5:5:5];   % -SNR is actually noise variance in dB
Nruns=1;    
Smax=zeros(size(SNRvec));   
Seff=Smax;

wmax=2*pi*fe_max*gamma/f_s  ;   % CFO limits that account for leakage
Nmax=floor(M*wmax/(2*pi));      % Limits on CFO used to truncate the dictionary corresponding to phase error vector
B=dftmtx(M)'/sqrt(M);           % basis for CFO
B=[B(:,1:Nmax),B(:,end:-1:M-Nmax+1)];   % from knowledge of worst case CFO 0-->f_e
kc=size(B,2);

if(cfoflag==0)                  % Standard CS
    B=ones(M,1)/sqrt(M);
    kc=1;
end
Y=zeros(M,1);

for ss=1:1:length(SNRvec)
   rng(1913*ss); 
   SNR=SNRvec(ss);
   sig=10^(-SNR/20);  
   cfosig=zeros(kc,Nr);   
   for runs=1:1:Nruns
            rng(12*runs);
            pnv=zeros(M,1);         
            pnv(1)=pn_sig*randn;
            for i=2:1:M
            pnv(i)=pnv(i-1)+ pn_sig*randn;  % Wiener phase noise process
            end 

            H=Hmat(Nr,Nt,L,type);           % Channel matrix
         

            Wr= (pi/2^qb)+ (randi(2^qb,[Nr,M])*2*pi/(2^qb));    
            Wt= (pi/2^qb)+ (randi(2^qb,[Nt,M])*2*pi/(2^qb));

            Wr=exp(1i*Wr)/sqrt(Nr); Wt=exp(1i*Wt)/sqrt(Nt); % phase shift sequences for M channel measurements
            for k=1:1:M
                A(k,:)=kron(Wt(:,k).'*UNt,Wr(:,k)'*UNr);                % A-Standard CS matrix
                Y(k)=exp(1i*we*k)*Wr(:,k)'*H*Wt(:,k)*exp(1i*pnv(k));    % channel measurements corrupted byCFO and phase noise
                cfoact(k)=exp(1i*we*k)*exp(1i*pnv(k));
            end
            Yorg=Y;
           for k=1:1:M
                An(k,:)=kron(A(k,:),B(k,:));                            % An-Lifted CS matrix each row of An is a vectorization of the measurement tensor
            end
           % cfosig=zeros(M,Nruns);
           % cfoact=cfosig;
           % cfoact(:,runs)=exp(1i*pnv).';
            Y=Yorg+(sig*(randn(M,1)+1i*randn(M,1)))/sqrt(2);            % channel measurements perturbed by AWGN
          
            xm=zeros(kc*Gt*Gr,1);                                       % We solve for a GrxGtxkc size tensor, xm is vectorization of this tensor
            dum=xm;                                                     % kc is the size of the dictionary used to model the phase error vector                                               
            epsilon=sig*sqrt(M);
            iter=0;
            Maxiter=200;
            cind=[];
            % Compressed sensing with OMP for y=An*x, i.e., the lifted
            % problem
            while(1)
                PH=[];
                res=Y-An*xm;
                if(norm(res)<=epsilon | iter==Maxiter)
                    break;
                end
                ind=retin(abs(An'*res),1);
              
                D=union(cind,ind);
                for ii=1:1:length(D)
                    PH=[PH,An(:,D(ii))];
                end
                tmpv=(inv(PH'*PH))*PH'*Y;
                tm=dum;
                tm(D)=tmpv;
                xm=tm;
                cind=D;
                iter=iter+1;
            end

            gb=xm;                          % recovered vectorization of the tensor

            JE=reshape(gb,[kc,Gt*Gr]);      % flatten the tensor to a matrix 
            [a,b,c]=svd(JE);                % Decompose the matrix using SVD
            cfosig(:,runs)=a(:,1);          % This is the phase error vector in the dictionary B
            hb=conj(c(:,1));                % This is the vectorized MIMO channel estimate
            Hest=kron(UNt,UNr)*hb;          
            Hest=reshape(Hest,[Nr,Nt]);     % Estimated MIMO channel
            [xe,ye,ze]=svd(Hest);           % Take SVD of the estimated channel
            xe=quantz(xe(:,1),qb);          % Use the quantized version of singular vectors for beamforming
            ze=quantz(ze(:,1),qb);
            gain=abs(xe'*H*ze);             % Beamforming gain with our channel estimate
            Seff(ss)=Seff(ss)+log2(1+(10.^(SNR/10))*gain*gain); % Achievable rate with our algorithm
            [uh,sh,vh]=svd(H);
            uh=uh(:,1);%;quantz(uh(:,1),qb);
            vh=vh(:,1);%;quantz(vh(:,1),qb);
            maxgn=abs(uh'*H*vh);
            Smax(ss)=Smax(ss)+log2(1+((10.^(SNR/10))*(maxgn^2)));   % Maximum achievable rate
        end
%  dlmwrite(strcat('set_2_CFOsignal_0_phase_noise',num2str(SNR),'.txt'),cfosig);
%  dlmwrite(strcat('CFOactual_0.27_phase_noise',num2str(SNR),'.txt'),cfoact);
end
Seff=Seff/Nruns;
Smax=Smax/Nruns;
toc
fprintf('Results for a single realization with M=64 channel measurements and SNR= 5dB \n')
fprintf('Achievable rate with perfect CSI is %2.2f bps/Hz \n' ,Smax)
fprintf('Achievable rate with standard CS that ignores CFO is %2.2f bps/Hz\n' , 0.2160)
fprintf('Achievable rate with our algorithm is %2.2f bps/Hz \n' , Seff)

disp('Visualizing the performance of our algorithm for a single run...')
HestSCS=dlmread('Hest_CS_ignore_CFO_single_run.txt'); % channel estimate obtained using standard CS- CFO ignored, set cfoflag to 0 in line 21 
figure()
subplot(1,3,1)
surf(abs(fftshift(fft2(H))))
view([0,90])
title('True beamspace')
xlabel('AoA') 
ylabel('AoD')
xlim([1,32])
ylim([1,16])

subplot(1,3,2)
surf(abs(fftshift(fft2(Hest))))
view([0,90])
title('Our algorithm')
xlabel('AoA') 
ylabel('AoD')
xlim([1,32])
ylim([1,16])

subplot(1,3,3)
surf(abs(fftshift(fft2(HestSCS))))
view([0,90])
title('Standard CS')
xlabel('AoA') 
ylabel('AoD')
xlim([1,32])
ylim([1,16])