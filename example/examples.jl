"""
    frame_2()

Example. Solves problem with σ=2. Space grid N=21 and time grid M=21. Plots 11th frame.
"""
function frame_2()
    p = HeatWaveProblem()
    s = ImplicitSolver(; N=21)

    solve!(p, s; M=21)

    draw_frame(11)

    return nothing
end

"""
    frame_0_5()

Example. Solves problem with σ=0.5. Space grid N=21 and time grid M=21. Plots 11th frame.
"""
function frame_0_5()
    p = HeatWaveProblem(; σ=0.5)
    s = ImplicitSolver(; N=21)

    solve!(p, s; M=21)

    draw_frame(11)

    return nothing
end

"""
    series_2()

Example. Solves problem with σ=2. Space grid N=21 and time grid M=21.
    Plots 5th, 11th and 19th frames.
"""
function series_2()
    p = HeatWaveProblem()
    s = ImplicitSolver(; N=21)

    solve!(p, s; M=21)

    draw_series([5, 11, 19])

    return nothing
end

"""
    series_0_5()

Example. Solves problem with σ=0.5. Space grid N=21 and time grid M=21.
    Plots 5th, 11th and 19th frames.
"""
function series_0_5()
    p = HeatWaveProblem(; σ=0.5)
    s = ImplicitSolver(; N=21)

    solve!(p, s; M=21)

    draw_series([5, 11, 19])

    return nothing
end
