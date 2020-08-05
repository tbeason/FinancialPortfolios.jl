# FinancialPortfolios.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/tbeason/FinancialPortfolios.jl.svg?branch=master)](https://travis-ci.com/tbeason/FinancialPortfolios.jl)
[![codecov.io](http://codecov.io/github/tbeason/FinancialPortfolios.jl/coverage.svg?branch=master)](http://codecov.io/github/tbeason/FinancialPortfolios.jl?branch=master)
<!--
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://tbeason.github.io/FinancialPortfolios.jl/stable)
[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://tbeason.github.io/FinancialPortfolios.jl/dev)
-->


A minimalist Julia package for working with simple portfolios of financial assets. Really only provides the barebones.


### Example

Example without rebalancing.

```julia
using FinancialPortfolios, DataFrames, Dictionaries

stockA = 0.06/12 .+ 0.1/sqrt(12) .* randn(120)
stockB = 0.01/12 .+ 0.02/sqrt(12) .* randn(120)

df = DataFrame(stockA=stockA,stockB=stockB)

FP = FinancialPortfolio(dictionary(["stockA"=>0.8,"stockB"=>0.2]))  # initial portfolio weights
df.portfolioreturns = [update!(FP,r) for r in eachrow(df)]
df
FP
```




Example with rebalancing every January.

```julia
using FinancialPortfolios, DataFrames, Dictionaries


months = repeat(1:12,10)
stockA = 0.06/12 .+ 0.1/sqrt(12) .* randn(120)
stockB = 0.01/12 .+ 0.02/sqrt(12) .* randn(120)

df = DataFrame(month=months,stockA=stockA,stockB=stockB)
FP = FinancialPortfolio(dictionary(["stockA"=>0.8,"stockB"=>0.2]))  # initial portfolio weights

function runportfolio(FP0,df0)
    T = nrow(df0)
    outdf = copy(df0)
    outdf[!,:portfolioreturns] = missings(Float64,T)
    FPreb = copy(FP0)
    
    for i in 1:T
        row = outdf[i,:]
        if row.month == 1   # rebalances each January
            FP0 = copy(FPreb)
        end
        row.portfolioreturns = update!(FP0,row)
    end
    return outdf
end

runportfolio(FP,df)
```




