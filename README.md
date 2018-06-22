# Implementation details and some notes on the algorithm

The directory contains all the codes required to reproduce the results in our SPAWC 2017 paper titled "A compressive channel estimation technique robust to synchronization impairments" [1].

Phase error robust compressive sensing:- 

Standard compressed sensing-based algorithms are sensitive to phase errors that arise due to uncorrected CFO and phase noise. Compensating these impairments before beam alignment can be difficult due to low SNR prior to channel estimation and beam alignment. In this work, we present a novel tensor based approach that accounts for these impairments and thereby achieves robustness to CFO and phase noise. Our algorithm is able to exploit the sparsity of the tensor along three different dimensions corresponding to the angle of arrival, angle of departure and CFO. We have shown that our approach is equivalent to convex-relaxation based lifting technique proposed in [2].

Reproducing our results:-

The code "CFO_robust_channel_est/RobustCS.m" performs channel estimation robust to CFO in an mmWave setup with analog beamforming architecture. The parameters in the code are those used in [1]. It is actually a simpler version of the original  code and does not require any tensor libraries. The code uses the equivalence between our tensor based approach and the lifting technique discussed in Sec. V.E of our SPAWC paper.

On exectuing the code "RobustCS.m" it can be seen that our algorithm can find a good approximation of the beamspace MIMO channel estimate and achieves a good rate. The standard CS-based algorithm, however, fails to work due to CFO and phase noise. It can be seen that CFO and phase noise introduce arbitrary distortions in the beamspace MIMO channel estimate.

Our state of the art algorithm to solve the same problem:- 

Our new algorithm called Swift-Link [3] approaches the CFO robust channel estimation problem from a training design perspective. Swift-Link controls the impact of CFO on the beamspace estimate and has lower-complexity than [1] or [2]. Furthermore, Swift-Link runs as fast as a standard compressed sensing problem with partial DFT-based measurement matrices. Swift-Link's training and algorithm are easy to implement when compared to those in [1] and [2]. Furthermore, it's extension to other architectures like hybrid beamforming, switching or one-bit receivers is straightforward. 

For more details on these algorithms and implementation, please contact me at nitinjmyers@utexas.edu .
I will post the codes for Swift-Link as soon as they get published on IEEE Xplore. 

All of the following papers are also available on arxiv. 

[1] N.J. Myers and R. W. Heath Jr., "A compressive channel estimation technique robust to synchronization impairments", in Proc. of IEEE SPAWC 2017

[2] S. Ling and T. Strohmer, “Self-calibration and biconvex compressive sensing,” Inverse Problems, vol. 31, no. 11, p. 115002, 2015.

[3] N.J. Myers, A. Mezghani and R. W. Heath Jr., "Swift-Link : A compressive beam alignment algorithm for practical mmWave radios", submitted to IEEE Transactions on Signal Processing, June 2018 

Find more information about our research at 

http://www.profheath.org/

https://sites.google.com/site/nitinmyers/home
