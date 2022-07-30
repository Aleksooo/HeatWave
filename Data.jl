function SaveData(eq::DSolution; folder::AbstractString="output")
    config = joinpath(folder, "config.txt")
    data = joinpath(folder, "data.txt")

    if !isfile(config) || !isfile(data)
        mkpath(folder)
        touch(config)
        touch(data)
    end

    config_file = open(config, "w")
    data_file = open(data, "w")
    
    write(config_file, MakeConfig(eq))
    writedlm(data_file, eq.SolMat)

    close(config_file)
    close(data_file)
end;

function MakeConfig(eq::DSolution)
    len = join([eq.l, eq.N, eq.dx], '\t')*'\n'
    time = join([eq.τ, eq.T, eq.dt], '\t')*'\n'
    return len*time
end;

function ReadData(;folder::AbstractString="output")
    config = joinpath(folder, "config.txt")
    data = joinpath(folder, "data.txt")

    if !isfile(config) || !isfile(data)
        error("Wrong directory or files don't exist!")
    end
    
    config_mat = readlm(config)
    data_mat = readlm(data)

    close(config_file)
    close(data_file)

    return DSolution(ConvertConfig(config_mat), data_mat)
end;

function ConvertConfig(config_mat::Matrix{Float64})
    l, N, dx, τ, T, dt = config_mat'
    return l, N, dx, τ, T, dt
end;