function GP(b::AbstractArray{T,3}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    ProjPair = (TV=="iso") ? IsoProj : ((TV=="aniso") ? AnisoProj : throw(ArgumentError("Invalid keyword argument.")))
    Ny, Nx, Nz = size(b)
    p = zeros(eltype(b), Ny+1, Nx, Nz)
    q = zeros(eltype(b), Ny, Nx+1, Nz)
    r = zeros(eltype(b), Ny, Nx, Nz+1)
    p̃ = zeros(eltype(b), Ny+1, Nx, Nz)
    q̃ = zeros(eltype(b), Ny, Nx+1, Nz)
    r̃ = zeros(eltype(b), Ny, Nx, Nz+1)

    for k ∈ 1:N
        p̃[2:end-1,:,:], q̃[:,2:end-1,:], r̃[:,:,2:end-1] = AdjointOp(ProjConvex.(b .- λ.*LinearOp(p, q, r), lower_bound, upper_bound))
        p̃ = @. p + p̃/(12λ)
        q̃ = @. q + q̃/(12λ)
        r̃ = @. r + r̃/(12λ)
        p[2:end-1,:,:], q[:,2:end-1,:], r[:,:,2:end-1] = ProjPair(p̃, q̃, r̃)
    end

    return ProjConvex.(b .- λ.*LinearOp(p, q, r), lower_bound, upper_bound)
end

function GP!(b::AbstractArray{T,3}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    b[:,:,:] = GP(b, λ, N, lower_bound=lower_bound, upper_bound=upper_bound, TV=TV)
end
