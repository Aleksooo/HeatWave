#= module HeatWave

export HeatWaveProblem
export ImplicitSolver
export solve!
# export read_log, read_solution
export draw_frame
export test
=#
println("Load")

using LinearAlgebra
using DelimitedFiles
using Plots

include("problem.jl")
include("solver_structures.jl")
include("io.jl")
include("solver.jl")
include("visual.jl")
include("../example/test1.jl")

#end # module
# include("src/HeatWave.jl"); using .HeatWave; include("example/test1.jl"); test()
