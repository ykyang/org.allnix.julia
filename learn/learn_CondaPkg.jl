module MyCondaPkg

"""
julia> ]
(learn) pkg> add CondaPkg
julia> using CondaPkg
julia> ]
(learn) pkg> conda status
CondaPkg Status C:/Users/Yi-Kun.Yang/work/org.allnix.julia/learn/CondaPkg.toml (empty)
Not Resolved (resolve first for more information)

(learn) pkg> conda add python@3.8.16

# CondaPkg.toml will be generated at this point

(learn) pkg> conda run python --version
Python 3.8.16

# When changing Python version, may need to delete .CondaPkg/
# otherwise new python runs slowly

# Delete .CondaPkg/

# Use resolve to re-install python
(learn) pkg> conda resolve

(learn) pkg> conda add numpy
(learn) pkg> conda add matplotlib
(learn) pkg> conda add sympy
"""

using CondaPkg

## Copied from https://github.com/cjdoris/CondaPkg.jl
# Simplest version.
CondaPkg.withenv() do
    run(`python --version`)
end
# Guaranteed not to use Python from outside the Conda environment.
CondaPkg.withenv() do
    python = CondaPkg.which("python")
    run(`$python --version`)
end
# Explicitly specifies the path to the executable (this is package-dependent).
CondaPkg.withenv() do
    python = joinpath(CondaPkg.envdir(), Sys.iswindows() ? "python.exe" : "bin/python")
    run(`$python --version`)
end


end