### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ c7de68ac-906c-4959-82ac-5fc8fe4870a5
using PlotlyJS, WebIO, Luxor, PlutoUI

# ╔═╡ 40415ac0-db9f-11eb-3ca4-1d76bfbbc79a
md"""
# Learn basic Pluto stuff
"""

# ╔═╡ 2e20d719-0f6e-46d3-89be-c73a56a6e44e
md"""
Plotly scatter plot
"""

# ╔═╡ 8e614340-d98d-4946-8da9-657594b5009d
@bind T3 Slider(6:16, show_value=true)

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
    trace3 = scatter(;x=1:4, y=[12, 9, T3, 12], mode="lines+markers")
	# uncomment to display in Electron
	#plt = plot([trace1, trace2, trace3], l)
	#display(plt)
	
	# Display in-place
    p = Plot([trace1, trace2, trace3], l)   # for display in-place
end

# ╔═╡ 15c7a365-41cb-4ef8-b0d4-1eeeff3e15c7
@bind power_level html"<input type='range'>"

# ╔═╡ c4ce098b-dd0c-43a6-9380-d12da68e8d65
println("Power Level: $power_level")

# ╔═╡ 46085fcf-be98-44f9-872e-823e0513ff40
@bind S Slider(10:100, show_value=true)

# ╔═╡ 49448abd-bd53-4a60-9f7d-bf625dcbc177
@drawsvg begin
	background("slateblue4")
	for (k,i) in pairs(between.(O + (0,S), O - (0,S), range(0,1,length=3)))
		sethue([Luxor.julia_red, Luxor.julia_purple, Luxor.julia_green][k])
		Luxor.circle(i, S, :fill)
	end
end

# ╔═╡ Cell order:
# ╠═c7de68ac-906c-4959-82ac-5fc8fe4870a5
# ╠═40415ac0-db9f-11eb-3ca4-1d76bfbbc79a
# ╠═2e20d719-0f6e-46d3-89be-c73a56a6e44e
# ╠═2ab468f0-adce-4d2b-9f6f-bffe253f000b
# ╠═8e614340-d98d-4946-8da9-657594b5009d
# ╠═15c7a365-41cb-4ef8-b0d4-1eeeff3e15c7
# ╠═c4ce098b-dd0c-43a6-9380-d12da68e8d65
# ╠═46085fcf-be98-44f9-872e-823e0513ff40
# ╠═49448abd-bd53-4a60-9f7d-bf625dcbc177
