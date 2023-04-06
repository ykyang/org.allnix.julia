module MyCondaPkg

"""
julia> using CondaPkg
julia> ]
(learn) pkg> conda status
CondaPkg Status C:\Users\Yi-Kun.Yang\work\org.allnix.julia\learn\CondaPkg.toml (empty)
Not Resolved (resolve first for more information)

(learn) pkg> conda add python@3.8.16

# CondaPkg.toml will be generated at this point

(learn) pkg> conda run python --version
Python 3.8.16

# When chaanging Python version, may need to delete .CondaPkg/
# otherwise new python runs slowly

# Delete .CondaPkg/

# Use resolve to re-install python
(learn) pkg> conda resolve

(learn) pkg> conda add numpy
(learn) pkg> conda add matplotlib
"""



end