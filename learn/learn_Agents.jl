#
# https://juliadynamics.github.io/Agents.jl/stable/examples/schelling/
#

module LearnAgents # Do this so struct can be reloaded

using Agents
using Random
#using InteractiveDynamics
using CairoMakie
using Test
import InteractiveUtils: supertypes
#using GLMakie

#GLMakie.activate!()

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

function learn_Schelling()
    model = initialize()
    step!(model, agent_step!)
    step!(model, agent_step!,3)



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
        "schelling.mp4", model, agent_step!,
        ac = groupcolor, am = groupmarker, as = 10,
        framerate = 1, frames = 20,
        title = "Schelling's segregation model"
    )

    # Collecting data during time evolution
    adata = [:pos, :mood, :group]
end

@agent Person{T} GridAgent{2} begin
    age::Int
    moneyz::T
end

@agent Baker{T} Person{Int} begin
    ## https://juliadynamics.github.io/Agents.jl/stable/tutorial/#.-The-agent-type(s)-1
    ## The example in the doc is wrong.  It is explained further down in the doc.
    breadz_per_day::T
end

abstract type Human <: AbstractAgent end

@agent Worker GridAgent{2} Human begin
    age::Int
    moneyz::Float64
end

@agent Fisher Worker Human begin
    fish_per_day::Float64
end

@agent CommonTraits GridAgent{2} begin # the doc has typo here
    age::Int
end

@agent Bird CommonTraits begin
    height::Float64
end

@agent Rabbit CommonTraits begin
    underground::Bool
end

Animal = Union{Bird, Rabbit}

function print(x::Animal)
    println("Animal: $x")
end
function print(x::Bird) # Specialized version
    println("Bird: $x")
end

function learn_agent_type()
    ## https://juliadynamics.github.io/Agents.jl/stable/tutorial/#.-The-agent-type(s)-1
    @test Person <: AbstractAgent
    person = Person{Int}(1,(1,1),0,1_000_000)
    @test Baker <: AbstractAgent
    baker = Baker{Int}(1,(1,1),0,1_000_000, 100)
    #@show supertypes(Baker)

    @test Human  <: AbstractAgent
    @test Worker <: Human
    @test Fisher <: Human
    #@show supertypes(Fisher)

    ## Create a common type for multiple dispatch
    bird = Bird(2, (0,0), 5, 1)
    print(bird)
    rabbit = Rabbit(3, (0,0), 1, false)
    print(rabbit)
    nothing
end

run = true
run = false
if run
    LearnAgents.learn_agent_type();
    LearnAgents.learn_Schelling();
end
end




