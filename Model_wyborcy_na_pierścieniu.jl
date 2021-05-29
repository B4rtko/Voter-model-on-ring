using CSV, DataFrames, Plots, Random

function MCStep(S, N)
    listeners = rand(1:N, N)
    speakers = rand([-1, 1], N)
    for i in 1:N
        S[listeners[i]] = S[(listeners[i]+speakers[i]-1+N)%N+1]
    end
end

function process(N, x, L)
    S = ones(N)
    S[randcycle(N)[1:Int(((N-N*x))÷1)]] .= -1
    if all(S.==1)
        return [1, 0]
    elseif all(S.==-1)
        result = [0, 0]
        return result
    end

    for i in 1:L
        MCStep(S, N)
        if all(S.==1)
            return [1, i]
        elseif all(S.==-1)
            return [0, i]
        end
    end
    return [0, L]
end

function program_run(N, Δx, L)  # liczba agentów, koncentracja pozytywnych opinii, kroki MC
    x = reshape(0:Δx:1, :, 1)
    result = zeros(size(x)[1], 2)
    M = 10000
    for i in 1:size(x)[1]
        println(string(i, "/", size(x)[1]))
        for j in 1:M
            result[i,:] += process(N, x[i], L)
        end
    end
    return cat(x, result./M, dims=2)
end


result = program_run(100, 0.02, 1000)

df = DataFrame(result, ["x", "P+", "thau"])

CSV.write("Semestr_4\\Fizyka_ukladów_złożonych\\Model_wyborcy_na_pierścieniu\\N100dx0.02L1000.csv", df)
