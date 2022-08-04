"""
    init!(solver::ImplicitSolver, problem::HeatWaveProblem)

Initializes `solver` by setting the values of inition condition function `problem.u_init(x)`
in nodes of space grid as `solver.u_curr`
"""
function init!(solver::ImplicitSolver, problem::HeatWaveProblem)
    solver.u_curr .= map(problem.u_init, solver.space_grid)

    return nothing
end

"""
    calc_coeff!(solver::ImplicitSolver, problem::HeatWaveProblem; dt)

Calculate the coefficient matrix in a recurrent formula for an implicit finite-difference
scheme for all spatial nodes on a particular time layer using the formula:

    A * uʲᵢ₋₁ + B * uʲᵢ + C * uʲᵢ₊₁,

where i∈[1, N] - space nodes; j∈[1, M] - particular time layer
- A = -aᵢ * dt / dx^2
- B = 1 + (aᵢ + aᵢ₊₁) * dt / dx^2
- C = -aᵢ₊₁ * dt / dx^2

where aᵢ and aᵢ₊₁ are values of function `problem.k` which are calculated by the formulas
- aᵢ = (k(uʲᵢ₋₁) + k(uʲᵢ)) / 2
- aᵢ₊₁ = (k(uʲᵢ) + k(uʲᵢ₊₁)) / 2
"""
function calc_coeff!(solver::ImplicitSolver, problem::HeatWaveProblem; dt)
    N = solver.N
    dx = solver.dx
    k = problem.k

    for i in 1:N
        if i == 1
            solver.matrix[i, i:i+1] .= [1, 0]
        elseif i == N
            solver.matrix[i, i-1:i] .= [0, 1]
        else
            aᵢ = (k(solver.u_prev[i-1]) + k(solver.u_prev[i])) / 2
            aᵢ₊₁ = (k(solver.u_prev[i]) + k(solver.u_prev[i+1])) / 2

            A = -aᵢ * dt / dx^2
            B = 1 + (aᵢ + aᵢ₊₁) * dt / dx^2
            C = -aᵢ₊₁ * dt / dx^2

            solver.matrix[i, i-1:i+1] .= [A, B, C]
        end
    end

    return nothing
end

"""
    step!(solver::AbstractSolver, problem::HeatWaveProblem; iter::Int, dt)

Makes a step from previous to current layer. Takes into account boundary condition.
Calls function of evaluation of coefficient matrix. Solve system of linear equations.
"""
function step!(solver::AbstractSolver, problem::HeatWaveProblem; iter::Int, dt)
    solver.u_prev .= solver.u_curr
    time = (iter - 1) * dt
    solver.u_prev[begin] = problem.u_left(time)
    solver.u_prev[end] = problem.u_right(time)

    calc_coeff!(solver, problem; dt=dt)
    solver.u_curr .= solver.matrix \ solver.u_prev

    return nothing
end

"""
    solve!(
        problem::HeatWaveProblem, solver::AbstractSolver;
        M::Int, folder::AbstractString="output"
    )

Solve `problem` using `solver`. Creates a time grid consisting of `M` nodes. By defaul
save all to "output" folder.

# Arguments
- `problem::HeatWaveProblem`: the heatwave problem that will be solved
- `solver::AbstractSolver`: solver that will be applied for solving

# Keywords
- `M::Int`: number of time layers
- `folder::AbstractString="output"`: folder for saving data

# Returns
- `nothing`: return in case of successful completion of calculations
"""
function solve!(
    problem::HeatWaveProblem, solver::AbstractSolver;
    M::Int, folder::AbstractString="output"
)
    time_grid = range(0, problem.finish_time; length=M)
    dt = step(time_grid)

    write_log(problem, solver; M=M, folder=folder)

    println("Evaluating...")
    init!(solver, problem)
    write_solution(solver; iter=0, folder=folder)

    for j in 2:M
        step!(solver, problem; iter=j, dt=dt)
        write_solution!(solver; iter=j, folder=folder)
    end

    println("Success!")
    return nothing
end
