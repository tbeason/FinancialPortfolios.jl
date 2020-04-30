"""
`FinancialPortfolios`

A minimalist Julia package for working with simple portfolios of financial assets.
"""
module FinancialPortfolios


export FinancialPortfolio
export portfolioreturn, update!
export names, weights














"""
`FinancialPortfolio`

A (possibly named) collection of portfolio weights.
Weights can be an dictionary-like object matching asset identifiers with weights or just a vector of weights.

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
end
# T should be <:AbstractDict or AbstractDictionary or Vector

"""
`names(fp::FinancialPortfolio)`

Recover the names or identifiers of the assets in the portfolio.
"""
names(fp::FinancialPortfolio) = collect(keys(fp.positions))




"""
`weights(fp::FinancialPortfolio)`

Recover the weights of the assets in the portfolio (as a fraction of total value).
"""
weights(fp::FinancialPortfolio) = fp.positions




"""
`portfolioreturn(fp::FinancialPortfolio,ret)`

Compute the portfolio return. If the portfolio has named weights, the returns should as well.

```

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
"""
function update!(fp::FinancialPortfolio,ret)
    portreturn = portfolioreturn(fp,ret)
    
    for k in eachindex(fp.positions)
        fp.positions[k] = fp.positions[k] * (1+ret[k])
    end
    normalize!(fp)
    return portreturn
end



function normalize!(fp::FinancialPortfolio)
    fac = sum(values(fp.positions))
    for k in eachindex(fp.positions)
        fp.positions[k] = fp.positions[k] / fac
    end
    return nothing
end

# add custom Base.show for pretty printing
# should add inner constructor to normalize weights upon construction
# need a method to check names match
# add copy, similar, ==, ...?
# forward things like size, length, ...?

end # module
