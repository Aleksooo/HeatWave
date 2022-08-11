module HeatWave

export HeatWaveProblem
export ImplicitSolver
export create_u_target
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
