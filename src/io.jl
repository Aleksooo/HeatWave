function write_solution(solver::AbstractSolver; iter::Int, folder::AbstractString="output")
    data = joinpath(folder, "data.txt")
    data_file = open(data, "w")

    write(data_file, "# Iteration: "*string(iter)*"\n")
    writedlm(data_file, solver.u_curr', '\t')

    close(data_file)

    return nothing
end

function write_solution!(solver::AbstractSolver; iter::Int, folder::AbstractString="output")
    data = joinpath(folder, "data.txt")
    data_file = open(data, "a")

    write(data_file, "# Iteration: "*string(iter)*"\n")
    writedlm(data_file, solver.u_curr', '\t')

    close(data_file)

    return nothing
end

function write_log(
    problem::HeatWaveProblem, solver::AbstractSolver;
    M::Int, folder::AbstractString="output"
)
    log = joinpath(folder, "log.txt")
    log_file = open(log, "w")

    dt = problem.finish_time / (M -1)
    str = join([
        problem.x_left,
        problem.x_right,
        solver.N,
        solver.dx
    ], '\t')*'\n'*join([
        problem.finish_time,
        M,
        dt,
    ], '\t')*'\n'

    write(log_file, str)

    close(log_file)

    return str
end

function read_solution(; folder::AbstractString="output")
    data = joinpath(folder, "data.txt")

    if !isfile(data)
        error("Wrong directory or files don't exist!")
    end

    data_matrix = readdlm(data; comments=true)

    return data_matrix
end

function read_log(; folder::AbstractString="output")
    log = joinpath(folder, "log.txt")

    if !isfile(log)
        error("Wrong directory or files don't exist!")
    end

    log_matrix = readdlm(log)

    return ConvertConfig(log_matrix)
end

function ConvertConfig(log_matrix::Matrix)
    x_left, x_right, N, dx, finish_time, M, dt = log_matrix'

    return (
        x_left=x_left,
        x_right=x_right,
        N=trunc(Int, N),
        dx=dx,
        finish_time=finish_time,
        M=trunc(Int, M),
        dt=dt,
    )
end
