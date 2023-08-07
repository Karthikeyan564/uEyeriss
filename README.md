Base Repo: https://github.com/karthisugumar/CSE240D-Hierarchical_Mesh_NoC-Eyeriss_v2

Optimisations:
1. Approximate multipliers instead of exact multiplier architectures

ref: https://github.com/Hassan313/Approximate-Multiplier

https://link.springer.com/chapter/10.1007/978-981-15-8221-9_128#:~:text=Approximate%20MultiPlier%20(AMP)%20is%20the,relived%20in%20the%20literature%20survey.

https://ieeexplore.ieee.org/document/9816787

2. Accumulation adder can be replaced with segmented/approx adders

ref: https://ieeexplore.ieee.org/document/7538961

https://ieeexplore.ieee.org/document/9271703

https://github.com/ehw-fit/evoapproxlib/tree/v2022


https://github.com/e-dupuis/awesome-approximate-dnn

https://github.com/ehw-fit/ariths-gen


Multiplier codes:

https://github.com/antonblanchard/vlsiffra

https://github.com/Saadia-Hassan/8x8Multiplier-Using-Vedic-Mathematics

Observations:

1. Current design uses 12 DSPs to implement all multiplcations in the design - PE cluster is 3x3 - 9 MAC units


Vedic Multiplier:
Behavioural simulation - done

Post-Synthesis Func. Sim - done

Post-imp func. sim - done

Post-synth timing sim - 4.323 ns for output to be valid after asserting enable, 2.985 ns for all lines of output to reach high impedance (on de-asserting enable)

Post-imp timing sim 

obs:
Output to reach high-impedance after enable set to 0(first time) or valid data to be available  after enable set to 1-> 7.846ns
Output to go from valid to high impedance after de-asserting enable -> 6.475 ns
