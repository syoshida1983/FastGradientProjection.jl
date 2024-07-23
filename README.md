# FastGradientProjection

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://syoshida1983.github.io/FastGradientProjection.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://syoshida1983.github.io/FastGradientProjection.jl/dev/)
[![Build Status](https://github.com/syoshida1983/FastGradientProjection.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/syoshida1983/FastGradientProjection.jl/actions/workflows/CI.yml?query=branch%3Amain)

This package provides the functions for total variation (TV) denoising with gradient projection (GP) and fast gradient projection (FGP). GP/FGP denoises of (volume) image $\mathbf{b}$ based on the following minimization problem

$$\min_{\mathbf{x}\in{C}}\\|\mathbf{x} - \mathbf{b}\\|^{2}_{F} + 2\lambda\mathrm{TV}(\mathbf{x}),$$

where $C$ is a convex closed set, $\\|\cdot\\|_{F}$ is the Frobenius norm, $\lambda$ is the regularization parameter, and $\mathrm{TV}$ is the total variation defined by

$$\begin{align}
    \mathrm{TV}\_{I}(\mathbf{x}) &=
    \begin{cases}
        \sum\_{i}\sum\_{j}\sqrt{\\left(x\_{i,j} - x\_{i+1,j}\\right)^{2} + \\left(x\_{i,j} - x\_{i,j+1}\\right)^{2}} & \text{(2D)}\\
        \sum\_{i}\sum\_{j}\sum\_{k}\sqrt{\\left(x\_{i,j,k} - x\_{i+1,j,k}\\right)^{2} + \\left(x\_{i,j,k} - x\_{i,j+1,k}\\right)^{2} + \\left(x\_{i,j,k} - x\_{i,j,k+1}\\right)^{2}} & \text{(3D)}
    \end{cases},\\
    \mathrm{TV}\_{l\_{1}}(\mathbf{x}) &=
    \begin{cases}
        \sum\_{i}\sum\_{j}\\left\\{\\left|x\_{i,j} - x\_{i+1,j}\\right| + \\left|x\_{i,j} - x\_{i,j+1}\\right|\\right\\} & \text{(2D)}\\
        \sum\_{i}\sum\_{j}\sum\_{k}\\left\\{\\left|x\_{i,j,k} - x\_{i+1,j,k}\\right| + \\left|x\_{i,j,k} - x\_{i,j+1,k}\\right| + \\left|x\_{i,j,k} - x\_{i,j,k+1}\\right|\\right\\} & \text{(3D)}
    \end{cases}.
\end{align}$$

$\mathrm{TV}\_{I}$ and $\mathrm{TV}\_{l\_{1}}$ express isotropic and $l_{1}$-based anisotropic TV, respectively.

For more information on the algorithm, please refer to the following reference.

> [Amir Beck and Marc Teboulle, "Fast Gradient-Based Algorithms for Constrained Total Variation Image Denoising and Deblurring Problems," IEEE Trans. Image Process. **18**, 2419-2434 (2009)](https://doi.org/10.1109/TIP.2009.2028250)

# Installation

To install this package, open the Julia REPL and run

```julia
julia> ]add FastGradientProjection
```

or

```julia
julia> using Pkg
julia> Pkg.add("FastGradientProjection")
```

# Usage

Import the package first.

```julia
julia> using FastGradientProjection
```

For example, perform the following to denoise (volume) image $\mathbf{b}$ with FGP.

```julia
julia> x = FGP(b, 0.1, 100, lower_bound=0.0, upper_bound=1.0)
```

The second and third arguments are the regularization parameter $\lambda$ and the number of iterations. The values specified by the keyword arguments `lower_bound` and `upper_bound` are the upper and lower bounds of the convex closed set $C$. These default values are `lower_bound=-Inf` and `upper_bound=Inf`. If $\mathbf{b}$ is a complex array, projection to $C$ is not performed. The function FGP performs denoising based on isotropic TV by default; to perform denoising based on anisotropic TV, specify the keyword argument `TV="aniso"`. Refer to the [documentation](https://syoshida1983.github.io/FastGradientProjection.jl/stable/) for further information.

<p align="center">
    <img src="https://github.com/syoshida1983/FastGradientProjection.jl/blob/images/noised.jpg" width="250px">
    &emsp;&emsp;
    <img src="https://github.com/syoshida1983/FastGradientProjection.jl/blob/images/denoised.jpg" width="250px">
    <br>
    noised image
    &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
    denoised image
</p>
