module HeatWave

export HeatWaveProblem
export ImplicitSolver
export create_u_target
export solve!
export draw_frame, draw_series
export frame_2, frame_0_5, series_2, series_0_5

using LinearAlgebra
# using DelimitedFiles
using Plots

include("problem.jl")
include("abstract_solver.jl")
include("implicit_solver.jl")
include("io.jl")
include("visual.jl")
include("../example/examples.jl")

end # module

#=
using Revise
using HeatWave
=#
