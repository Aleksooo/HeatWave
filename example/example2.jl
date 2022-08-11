using HeatWave

function frame_2()
    p = HeatWaveProblem(; σ=2)
    u = actual_u(p)

    open("data2.txt", "r") do f
        draw_frame(15; io=f, fn=u)
    end

    return nothing
end

frame_2()
