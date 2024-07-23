function FGP(b::AbstractArray{T,3}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    ProjPair = (TV=="iso") ? IsoProj : ((TV=="aniso") ? AnisoProj : throw(ArgumentError("Invalid keyword argument.")))
    Ny, Nx, Nz = size(b)
    p = zeros(eltype(b), Ny+1, Nx, Nz)
    q = zeros(eltype(b), Ny, Nx+1, Nz)
    r = zeros(eltype(b), Ny, Nx, Nz+1)
    p₋₁ = zeros(eltype(b), Ny+1, Nx, Nz)
    q₋₁ = zeros(eltype(b), Ny, Nx+1, Nz)
    r₋₁ = zeros(eltype(b), Ny, Nx, Nz+1)
    p̃ = zeros(eltype(b), Ny+1, Nx, Nz)
    q̃ = zeros(eltype(b), Ny, Nx+1, Nz)
    r̃ = zeros(eltype(b), Ny, Nx, Nz+1)
    t = 1.
    t₊₁ = 1.

    for k ∈ 1:N
        p̃[2:end-1,:,:], q̃[:,2:end-1,:], r̃[:,:,2:end-1] = AdjointOp(ProjConvex.(b .- λ.*LinearOp(p₋₁, q₋₁, r₋₁), lower_bound, upper_bound))
        p̃ = @. p₋₁ + p̃/(12λ)
        q̃ = @. q₋₁ + q̃/(12λ)
        r̃ = @. r₋₁ + r̃/(12λ)
        p[2:end-1,:,:], q[:,2:end-1,:], r[:,:,2:end-1] = ProjPair(p̃, q̃, r̃)
        t₊₁ = (1 + √(1 + 4t^2))/2
        p₋₁ = @. p + (t - 1)/t₊₁*(p - p₋₁)
        q₋₁ = @. q + (t - 1)/t₊₁*(q - q₋₁)
        r₋₁ = @. r + (t - 1)/t₊₁*(r - r₋₁)
        t = t₊₁
    end

    return ProjConvex.(b .- λ.*LinearOp(p₋₁, q₋₁, r₋₁), lower_bound, upper_bound)
end

function FGP!(b::AbstractArray{T,3}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    b[:,:,:] = FGP(b, λ, N, lower_bound=lower_bound, upper_bound=upper_bound, TV=TV)
end
