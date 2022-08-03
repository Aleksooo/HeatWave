function draw_frame(t::Int; folder::AbstractString="output")
    log = read_log(; folder=folder)
    data = read_solution(; folder=folder)

    if t > log.M
        error("Time out of range!")
    end

    x = range(log.x_left, log.x_right; length=log.N)

    println("Drawing plot")
    plot(x, data[t, :])

    return nothing
end;
