function DrawPlot(Sol::DSolution; t::Int, fn::Function=(x, t)->0)
    if t > Sol.T+1
        error("Time out of range!")
    end
    x = range(0, Sol.N*Sol.dx, Sol.N+1)
    τ = fill((t-1)*Sol.dt, Sol.N+1)

    plot(x, Sol.SolMat[t, :])
    plot!(x, map(fn, x, τ))
end;

function DrawPlotAnim(Sol::DSolution; FPS::Int=10, step::Int=1, fn::Function=(x, t)->0, folder::AbstractString="output")
    x = range(0, Sol.N*Sol.dx, Sol.N+1)
    anim = @animate for t = 1:step:Sol.T+1
        τ = fill((t-1)*Sol.dt, Sol.N+1)
        plot(x, Sol.SolMat[t, :], title="t = "*string(round(t*Sol.dt; digits=3)), legend=false)
        plot!(x, map(fn, x, τ))
    end

    path = joinpath(folder, "TempWavePlot.gif")
    gif(anim, path, fps=FPS)
end;

function DrawHeatmap(Sol::DSolution; t::Int)
    data = Sol.SolMat[t, :]

    heatmap([data;; data]')
end;

function DrawHeatmapAnim(Sol::DSolution; FPS::Int=10, step::Int=1, folder::AbstractString="output")
    # x = range(0, Sol.N*Sol.dx, Sol.N+1)
    anim = @animate for t = 1:step:Sol.T+1 
        data = Sol.SolMat[t, :]
        heatmap([data;; data]', title="t = "*string(round(t*Sol.dt; digits=3)))
    end

    path = joinpath(folder, "TempWaveMap.gif")
    gif(anim, path, fps=FPS)
end;