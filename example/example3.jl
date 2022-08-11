using HeatWave

function series_0_5()
    p = HeatWaveProblem()
    u = create_u_target(p)

    open("data1.txt", "r") do f
        draw_series([5, 11, 19]; io=f, fn=u)
    end

    return nothing
end

series_0_5()
