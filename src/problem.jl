"""
    HeatWaveProblem{T}

Problem of spreading heat wave. It is described using a differential equation
that has a form:

    ∂u/∂t = ∂(k*∂u/∂x)/∂x,

where x∈[0, 1], t∈[0, finish_time]

# Fields
- `kappa::T`: coefficient in the formula of thermal conductivity
- `σ::T`: coefficient which state in the power in the formula of thermal conductivity
- `u0::T`: coefficient in the formula of init condition

- `finish_time::T`: calculation time of our problem

- `u_init::Function`: function of init condition u(0, t) = u0 * t^(1/σ)
- `u_left::Function`: function of left boundary condition u(x, 0) = 0
- `u_right::Function`: function of left boundary condition u(1, 0) = 0
- `k::Function`: function of coefficient of thermal conductivity k(u) = kappa * u^σ
"""
struct HeatWaveProblem{T}
    kappa::T
    σ::T
    u0::T

    x_left::T
    x_right::T
    finish_time::T

    u_init::Function
    u_left::Function
    u_right::Function
    k::Function

    function HeatWaveProblem(;
        kappa::T=1.0,
        σ::T=2.0,
        u0::T=1.0,
        x_left::T=0.0,
        x_right::T=1.0
    ) where {T}
        wavespeed = sqrt(kappa * u0^σ / σ)
        finish_time = (x_right - x_left) / wavespeed

        u_init = x -> 0
        u_left = t -> u0 * t^(1 / σ)
        u_right = t -> 0
        k = u -> kappa * u^σ

        return new{T}(
            kappa,
            σ,
            u0,
            x_left,
            x_right,
            finish_time,
            u_init,
            u_left,
            u_right,
            k
        )
    end
end
