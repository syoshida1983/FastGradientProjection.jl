using FastGradientProjection
using Documenter

DocMeta.setdocmeta!(FastGradientProjection, :DocTestSetup, :(using FastGradientProjection); recursive=true)

makedocs(;
    modules=[FastGradientProjection],
    authors="Shuhei Yoshida <98638350+syoshida1983@users.noreply.github.com> and contributors",
    sitename="FastGradientProjection.jl",
    format=Documenter.HTML(;
        canonical="https://syoshida1983.github.io/FastGradientProjection.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/syoshida1983/FastGradientProjection.jl",
    devbranch="main",
)
