using LinearAlgebra
using Plots

function SolveSlice(sl::Slice)
    alpha_coef = [-sl.coef[1, 3] / sl.coef[1, 2]]
    beta_coef = [sl.b[1] / sl.coef[1, 2]]

    for i in 2:sl.N
        append!(alpha_coef, -sl.coef[i, 3] / (sl.coef[i, 1] * alpha_coef[i-1] + sl.coef[i, 2]))
        append!(beta_coef, (sl.b[i-1] - sl.coef[i, 1] * beta_coef[i-1]) / (sl.coef[i, 1] * alpha_coef[i-1] + sl.coef[i, 2]))
    end

    y = [(sl.b[end] - sl.coef[end, 1] * beta_coef[end]) / (sl.coef[end, 2]+ sl.coef[end, 1] * alpha_coef[end])]
    for i in sl.N:-1:1
        append!(y, alpha_coef[i] * y[end] + beta_coef[i])
    end
    reverse!(y)

    return y
end;

function NDSolve(Deq::DEquation)
    for t in 2:Deq.T+1
        slice = Slice(Deq, t)
        Deq.SolMat[t, :] .= SolveSlice(slice)
    end
end;
