"""
    AbstractSolver

Type of abstract solver
"""
abstract type AbstractSolver end


"""
    ImplicitSolver{T} <: Solver

Solver implementation for implicit finite difference schemes

# Fields
- `space_grid::Vector{T}`: vector with nodes of space grid
- `u_curr::Vector{T}`: vector with values of function u in the space grid nodes
    on the current time layer
- `u_prev::Vector{T}`: vector with values of function u in the space grid nodes
    on the previous time layer
- `matrix::Tridiagonal{T}`: matrix of a system of linear equations to find values of u
    in current time layer
"""
struct ImplicitSolver{T} <: AbstractSolver
    N::Int
    dx::T

    space_grid::Vector{T}
    u_curr::Vector{T}
    u_prev::Vector{T}

    matrix::Tridiagonal{T}

    function ImplicitSolver(; N::Int, x_left::T=0.0, x_right::T=1.0) where {T}
        space_grid = range(x_left, x_right; length=N)
        u_curr = Vector{T}(undef, N)
        u_prev = Vector{T}(undef, N)

        d = Vector{T}(undef, N)
        dl = Vector{T}(undef, N-1)
        du = Vector{T}(undef, N-1)
        matrix = Tridiagonal(dl, d, du)

        return new{T}(N, step(space_grid), space_grid, u_curr, u_prev, matrix)
    end
end
