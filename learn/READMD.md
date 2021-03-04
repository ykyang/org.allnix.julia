add https://ykyang@bitbucket.org/ykyang/wdvgco.jl.git#multiwell

add https://ykyang@github.com/ykyang/OilData.jl.git
develop --local OilData

Plots may conflict with other packages
May need to add/remove Plots, solved by
]
rm Plots
resolve

now it is fine
checkout the original Project.toml
resolve