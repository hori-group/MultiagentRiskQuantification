# About this repository
This repository provides a code for the paper "Orthogonal Modal Representation in Long-Term Risk Quantification for Dynamic Multi-Agent Systems" presented by Ryoma Yasunaga, Yorie Nakahira, and Yutaka Hori at American Control Conference 2025.

- R. Yasunaga, Y. Nakahira and Y. Hori, "Orthogonal Modal Representation in Long-Term Risk Quantification for Dynamic Multi-Agent Systems," in IEEE Control Systems Letters, vol. 8, pp. 3177-3182, 2024, DOI: [10.1109/LCSYS.2024.3522949](https://doi.org/10.1109/LCSYS.2024.3522949)

# Prerequisites
- Python 3.11.3
- MATLAB 2024b

# Description of Each Code

`Calc_SafeProb_usingFKPDE.ipynb`  
- Solves each sub-Kolmogorov PDE corresponding to a decomposed safety probability of multi-agent systems by using the `py-pde` package. 
- The solution data for each PDE is stored in the folder `PDEdata` in `.mat` format. 

`Visualize_GraphFourierBasis.m`  
- Visualizes each component of the eigenvectors of the graph Laplacian (graph Fourier basis) on the graph vertices.  
- This code is used to generate **Fig. 1 in the IEEE L-CSS paper**.  

`MCsample_StateTrajectories.m`  
- Simulates state trajectories of multi-agent systems via Monte Carlo (MC) sampling.  
- The time-series data of state trajectories are stored in the folder `MCdata` in `.mat` format.
 
`Visualize_StateTrajectories.m`  
- Visualizes the state trajectories obtained from `MCsample_StateTrajectories.m`.  
- This code is used to generate **Fig. 2 (A) in the IEEE L-CSS paper**.

`Calc_SafeProb_usingMC.m`  
- Computes the safety probability that the system state remains inside the polytope defined by the eigenvectors of the interaction matrix L.  
- The computation is based on trajectories obtained from `MCsample_StateTrajectories.m`.

`Compare_MCwithFK.m`  
- Compares the time evolution of the safety probability obtained from the PDE decomposition-based approach (`Calc_SafeProb_usingFKPDE.ipynb`) and the MC sampling approach (`Calc_SafeProb_usingMC.m`).  
- This code is used to generate **Fig. 2 (B) in the IEEE L-CSS paper**.  
