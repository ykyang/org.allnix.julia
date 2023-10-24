#
# https://juliadynamics.github.io/Agents.jl/stable/examples/schelling/
#

module MyAgents # Do this so struct can be reloaded

using Agents
using Random

# mutable struct SchellingAgent <: AbstractAgent
#     id::Int
#     pos::NTuple{2,Int}
#     mood::Bool         # true = happy
#     group::Int         #
# end

@agent SchellingAgent GridAgent{2} begin # {2} for 2-dimensional grid
    mood::Bool
    group::Integer
end

function initialize(; numagents=320, griddims=(20,20), min_to_be_happy=3, seed=125)
    space = GridSpace(griddims, periodic=false)
    props = Dict(:min_to_be_happy => min_to_be_happy) 
    rng = Random.MersenneTwister(seed)

    model = ABM(
        SchellingAgent, space,
        properties = props, 
        rng = rng, 
        scheduler = Schedulers.randomly  # ???
    )

    for n in 1:numagents
        agent = SchellingAgent(n, (1,1), false, n < numagents/2 ? 1 : 2)
        add_agent_single!(agent, model)
    end

    return model
end

function agent_step!(agent, model)
    minhappy = model.min_to_be_happy # model.properties[:min_to_be_happy]
    count_neighbors_same_group = 0
    for neighbor in nearby_agents(agent, model)
        if agent.group == neighbor.group
            count_neighbors_same_group += 1
        end
    end

    if count_neighbors_same_group >= minhappy
        agent.mood = true
    else
        move_agent_single!(agent, model)
    end

    return nothing
end

# model = initialize()
# step!(model, agent_step!)
# step!(model, agent_step!,3)

# using InteractiveDynamics
# using CairoMakie


# groupcolor(a) = a.group == 1 ? :blue : :orange
# groupmarker(a) = a.group == 1 ? :circle : :rect
# figure, _ = abm_plot(model; ac = groupcolor, am = groupmarker, as = 10)
# figure



# space = GridSpace((10,10), periodic=false)
# properties = Dict(:min_to_be_happy => 3)

# schelling = ABM(SchellingAgent, space; properties)
# @show schelling

# schelling2 = ABM(
#     SchellingAgent,
#     space;
#     properties = properties,
#     scheduler = Schedulers.by_property(:group)
# )
# @show schelling2

end

using Agents

model = MyAgents.initialize()
step!(model, MyAgents.agent_step!)
step!(model, MyAgents.agent_step!,3)

#using InteractiveDynamics
using CairoMakie
#using GLMakie

#GLMakie.activate!()

groupcolor(a) = a.group == 1 ? :blue : :orange
groupmarker(a) = a.group == 1 ? :circle : :rect
#figure, _ = abm_plot(model; ac = groupcolor, am = groupmarker, as = 10)
figure, _ = abmplot(model; ac = groupcolor, am = groupmarker, as = 10)

# https://makie.juliaplots.org/stable/tutorials/basic-tutorial/
#Makie.inline!(true)
display(figure) # Only works in IDE
save("schelling.png", figure)
#abm_video(
abmvideo(
    "schelling.mp4", model, MyAgents.agent_step!,
    ac = groupcolor, am = groupmarker, as = 10,
    framerate = 1, frames = 20,
    title = "Schelling's segregation model"
)

# Collecting data during time evolution
adata = [:pos, :mood, :group]
nothing
