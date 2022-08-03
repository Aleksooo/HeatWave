function test()
    p = HeatWaveProblem(; σ=0.5)
    s = ImplicitSolver(; N=21)

    solve!(p, s; M=21)

    draw_frame(11)

    return nothing
end
