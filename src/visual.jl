function create_label(t::Int)
    return "t = "*string(t)
end

function create_label(series::Vector{Int})
    return ["t = "*string(t) for t in series]
end

"""
    function draw_frame(
        t::Int;
        folder::AbstractString="output",
        is_save::Bool=false,
        lw::Real=1.5
    )

Visual function `u` on the `t` time layer. Get data from `folder`. Save to `folder`.

# Arguments
- `t::Int`: number of time layer

# Keywords
- `folder::AbstractString="output"`: folder with data to plot
- `is_save::Bool=false`: flag for saving plot picture (to the `folder`)
- `lw::Real=1.0`: width of the line plot
- `sw::Real=0.5`: width of the scatter plot
- `fn::Union{Function, Nothing}=nothing`: function of analytical solution

# Throws
- `Time out of range!`: if number `t` is greater than total number of time layers

# Returns
- `nothing`: return in case of successful ploting
"""
function draw_frame(
    t::Int;
    io::IO=stdout,
    is_save::Bool=false,
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
    if is_save
        savefig(pl, folder)
    end

    return nothing
end;

"""
    function draw_series(
        series::Vector{Int};
        folder::AbstractString="output",
        is_save::Bool=false,
        seriestype::Symbol=:scatter,
        lw::Real=1.5,
    )

Visual function `u` on the time layers from `series`. Get data from `folder`.
    Save to `folder`.

# Arguments
- `series::Vector{Int}`: vector with number of time layers

# Keywords
- `folder::AbstractString="output"`: folder with data to plot
- `is_save::Bool=false`: flag for saving plot picture (to the `folder`)
- `seriestype::Symbol=:scatter`: symbol for data visualisation
    (make sence only with `:scatter` and `:line`)
- `lw::Real=1.5`: width of symbols

# Throws
- `Time out of range!`: if any numbers `t` is greater than total number of time layers

# Returns
- `nothing`: return in case of successful ploting
"""
function draw_series(
    series::Union{AbstractVector{Int}, AbstractRange{Int}};
    io::IO=stdout,
    is_save::Bool=false,
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
    if is_save
        savefig(pl, folder)
    end

    return nothing
end
