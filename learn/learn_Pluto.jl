### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ c7de68ac-906c-4959-82ac-5fc8fe4870a5
using PlotlyJS, WebIO

# ╔═╡ 40415ac0-db9f-11eb-3ca4-1d76bfbbc79a
md"""
# Learn basic Pluto stuff
"""

# ╔═╡ 2e20d719-0f6e-46d3-89be-c73a56a6e44e
md"""
Plotly scatter plot
"""

# ╔═╡ 2ab468f0-adce-4d2b-9f6f-bffe253f000b
begin
	l = Layout(
        #title="Penguins",
        #xaxis=attr(range=[0, 42.0], title="fish", showgrid=true),
        #yaxis=attr(title="Weight", showgrid=true),
        legend=attr(x=0.1, y=0.1)
    )
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
	# uncomment to display in Electron
	#plt = plot([trace1, trace2, trace3], l)
	#display(plt)
	
	# Display in-place
    p = Plot([trace1, trace2, trace3], l)   # for display in-place
end

# ╔═╡ Cell order:
# ╟─c7de68ac-906c-4959-82ac-5fc8fe4870a5
# ╟─40415ac0-db9f-11eb-3ca4-1d76bfbbc79a
# ╟─2e20d719-0f6e-46d3-89be-c73a56a6e44e
# ╟─2ab468f0-adce-4d2b-9f6f-bffe253f000b
