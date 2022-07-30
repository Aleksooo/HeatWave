struct DSolution
    #= Size of space grid =#
    l::Real
    N::Int
    dx::Real

    #= Size of time grid =#
    τ::Real
    T::Int
    dt::Real

    #= Matrix of solution =#
    SolMat::Matrix{Float64}

    function DSolution((l, N, dx), 
                       (τ, T, dt),
                       SolMat,)

        return new(l, N, dx, 
                   τ, T, dt, 
                   SolMat,)
        
    end
end;

#= -------------------------------------------------- =#

"""
    DEquation

Type of differential equation which should looks like:

    df/dt = d^2f/dx^2 + g(f)

"""
struct DEquation
    #= Structure which consist equation's paramets and matrix of solution =#
    Sol::DSolution

    #= Functions of differential equation =#
    k_f::Function
    g_f::Function

    #= Boundary conditions =#
    f_x_t0::Function
    f_t_x0::Function
    f_t_xN::Function

    function DEquation((l, dx), 
                       (τ, dt);
                       k_f::Function,
                       g_f::Function,
                       f_x_t0::Function, 
                       f_t_x0::Function,
                       f_t_xN::Function,)
        
        N = trunc(Int, l / dx)
        T = trunc(Int, τ / dt)

        SolMat = zeros(Float64, T+1, N+1)
        SolMat[begin, begin+1:end-1] .= [f_x_t0(i*dx) for i in 1:N-1]
        SolMat[:, begin] .= [f_t_x0(j*dt) for j in 0:T]
        SolMat[:, end] .= [f_t_xN(j*dt) for j in 0:T]
        
        return new(DSolution((l, N, dx), (τ, T, dt), SolMat), 
                   k_f, g_f, 
                   f_x_t0, f_t_x0, f_t_xN,)
    end

end;


"""
    Slice

Type of time slice for numerical solution
"""
struct Slice
    N::Int
    coef::Matrix{Float64}
    b::Vector

    function Slice(sl::DEquation, t::Int)
        N = sl.Sol.N
        dx = sl.Sol.dx
        dt = sl.Sol.dt
        k = sl.k_f
        g = sl.g_f
        Sol = sl.Sol.SolMat

        coef = zeros(Float64, N+1, 3)

        for i in 1:N+1
            if i == 1
                coef[i, :] .= [0, 1, 0]
            elseif i == N+1
                coef[i, :] .= [0, 1, 0]
            else
                a_i1 = (k(Sol[t-1, i]) + k(Sol[t-1, i-1])) / 2
                a_i2 = (k(Sol[t-1, i+1]) + k(Sol[t-1, i])) / 2

                A = -a_i1
                B = dx^2/dt + (a_i1 + a_i2)
                C = -a_i2

                coef[i, :] .= [A, B, C]
            end
        end

        b = [(Sol[t-1, i]/dt + g(Sol[t-1, i])) * dx^2 for i in 1:N+1]
        b[begin] = Sol[t, begin]
        b[end] = Sol[t, end]

        return new(N, coef, b)
    end

end;


#= -------------------------------------------------- =#
