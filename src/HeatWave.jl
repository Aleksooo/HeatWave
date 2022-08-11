module HeatWave

export HeatWaveProblem
export ImplicitSolver
export actual_u
export solve!
export draw_frame, draw_series

using LinearAlgebra
using Plots

include("problem.jl")
include("abstract_solver.jl")
include("implicit_solver.jl")
include("io.jl")
include("visual.jl")

end # module
