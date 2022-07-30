using LinearAlgebra
using Plots

#=
function SolveSlice(sl::Slice)
    alpha_coef = [-sl.coef[1, 3] / sl.coef[1, 2]]
    beta_coef = [sl.b[1] / sl.coef[1, 2]]

    for i in 2:sl.N
        append!(alpha_coef, -sl.coef[i, 3] / (sl.coef[i, 1] * alpha_coef[i-1] + sl.coef[i, 2]))
        append!(beta_coef, (sl.b[i-1] - sl.coef[i, 1] * beta_coef[i-1]) / (sl.coef[i, 1] * alpha_coef[i-1] + sl.coef[i, 2]))
    end

    y = [(sl.b[end] - sl.coef[end, 1] * beta_coef[end]) / (sl.coef[end, 2] + sl.coef[end, 1] * alpha_coef[end])]
    for i in sl.N:-1:1
        append!(y, alpha_coef[i] * y[end] + beta_coef[i])
    end
    reverse!(y)

    return y
end;
=#

function SolveSlice(sl::Slice)
    for i in 1:sl.N+1
        if i == 1
            norm = sl.coef[i, 2]
            sl.b[i] /= norm
            sl.coef[i, :] /= norm
        else
            k = sl.coef[i, 1]
            sl.b[i] -= k * sl.b[i-1]
            sl.coef[i, 2] -= k * sl.coef[i-1, 3]
            sl.coef[i, 1] -= k * sl.coef[i-1, 2]

            norm = sl.coef[i, 2]
            sl.b[i] /= norm
            sl.coef[i, :] /= norm
        end
    end

    for i in sl.N:-1:2
        k = sl.coef[i, 3]
        sl.b[i] -= k * sl.b[i+1]
        sl.coef[i, 3] -= k * sl.coef[i+1, 2]
    end

    return sl.b
end;

function NDSolveExp(Sol::DEquation)
    Sol = Sol.Sol
    for t in 2:Sol.T+1
        slice = Slice(Sol, t)
        Sol.SolMat[t, :] .= SolveSlice(slice)
    end

    return Sol
end;


function NDSolveImp(Deq::DEquation)
    Sol = Deq.Sol
    for t in 2:Sol.T+1
        slice = Slice(Deq, t)
        Sol.SolMat[t, :] .= SolveSlice(slice)
    end

    return Sol
end;
