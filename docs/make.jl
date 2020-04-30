using Documenter, FinancialPortfolios

makedocs(
    modules = [FinancialPortfolios],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Tyler Beason",
    sitename = "FinancialPortfolios.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/tbeason/FinancialPortfolios.jl.git",
    push_preview = true
)
