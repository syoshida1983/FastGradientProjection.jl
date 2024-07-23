function ProjConvex(x::T, l, u) where {T<:Real}
    if x < l
        return l
    elseif  x > u
        return u
    else
        return x
    end
end

function ProjConvex(x::T, l, u) where {T<:Complex}
    return x
end

function IsoProj(p::AbstractArray{T,2}, q::AbstractArray{T,2}) where {T}
    return  (@. (@view p[2:end-1,:])/max(1, √(abs2(@view p[2:end-1,:]) + abs2(@view q[1:end-1,2:end])))),
            (@. (@view q[:,2:end-1])/max(1, √(abs2(@view p[2:end,1:end-1]) + abs2(@view q[:,2:end-1]))))
end

function IsoProj(p::AbstractArray{T,3}, q::AbstractArray{T,3}, r::AbstractArray{T,3}) where {T}
    return  (@. (@view p[2:end-1,:,:])/max(1, √(abs2(@view p[2:end-1,:,:]) + abs2(@view q[1:end-1,2:end,:]) + abs2(@view r[1:end-1,:,2:end])))),
            (@. (@view q[:,2:end-1,:])/max(1, √(abs2(@view p[2:end,1:end-1,:]) + abs2(@view q[:,2:end-1,:]) + abs2(@view r[:,1:end-1,2:end])))),
            (@. (@view r[:,:,2:end-1])/max(1, √(abs2(@view p[2:end,:,1:end-1]) + abs2(@view q[:,2:end,1:end-1]) + abs2(@view r[:,:,2:end-1]))))
end

function AnisoProj(p::AbstractArray{T,2}, q::AbstractArray{T,2}) where {T}
    return  (@. (@view p[2:end-1,:])/max(1, abs(@view p[2:end-1,:]))),
            (@. (@view q[:,2:end-1])/max(1, abs(@view q[:,2:end-1])))
end

function AnisoProj(p::AbstractArray{T,3}, q::AbstractArray{T,3}, r::AbstractArray{T,3}) where {T}
    return  (@. (@view p[2:end-1,:,:])/max(1, abs(@view p[2:end-1,:,:]))),
            (@. (@view q[:,2:end-1,:])/max(1, abs(@view q[:,2:end-1,:]))),
            (@. (@view r[:,:,2:end-1])/max(1, abs(@view r[:,:,2:end-1])))
end
