using HeatWave

function series_2()
    p = HeatWaveProblem(; σ=2)
    u = actual_u(p)

    open("data2.txt", "r") do f
        draw_series([4, 11, 19]; io=f, fn=u)
    end

    return nothing
end

series_2()
