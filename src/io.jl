function write_config(
    problem::HeatWaveProblem, solver::AbstractSolver;
    M::Int, io::IO=stdout
)
    dt = problem.finish_time / (M -1)

    write(io, "Config\n")
    # Writing parameters of space grid
    write(io, "x_left: $(problem.x_left)\n")
    write(io, "x_right: $(problem.x_right)\n")
    write(io, "N: $(solver.N)\n")
    write(io, "dx: $(solver.dx)\n#\n")

    # Writing parameters of time grid
    write(io, "finish_time: $(problem.finish_time)\n")
    write(io, "M: $(M)\n")
    write(io, "dt: $(dt)\n#\n")
    write(io, "Solution\n")

    return nothing
end

function write_solution(
    solver::AbstractSolver;
    iter::Int, io::IO=stdout
)
    write(io, "# Iteration: $(iter)\n")
    write(io, join(solver.u_curr, '\t')*"\n")

    return nothing
end

function read_data(io::IO)
    delim_config = ": "
    delim_solution = "\t"
    comment = '#'

    config_line = "Config"
    config_flag = false
    key, value = [], []

    solution_line = "Solution"
    solution_flag = false
    solution_vector = []
    count = 1

    line = readline(io)
    while line != ""
        if line[1] == comment
            line = readline(io)
            continue
        elseif line == config_line
            config_flag = true
            solution_flag = false

            line = readline(io)
            continue
        elseif line == solution_line
            config_flag = false
            solution_flag = true

            line = readline(io)
            continue
        end

        if config_flag
            # println(line)
            k, v = split(line, delim_config)
            push!(key, Symbol(k))
            push!(value, parse_num(v))
        elseif solution_flag
            data = split(line, delim_solution)
            push!(solution_vector, parse.(Float64, data))
            count += 1
        end

        line = readline(io)
    end

    config = (; zip(key, value)...)
    matrix = convert_vector(solution_vector)

    return config, matrix
end

function read_config(io::IO)
    config_vector = Vector(undef, 7)
    count = 1

    while count < 7
        line = readline(io)
        if line[1] != "#"
            println(line)
            config_vector[count] = split(line, ": ")[2]
            count += 1
        end
    end

    return Config(config_vector)
end



function read_solution(; io::IO)
    data_matrix = readdlm(data; comments=true)

    return data_matrix
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

function parse_num(str::AbstractString)
    if contains(str, '.')
        return parse(Float64, str)
    else
        return parse(Int64, str)
    end
end

function convert_vector(arr::AbstractVector)
    M, N = size(arr)[1], size(arr[1])[1]
    matrix = zeros(M, N)
    for i in 1:M
        matrix[i, :] .= arr[i]
    end

    return matrix
end
