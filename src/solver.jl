function init!(solver::ImplicitSolver, problem::HeatWaveProblem)
    solver.u_curr .= map(problem.u_init, solver.space_grid)

    return nothing
end

function eval_coeff!(solver::ImplicitSolver, problem::HeatWaveProblem; dt)
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

function step!(solver::AbstractSolver, problem::HeatWaveProblem; iter::Int, dt)
    solver.u_prev .= solver.u_curr
    time = (iter - 1) * dt
    solver.u_prev[begin] = problem.u_left(time)
    solver.u_prev[end] = problem.u_right(time)

    eval_coeff!(solver, problem; dt=dt)
    solver.u_curr .= solver.matrix \ solver.u_prev

    return nothing
end

function solve!(problem::HeatWaveProblem, solver::AbstractSolver; M::Int, io=stdout)
    time_grid = range(0, problem.finish_time; length=M)
    dt = step(time_grid)

    write_log(;
        x_left=problem.x_left,
        x_right=problem.x_right,
        N=solver.N,
        finish_time=problem.finish_time,
        M=M
    )

    println("Evaluating...")
    init!(solver, problem)
    write_solution(solver; iter=0)

    for j in 2:M
        step!(solver, problem; iter=j, dt=dt)
        write_solution!(solver; iter=j)
    end

    println("Success!")
    return nothing
end
