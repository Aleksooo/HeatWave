"""
    ImplicitSolver(; N::Int[, x_left=0.0, x_right=1.0])

Implicit solver for equation

    ∂u/∂t = ∂(k*∂u/∂x)/∂x; x ∈ [x_left, x_right], t ∈ [0, finish_time]
    u(0, t)
    u(x_left, t)
    u(x_right, t)
"""
struct ImplicitSolver{T} <: AbstractSolver
    N::Int
    dx::T

    space_grid::Vector{T}
    u_curr::Vector{T}
    u_prev::Vector{T}

    matrix::Tridiagonal{T}

    function ImplicitSolver(; N::Int, x_left::Real=0, x_right::Real=1)
        space_grid = range(x_left, x_right; length=N)
        u_curr = Vector{Float64}(undef, N)
        u_prev = similar(u_curr)

        d = similar(u_curr)
        dl = similar(u_curr, Float64, N-1)
        du = similar(dl)
        matrix = Tridiagonal(dl, d, du)

        return new{Float64}(N, float(step(space_grid)), space_grid, u_curr, u_prev, matrix)
    end
end

function init!(solver::ImplicitSolver, problem::HeatWaveProblem)
    solver.u_curr .= problem.u_init.(solver.space_grid)

    return nothing
end

function calc_coeff!(solver::ImplicitSolver, problem::HeatWaveProblem; dt)
    N = solver.N
    dx = solver.dx
    k = problem.k

    # solver.matrix[1, 1:2] .= (1, 0)
    solver.matrix[1, 1] = 1
    solver.matrix[1, 2] = 0
    for i in 2:N-1
        aᵢ = (k(solver.u_prev[i-1]) + k(solver.u_prev[i])) / 2
        aᵢ₊₁ = (k(solver.u_prev[i]) + k(solver.u_prev[i+1])) / 2

        A = -aᵢ * dt / dx^2
        B = 1 + (aᵢ + aᵢ₊₁) * dt / dx^2
        C = -aᵢ₊₁ * dt / dx^2

        # solver.matrix[i, i-1:i+1] .= (A, B, C)
        solver.matrix[i, i-1] = A
        solver.matrix[i, i] = B
        solver.matrix[i, i+1] = C
    end
    # solver.matrix[N, N-1:N] .= (0, 1)
    solver.matrix[N, N-1] = 0
    solver.matrix[N, N] = 1

    return nothing
end

function step!(solver::ImplicitSolver, problem::HeatWaveProblem; iter::Int, dt)
    solver.u_prev .= solver.u_curr
    time = (iter - 1) * dt
    solver.u_prev[begin] = problem.u_left(time)
    solver.u_prev[end] = problem.u_right(time)

    calc_coeff!(solver, problem; dt=dt)
    solver.u_curr .= solver.matrix \ solver.u_prev  # Write/find more optimal way

    return nothing
end
