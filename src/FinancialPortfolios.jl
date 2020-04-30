"""
`FinancialPortfolios`

A minimalist Julia package for working with simple portfolios of financial assets.
"""
module FinancialPortfolios


export FinancialPortfolio
export portfolioreturn, update!
export weights









"""
`FinancialPortfolio`

A (possibly named) collection of portfolio weights.
Weights can be a dictionary-like object matching asset identifiers with weights or just a vector of weights.

_**Example**_
```
w = [0.5, 0.25, 0.25]
FP_vec = FinancialPortfolio(w)

nm = ["a", "b", "c"]
plain_dict = Dict(Iterators.zip(nm,w))
FP_plaindict = FinancialPortfolio(plain_dict)

using Dictionaries
fancy_dict = dictionary(plain_dict)
FP_fancydict = FinancialPortfolio(fancy_dict)
```
"""
struct FinancialPortfolio{T}
    positions::T
    FinancialPortfolio{T}(x) where {T} = new(x)
end
# T should be <:AbstractDict or Dictionaries.AbstractDictionary or AbstractVector
# NamedTuple works except is immutable so breaks update!
FinancialPortfolio(x::T) where {T} = FinancialPortfolio{T}(copyandnormalize(x))





"""
`weights(fp::FinancialPortfolio)`

Recover the weights of the assets in the portfolio (as a fraction of total value).
"""
weights(fp::FinancialPortfolio) = fp.positions




"""
`portfolioreturn(fp::FinancialPortfolio,ret)`

Compute the weighted portfolio return. If the portfolio weights have names or identifiers, the returns should as well.
The portfolio is allowed to contain only a subset of the supplied asset returns, but not the other way around.

_**Example**_
```
w = [0.5, 0.25, 0.25]
r = [0.1, 0.1, -0.1]
FP = FinancialPortfolio(w)
portfolioreturn(FP,r)
```
"""
function portfolioreturn(fp::FinancialPortfolio,ret)
    portreturn = 0.0
    for k in eachindex(fp.positions)
        portreturn += fp.positions[k] * ret[k]
    end
    return portreturn
end



"""
`update!(fp::FinancialPortfolio,ret)`

Updates the weights of the portfolio in place. Returns the period portfolio return.

The portfolio is allowed to contain only a subset of the supplied asset returns, but not the other way around.

_**Example**_
```
w = [0.5, 0.25, 0.25]
r = [0.1, 0.1, -0.1]
FP = FinancialPortfolio(w)
update!(FP,r)
FP
```
"""
function update!(fp::FinancialPortfolio,ret)
    portreturn = portfolioreturn(fp,ret)
    
    for k in eachindex(fp.positions)
        fp.positions[k] = fp.positions[k] * (1+ret[k])
    end
    normalize!(fp)
    return portreturn
end


##################### UNEXPORTED AND/OR EXTENDED BASE METHODS
"""
`FinancialPortfolios.normalize!(fp::FinancialPortfolio)`

Normalize portfolio weights to sum to 1. Used during [`update!`](@ref).
"""
function normalize!(fp::FinancialPortfolio)
    fac = sum(values(fp.positions))
    for k in eachindex(fp.positions)
        fp.positions[k] = fp.positions[k] / fac
    end
    return nothing
end

"""
`FinancialPortfolios.copyandnormalize(x)`

Normalize portfolio weights to sum to 1. Used during construction.
"""
function copyandnormalize(x0)
    x = copy(x0)
    fac = sum(values(x))
    for k in eachindex(x)
        x[k] = x[k] / fac
    end
    return x
end


"""
`keys(fp::FinancialPortfolio)`

Recover the names or identifiers of the assets in the portfolio.
"""
Base.keys(fp::FinancialPortfolio) = collect(keys(fp.positions))



Base.length(fp::FinancialPortfolio) = length(fp.positions)

Base.copy(fp::FinancialPortfolio) = FinancialPortfolio(copy(fp.positions))

function Base.similar(fp::FinancialPortfolio)
    ew = 1 / length(fp.positions)
    # initialize an equal weight portfolio with same keys
    fp2 = copy(fp)
    for k in eachindex(fp2.positions)
        fp2.positions[k] = ew
    end
    return fp2
end

function Base.:(==)(fp1::FinancialPortfolio{T1},fp2::FinancialPortfolio{T2}) where {T1,T2}
    # short circuit if these are the exact same object
    fp1.positions === fp2.positions && return true

    # otherwise check for equality of types, keys, values
    typematch = T1 == T2
    !typematch && return false

    namematch = sort(keys(fp1)) == sort(keys(fp2))
    !namematch && return false

    for k in eachindex(fp1.positions)
        vm_i = fp1.positions[k] == fp2.positions[k]
        if !vm_i
            return false
        end
    end
    
    return true
end






end # module
