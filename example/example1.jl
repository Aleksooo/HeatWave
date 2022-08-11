using HeatWave

function frame_0_5()
    p = HeatWaveProblem()
    u = actual_u(p)

    open("data1.txt", "r") do f
        draw_frame(15; io=f, fn=u)
    end

    return nothing
end

frame_0_5()
