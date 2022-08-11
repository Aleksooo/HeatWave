"""
    HeatWaveProblem([; kappa=1.0, σ=2.0, u0=1.0, x_left=0.0, x_right=1.0])

Problem of spreading heat wave. It is described using a differential equation
that has a form

    ∂u/∂t = ∂(k*∂u/∂x)/∂x; x ∈ [x_left, x_right], t ∈ [0, finish_time],

where k =  k(u) = `kappa` * u^`σ`, finish_time = (x_right - x_left) / wavespeed,
    wavespeed = sqrt(`kappa` * `u0`^`σ` / `σ`)

with initial condition

    u(x, 0) = 0

and boundary conditions

    u(x_left, t) = u0 * t^(1/σ)
    u(x_right, t) = 0
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
        kappa::Real=1,
        σ::Real=0.5,
        u0::Real=1,
        x_left::Real=0,
        x_right::Real=1,
    )
        wavespeed = sqrt(kappa * u0^σ / σ)
        finish_time = (x_right - x_left) / wavespeed

        u_init = x -> 0
        u_left = t -> u0 * t^(1 / σ)
        u_right = t -> 0
        k = u -> kappa * u^σ

        return new{Float64}(
            float.((
                kappa,
                σ,
                u0,
                x_left,
                x_right,
            ))...,
            finish_time,
            u_init,
            u_left,
            u_right,
            k,
        )
    end
end

"""
    create_u_target(problem::HeatWaveProblem)

Function obtained as a result of the analytical solution

# Arguments

- `problem::HeatWaveProblem`: problem to get the coefficients for the function

# Returns

- `Function`: returns function from two variables x and t
"""
function create_u_target(problem::HeatWaveProblem)
    wavespeed = sqrt(problem.kappa * problem.u0^problem.σ / problem.σ)

    return function (x, t)
        if 0 <= x <= wavespeed * t
            return problem.u0 * (t - x / wavespeed)^(1 / problem.σ)
        else
            return 0
        end
    end
end
