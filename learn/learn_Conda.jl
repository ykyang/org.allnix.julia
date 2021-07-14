using Conda

function learn_basic()
    #@show Conda.ROOTENV

    #Conda.runconda(`search python`)
    #Conda.runconda(`env list`)
    #Conda.runconda(`info`)
    
    #Conda.runconda(`create --name py39 python=3.9`)
    
    #Conda.runconda(`create --name py38 python=3.8`)
    Conda.runconda(`install paraview`)
    
end

learn_basic()

nothing

