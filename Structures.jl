"""
    DEquation

Type of differential equation which should looks like:

    df/dt = d(k(f)*df/dx)/dx + g(f)

"""
struct DEquation
    #= Size of space grid =#
    l::Real
    N::Int
    dx::Real

    #= Size of time grid =#
    τ::Real
    T::Int
    dt::Real

    #= Functions of differential equation =#
    k_f::Function
    g_f::Function

    #= Boundary conditions =#
    bound_cond_type::String
    f_x_t0::Function
    f_t_x0::Function
    f_t_xN::Function

    #= Matrix of solution =#
    SolMat::Matrix{Float64}

    function DEquation((l, dx), 
                       (τ, dt);
                       k_f::Function,
                       g_f::Function,
                       f_x_t0::Function, 
                       f_t_x0::Function,
                       f_t_xN::Function,
                       bound_cond_type::String="D")
        
        if bound_cond_type != "D" && bound_cond_type != "N"
            error("Wrong boundary condition type!")
        end
        
        N = trunc(Int, l / dx)
        T = trunc(Int, τ / dt)

        SolMat = zeros(Float64, T+1, N+1)
        SolMat[begin, begin+1:end-1] .= [f_x_t0(i*dx) for i in 1:N-1]
        SolMat[:, begin] .= [f_t_x0(j*dt) for j in 0:T]
        SolMat[:, end] .= [f_t_xN(j*dt) for j in 0:T]
        
        return new(l, N, dx, 
                   τ, T, dt, 
                   k_f, g_f, 
                   bound_cond_type, f_x_t0, f_t_x0, f_t_xN, 
                   SolMat,)
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

    function Slice(Deq::DEquation, t::Int)
        N = Deq.N
        dx = Deq.dx
        dt = Deq.dt
        bound_cond_type = Deq.bound_cond_type
        k = Deq.k_f
        g = Deq.k_f
        Sol = Deq.SolMat

        coef = zeros(Float64, N+1, 3)

        for i in 1:Deq.N+1
            if i == 1
                if bound_cond_type == "D"
                    coef[i, :] .= [0, 1, 0]
                elseif bound_cond_type == "N"
                    coef[i, :] .= [0, -1/dx, 1/dx]
                end
            elseif i == N+1
                if bound_cond_type == "D"
                    coef[i, :] .= [0, 1, 0]
                elseif bound_cond_type == "N"
                    coef[i, :] .= [-1/dx, 1/dx, 0]
                end
            else
                a_i1 = (k(Sol[t-1, i]) + k(Sol[t-1, i-1])) / 2
                a_i2 = (k(Sol[t-1, i+1]) + k(Sol[t-1, i])) / 2
                A = -a_i1 / dx^2
                B = 1/dt + (a_i1 + a_i2) / dx^2
                C = - a_i2 / dx^2

                coef[i, :] .= [A, B, C]
            end
        end

        b = [Sol[t-1, i]/dt + g(Sol[t-1, i]) for i in 1:N+1]
        b[begin] = Sol[t, begin]
        b[end] = Sol[t, end]

        return new(N, coef, b)
    end

end;