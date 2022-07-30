function U(x, t; u_0::Real=1, σ::Real=1, κ_0::Real=1)
    n = 1/σ
    D = sqrt(κ_0 * u_0^σ / σ)

    if 0 <= x <= D*t
        return u_0 * (t - x/D)^n
    else
        return 0
    end
end

function ModelHeatWave(dx, dt; u_0::Real=1, σ::Real=1, κ_0::Real=1)
    n = 1/σ
    D = sqrt(κ_0 * u_0^σ / σ)
    println("D - ", D)

    space = (1, dx)
    time = (1/D, dt)

    k_f = f->κ_0 * f^σ
    g_f = f->0
    f_x_t0 = x->0
    f_t_x0 = t->u_0 * t^n
    f_t_xN = t->0

    eq = DEquation(space, time; k_f=k_f, g_f=g_f, f_x_t0=f_x_t0, f_t_x0=f_t_x0, f_t_xN=f_t_xN)
    sol = NDSolveImp(eq)

    return sol
end

function DrawHeatWavePlot(dx, dt; u_0::Real=1, σ::Real=1, κ_0::Real=1, FPS::Int=10, step::Int=1, folder::AbstractString="output")
    Sol = ModelHeatWave(dx, dt; u_0=u_0, σ=σ, κ_0=κ_0)

    DrawPlotAnim(Sol; FPS=FPS, step=step, 
                 fn=(x, t)->U(x, t; u_0=u_0, σ=σ, κ_0=κ_0),
                 folder=folder)
end

function DrawHeatWaveMap(dx, dt; u_0::Real=1, σ::Real=1, κ_0::Real=1, FPS::Int=10, step::Int=1, folder::AbstractString="output")
    Sol = ModelHeatWave(dx, dt; u_0=u_0, σ=σ, κ_0=κ_0)

    DrawHeatmapAnim(Sol; FPS=FPS, step=step, folder=folder)
end