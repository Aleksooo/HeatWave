function DrawPlot(Deq::DEquation; t::Int)
    if t > Deq.T+1
        error("Time out of range!")
    end
    x = range(0, Deq.N*Deq.dx, Deq.N+1)

    plot(x, Deq.SolMat[t, :])
end;

function DrawPlotAnim(Deq::DEquation; FPS::Int=10, step::Int=1)
    x = range(0, Deq.N*Deq.dx, Deq.N+1)
    anim = @animate for t = 1:step:Deq.T+1 
        plot(x, Deq.SolMat[t, :], title=string(round(t*Deq.dt; digits=3)), legend=false)
    end

    gif(anim, "TempWavePlot.gif", fps=FPS)
end;

function DrawHeatmap(Deq::DEquation; t::Int)
    data = Deq.SolMat[t, :]

    heatmap([data;; data]')
end;

function DrawHeatmapAnim(Deq::DEquation; FPS::Int=10, step::Int=1)
    x = range(0, Deq.N*Deq.dx, Deq.N+1)
    anim = @animate for t = 1:step:Deq.T+1 
        data = Deq.SolMat[t, :]
        heatmap([data;; data]', title=string(round(t*Deq.dt; digits=3)))
    end

    gif(anim, "TempWaveMap.gif", fps=FPS)
end;