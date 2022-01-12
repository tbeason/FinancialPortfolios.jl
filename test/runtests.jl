using FinancialPortfolios, LinearAlgebra, Dictionaries
using Test



w = [0.5, 0.25, 0.25]
nm = ["a", "b", "c"]
plain_dict = Dict(Iterators.zip(nm,w))
plain_dict_sym = Dict(Iterators.zip(Symbol.(nm),w))
plain_dict_int = Dict(Iterators.zip(1:3,w))

r = [0.1, 0.1, -0.1]
const trueret1 = dot(w,r)
const new_weight = w .* (1 .+ r) ./ (1 + trueret1)
const trueret2 = dot(new_weight,r)
const ewret = sum(r) / 3

wgt_dict = Dict(Iterators.zip(nm,new_weight))
wgt_dict_sym = Dict(Iterators.zip(Symbol.(nm),new_weight))
wgt_dict_int = Dict(Iterators.zip(1:3,new_weight))

ret_dict = Dict(Iterators.zip(nm,r))
ret_dict_sym = Dict(Iterators.zip(Symbol.(nm),r))
ret_dict_int = Dict(Iterators.zip(1:3,r))




@testset "Vectors" begin
    FP = FinancialPortfolio(w)
    @test portfolioreturn(FP,r) ≈ trueret1
    update!(FP,r)
    @test portfolioreturn(FP,r) ≈ trueret2
    @test length(FP) == length(w)
    @test FP == copy(FP)
    FP2 = similar(FP)
    @test portfolioreturn(FP2,r) ≈ ewret
    @test sort(keys(FP)) == [1,2,3]
    @test isempty(FP) == false
    @test_throws AssertionError checkupdate!(FP,r)
end

@testset "Dict-String" begin
    ret = ret_dict
    wgts = wgt_dict
    FP = FinancialPortfolio(plain_dict)
    @test portfolioreturn(FP,ret) ≈ trueret1
    update!(FP,ret)
    @test portfolioreturn(FP,ret) ≈ trueret2
    @test length(FP) == length(w)
    @test FP == copy(FP)
    FP2 = similar(FP)
    @test portfolioreturn(FP2,ret) ≈ ewret
    @test sort(keys(FP)) == nm
    ret_dict_minus = copy(ret_dict)
    delete!(ret_dict_minus,"a")
    @test checkupdate!(FinancialPortfolio(plain_dict),ret_dict_minus) ≈ 0
    checkupdate!(FP,ret_dict_minus)
    @test length(FP) == length(w)-1
    @test keys(FP.positions) == keys(ret_dict_minus)
end

@testset "Dict-Symbol" begin
    ret = ret_dict_sym
    wgts = wgt_dict_sym
    FP = FinancialPortfolio(plain_dict_sym)
    @test portfolioreturn(FP,ret) ≈ trueret1
    update!(FP,ret)
    @test portfolioreturn(FP,ret) ≈ trueret2
    @test length(FP) == length(w)
    @test FP == copy(FP)
    FP2 = similar(FP)
    @test portfolioreturn(FP2,ret) ≈ ewret
    @test sort(keys(FP)) == Symbol.(nm)
end

@testset "Dict-Int" begin
    ret = ret_dict_int
    wgts = wgt_dict_int
    FP = FinancialPortfolio(plain_dict_int)
    @test portfolioreturn(FP,ret) ≈ trueret1
    update!(FP,ret)
    @test portfolioreturn(FP,ret) ≈ trueret2
    @test length(FP) == length(w)
    @test FP == copy(FP)
    FP2 = similar(FP)
    @test portfolioreturn(FP2,ret) ≈ ewret
    @test sort(keys(FP)) == [1,2,3]
end

@testset "HashDictionary-String" begin
    dict = dictionary(plain_dict)
    ret = dictionary(ret_dict)
    wgts = dictionary(wgt_dict)
    FP = FinancialPortfolio(dict)
    @test portfolioreturn(FP,ret) ≈ trueret1
    update!(FP,ret)
    @test portfolioreturn(FP,ret) ≈ trueret2
    @test length(FP) == length(w)
    @test FP == copy(FP)
    FP2 = similar(FP)
    @test portfolioreturn(FP2,ret) ≈ ewret
    @test sort(keys(FP)) == nm
end


@testset "HashDictionary-Symbol" begin
    dict = dictionary(plain_dict_sym)
    ret = dictionary(ret_dict_sym)
    wgts = dictionary(wgt_dict_sym)
    FP = FinancialPortfolio(dict)
    @test portfolioreturn(FP,ret) ≈ trueret1
    update!(FP,ret)
    @test portfolioreturn(FP,ret) ≈ trueret2
    @test length(FP) == length(w)
    @test FP == copy(FP)
    FP2 = similar(FP)
    @test portfolioreturn(FP2,ret) ≈ ewret
    @test sort(keys(FP)) == Symbol.(nm)
end


@testset "HashDictionary-Int" begin
    dict = dictionary(plain_dict_int)
    ret = dictionary(ret_dict_int)
    wgts = dictionary(wgt_dict_int)
    FP = FinancialPortfolio(dict)
    @test portfolioreturn(FP,ret) ≈ trueret1
    update!(FP,ret)
    @test portfolioreturn(FP,ret) ≈ trueret2
    @test length(FP) == length(w)
    @test FP == copy(FP)
    FP2 = similar(FP)
    @test portfolioreturn(FP2,ret) ≈ ewret
    @test sort(keys(FP)) == [1,2,3]
end


@testset "HashDictionary-Symbol-NamedTupleReturn" begin
    dict = dictionary(plain_dict_sym)
    ret = (;Iterators.zip(Symbol.(nm),r)...)
    wgts = dictionary(wgt_dict_sym)
    FP = FinancialPortfolio(dict)
    @test portfolioreturn(FP,ret) ≈ trueret1
    update!(FP,ret)
    @test portfolioreturn(FP,ret) ≈ trueret2
end
