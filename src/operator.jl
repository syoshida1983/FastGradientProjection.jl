function LinearOp(p::AbstractArray{T,2}, q::AbstractArray{T,2}) where {T}
    return @. (@view p[2:end,:]) + (@view q[:,2:end]) - (@view p[1:end-1,:]) - (@view q[:,1:end-1])
end

function LinearOp(p::AbstractArray{T,3}, q::AbstractArray{T,3}, r::AbstractArray{T,3}) where {T}
    return @. (@view p[2:end,:,:]) + (@view q[:,2:end,:]) + (@view r[:,:,2:end]) - (@view p[1:end-1,:,:]) - (@view q[:,1:end-1,:]) - (@view r[:,:,1:end-1])
end

function AdjointOp(x::AbstractArray{T,2}) where {T}
    return  (@view x[1:end-1,:]) .- (@view x[2:end,:]),
            (@view x[:,1:end-1]) .- (@view x[:,2:end])
end

function AdjointOp(x::AbstractArray{T,3}) where {T}
    return  (@view x[1:end-1,:,:]) .- (@view x[2:end,:,:]),
            (@view x[:,1:end-1,:]) .- (@view x[:,2:end,:]),
            (@view x[:,:,1:end-1]) .- (@view x[:,:,2:end])
end
