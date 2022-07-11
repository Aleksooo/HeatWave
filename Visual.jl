function DrawSol(Deq::DEquation; t::Int)
    if t > Deq.T+1
        error("Time out of range!")
    end
    x = range(0, Deq.N*Deq.dx, Deq.N+1)
    plot(x, Deq.SolMat[t, :])
end;

function DrawAnim(Deq::DEquation; FPS::Int)
    x = range(0, Deq.N*Deq.dx, Deq.N+1)
    anim = @animate for t = 1:100:Deq.T+1 
        plot(x, Deq.SolMat[t, :], title=string(t*Deq.dt))
    end

    gif(anim, "TempWave.gif", fps=FPS)
end