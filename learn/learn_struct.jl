# Run with
#   include("learn_struct.jl")
# not with
#   Execute File
module Allnix
mutable struct Well
    Well() = (
        me = new(); # new Well object
        # Assign default values
        #me.well_name = nothing;

        me # return the new object
    )

    well_name::String
end

mutable struct Simulation
    Simulation() = (
        me = new(); # new Simulation object
        # Assign default values
        me.well_list = Vector{Well}();

        me # return the new object
    )
    well_list::Vector{Well}
end


export Well, Simulation

end

sim = Allnix.Simulation()
push!(sim.well_list, Allnix.Well())
