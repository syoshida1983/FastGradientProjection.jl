export GP
export GP!

"""
    GP(b, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso")

return denoised (volume) image `b`. Compared to `FGP`, convergence is slower, but memory usage is lower.
"""
function GP(b::AbstractArray{T,2}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    ProjPair = (TV=="iso") ? IsoProj : ((TV=="aniso") ? AnisoProj : throw(ArgumentError("Invalid keyword argument.")))
    Ny, Nx = size(b)
    p = zeros(eltype(b), Ny+1, Nx)
    q = zeros(eltype(b), Ny, Nx+1)
    p̃ = zeros(eltype(b), Ny+1, Nx)
    q̃ = zeros(eltype(b), Ny, Nx+1)

    for k ∈ 1:N
        p̃[2:end-1,:], q̃[:,2:end-1] = AdjointOp(ProjConvex.(b .- λ.*LinearOp(p, q), lower_bound, upper_bound))
        p̃ = @. p + p̃/(8λ)
        q̃ = @. q + q̃/(8λ)
        p[2:end-1,:], q[:,2:end-1] = ProjPair(p̃, q̃)
    end

    return ProjConvex.(b .- λ.*LinearOp(p, q), lower_bound, upper_bound)
end

"""
    GP!(b, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso")

Same as `GP`, but operates in-place on `b`.
"""
function GP!(b::AbstractArray{T,2}, λ, N; lower_bound=-Inf, upper_bound=Inf, TV="iso") where {T}
    b[:,:] = GP(b, λ, N, lower_bound=lower_bound, upper_bound=upper_bound, TV=TV)
end
