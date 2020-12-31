### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ c412a790-46f9-11eb-06bb-bf7a56b74fef
using PlotlyJS, DataFrames, CSV, Dates, WebIO

# ╔═╡ f9162b00-46fa-11eb-12b9-61a3e058d389
md"Display in a external Electron window"

# ╔═╡ 09c827a0-46fb-11eb-29ad-bb9413a08b10
md"Display PlotlyJS in place is not yet supported."

# ╔═╡ bf1bf1a0-46fa-11eb-2fb5-c58414cdd60a
md"PlotlyJS scatter example function"

# ╔═╡ e5690c40-46f9-11eb-11a1-e5bbc735ebce
function linescatter1()
    l = Layout(
        #title="Penguins",
        #xaxis=attr(range=[0, 42.0], title="fish", showgrid=true),
        #yaxis=attr(title="Weight", showgrid=true),
        legend=attr(x=0.1, y=0.1)
    )
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
    #p = Plot([trace1, trace2, trace3], l)
    plot([trace1, trace2, trace3], l)
end

# ╔═╡ ffc391a0-46f9-11eb-072d-e906a4a664ad
display(linescatter1())

# ╔═╡ Cell order:
# ╠═c412a790-46f9-11eb-06bb-bf7a56b74fef
# ╟─f9162b00-46fa-11eb-12b9-61a3e058d389
# ╠═ffc391a0-46f9-11eb-072d-e906a4a664ad
# ╟─09c827a0-46fb-11eb-29ad-bb9413a08b10
# ╠═bf1bf1a0-46fa-11eb-2fb5-c58414cdd60a
# ╟─e5690c40-46f9-11eb-11a1-e5bbc735ebce
