function create_label(t::Int)
    return "t = "*string(t)
end

function create_label(series::Vector{Int})
    return ["t = "*string(t) for t in series]
end

"""
    function draw_frame(
        t::Int[;
        io::IO=stdout,
        lw::Real=1.0,
        sw::Real=0.5,
        fn::Union{Function, Nothing}=nothing,]
    )

Visual function `u` on the `t` time layer. Get data from `io`.

# Arguments

- `t::Int`: number of time layer

# Keywords

- `io::IO=stdout`: IO stream with data to plot
- `lw::Real=1.0`: width of the line plot
- `sw::Real=0.5`: width of the scatter plot
- `fn::Union{Function, Nothing}=nothing`: function of analytical solution

# Throws

- `Time out of range!`: if number `t` is greater than total number of time layers
"""
function draw_frame(
    t::Int;
    io::IO=stdout,
    #is_save::Bool=false,
    lw::Real=1.0,
    sw::Real=0.5,
    fn::Union{Function, Nothing}=nothing,
)
    config, solution = read_data(io)

    if t > config.M
        error("Time out of range!")
    end

    x = range(config.x_left, config.x_right; length=config.N)
    time = (t - 1) * config.dt

    println("Drawing plot")
    pl = plot(xlabel="x", ylabel="u(x)")

    if !(fn == nothing)
        y = [fn(i, time) for i in x]
        plot!(x, y, label="u(x, "*string(t)*")", lw=lw)
    end

    plot!(
        x,
        solution[t, :],
        label=create_label(t),
        seriestype=:scatter,
        lw=sw,
    )

    display(pl)
    #=
    if is_save
        savefig(pl, folder)
    end
    =#
    return nothing
end;

"""
    function draw_series(
        series::Union{AbstractVector{Int}, AbstractRange{Int}};
        io::IO=stdout,
        lw::Real=1.0,
        sw::Real=0.5,
        fn::Union{Function, Nothing}=nothing,
    )

Visual function `u` on the time layers from `series`. Get data from `io`.

# Arguments

- `series::Vector{Int}`: vector with number of time layers

# Keywords

- `io::IO=stdout`: IO stream with data to plot
- `lw::Real=1.0`: width of the line plot
- `sw::Real=0.5`: width of the scatter plot
- `fn::Union{Function, Nothing}=nothing`: function of analytical solution

# Throws

- `Time out of range!`: if any numbers `t` is greater than total number of time layers
"""
function draw_series(
    series::Union{AbstractVector{Int}, AbstractRange{Int}};
    io::IO=stdout,
    #is_save::Bool=false,
    lw::Real=1.0,
    sw::Real=0.5,
    fn::Union{Function, Nothing}=nothing,
)
    config, solution = read_data(io)

    for t in series
        if t > config.M
            error("Time out of range!")
        end
    end

    x = range(config.x_left, config.x_right; length=config.N)

    println("Drawing plot")
    pl = plot(xlabel="x", ylabel="u(x)")

    for t in series
        time = (t - 1) * config.dt

        if !(fn == nothing)
            y = [fn(i, time) for i in x]
            plot!(x, y, label="u(x, "*string(t)*")", lw=lw)
        end

        plot!(x, solution[t, :], label=create_label(t), seriestype=:scatter, lw=sw)
    end

    display(pl)
    #=
    if is_save
        savefig(pl, folder)
    end
    =#
    return nothing
end
