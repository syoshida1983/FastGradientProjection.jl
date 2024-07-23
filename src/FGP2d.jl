export FGP
export FGP!

"""
    FGP(b, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso")

return denoised (volume) image `b` based on the minimization problem ``\\min_{\\mathbf{x}\\in{C}}\\|\\mathbf{x} - \\mathbf{b}\\|^{2}_{F} + 2\\lambda\\operatorname{TV}(\\mathbf{x}).``

# Arguments
- `b`: input (volume) image.
- `λ`: regularization parameter.
- `N`: number of iterations.
- `lower_bound=-Inf`: upper bound of the convex closed set ``C``. If `b` is a complex array, projection to ``C`` is not performed.
- `upper_bound=Inf`: lower bound of the convex closed set ``C``.
- `TV="iso"`: if `TV="iso"` (default), denoising is based on isotropic TV. To specify anisotropic TV, set `TV="aniso"`.
"""
function FGP(b::AbstractArray{T,2}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    ProjPair = (TV=="iso") ? IsoProj : ((TV=="aniso") ? AnisoProj : throw(ArgumentError("Invalid keyword argument.")))
    Ny, Nx = size(b)
    p = zeros(eltype(b), Ny+1, Nx)
    q = zeros(eltype(b), Ny, Nx+1)
    p₋₁ = zeros(eltype(b), Ny+1, Nx)
    q₋₁ = zeros(eltype(b), Ny, Nx+1)
    p̃ = zeros(eltype(b), Ny+1, Nx)
    q̃ = zeros(eltype(b), Ny, Nx+1)
    t = 1.
    t₊₁ = 1.

    for k ∈ 1:N
        p̃[2:end-1,:], q̃[:,2:end-1] = AdjointOp(ProjConvex.(b .- λ.*LinearOp(p₋₁, q₋₁), lower_bound, upper_bound))
        p̃ = @. p₋₁ + p̃/(8λ)
        q̃ = @. q₋₁ + q̃/(8λ)
        p[2:end-1,:], q[:,2:end-1] = ProjPair(p̃, q̃)
        t₊₁ = (1 + √(1 + 4t^2))/2
        p₋₁ = @. p + (t - 1)/t₊₁*(p - p₋₁)
        q₋₁ = @. q + (t - 1)/t₊₁*(q - q₋₁)
        t = t₊₁
    end

    return ProjConvex.(b .- λ.*LinearOp(p₋₁, q₋₁), lower_bound, upper_bound)
end

"""
    FGP!(b, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso")

Same as `FGP`, but operates in-place on `b`.
"""
function FGP!(b::AbstractArray{T,2}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    b[:,:] = FGP(b, λ, N, lower_bound=lower_bound, upper_bound=upper_bound, TV=TV)
end
