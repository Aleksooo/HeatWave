"""
    AbstractSolver

Type of an abstract solver
"""
abstract type AbstractSolver end

init!(solver::AbstractSolver, problem::HeatWaveProblem) = error("Choose type of solver
    to initialize!")

step!(solver::AbstractSolver, problem::HeatWaveProblem; iter::Int, dt) = error("Can't make
    a step for abstract solver!")


"""
    solve!(
        problem::HeatWaveProblem, solver::AbstractSolver;
        M::Int, folder::AbstractString="output"
    )

Solve `problem` using `solver`. Creates a time grid consisting of `M` nodes.

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
    M::Int, io::IO=stdout
)
    time_grid = range(0, problem.finish_time; length=M)
    dt = step(time_grid)

    write_config(problem, solver; M=M, io=io)

    println(stderr, "Evaluating...")
    init!(solver, problem)
    write_solution(solver; iter=1, io=io)

    for j in 2:M
        step!(solver, problem; iter=j, dt=dt)
        write_solution(solver; iter=j, io=io)
    end

    println(stderr, "Success!")
    return nothing
end
