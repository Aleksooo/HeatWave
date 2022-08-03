function gen_lb(t::Int)
    return "t = "*string(t)
end

function gen_lb(series::Vector{Int})
    return ["t = "*string(t) for t in series]
end

"""
    function draw_frame(
        t::Int;
        folder::AbstractString="output",
        is_save::Bool=false,
        seriestype::Symbol=:scatter,
        lw::Real=1.5
    )

Visual function `u` on the `t` time layer. Get data from `folder`. Save to `folder`.

# Arguments
- `t::Int`: number of time layer

# Keywords
- `folder::AbstractString="output"`: folder with data to plot
- `is_save::Bool=false`: flag for saving plot picture (to the `folder`)
- `seriestype::Symbol=:scatter`: symbol for data visualisation
    (make sence only with `:scatter` and `:line`)
- `lw::Real=1.5`: width of symbols

# Throws
- `Time out of range!`: if number `t` is greater than total number of time layers

# Returns
- `nothing`: return in case of successful ploting
"""
function draw_frame(
    t::Int;
    folder::AbstractString="output",
    is_save::Bool=false,
    seriestype::Symbol=:scatter,
    lw::Real=1.5
)
    log = read_log(; folder=folder)
    data = read_solution(; folder=folder)

    if t > log.M
        error("Time out of range!")
    end

    x = range(log.x_left, log.x_right; length=log.N)
    println("Drawing plot")

    pl = plot(
        x,
        data[t, :],
        label=gen_lb(t),
        xlabel="x",
        ylabel="u(x)",
        seriestype=seriestype,
        lw=lw,
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
    series::Vector{Int};
    folder::AbstractString="output",
    is_save::Bool=false,
    seriestype::Symbol=:scatter,
    lw::Real=1.5,
)
    log = read_log(; folder=folder)
    data = read_solution(; folder=folder)

    for t in series
        if t > log.M
            error("Time out of range!")
        end
    end

    x = range(log.x_left, log.x_right; length=log.N)
    println("Drawing plot")

    pl = plot(
        x,
        data[series[begin], :],
        label=gen_lb(series[begin]),
        xlabel="x", ylabel="u(x)",
        seriestype=seriestype,
        lw=lw,
    )

    for t in series[2:end]
        plot!(x, data[t, :], label=gen_lb(t), seriestype=seriestype, lw=lw)
    end

    display(pl)
    if is_save
        savefig(pl, folder)
    end

    return nothing
end
