#
# https://juliadynamics.github.io/Agents.jl/stable/examples/schelling/
#

module LearnAgents # Do this so struct can be reloaded



using Agents
#using CairoMakie
using GLMakie
#using InteractiveDynamics # deprecated
using InteractiveUtils: supertypes
using Logging
using Random
using Statistics: mean
using Test

#using GLMakie

#GLMakie.activate!()

# mutable struct SchellingAgent <: AbstractAgent
#     id::Int
#     pos::NTuple{2,Int}
#     mood::Bool         # true = happy
#     group::Int         #
# end

## Use `dump(SchellingAgent)` to see the struct
@agent SchellingAgent GridAgent{2} begin # {2} for 2-dimensional grid
    mood::Bool      # true, happy
    group::Integer  # 1, 2
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

function learn_Schelling()
    @info "# Schelling's segregation model"
    OUT = Dict()
    function initialize(; no_agents=320, griddims=(20,20), min_to_be_happy=3, seed=125)
        space = GridSpace(griddims, periodic=false)
        properties = Dict(:min_to_be_happy => min_to_be_happy) 
        rng = Random.MersenneTwister(seed)
    
        ## Alternative model
        # model = ABM(SchellingAgent, space; properties,
        #     rng, scheduler = Schedulers.randomly  # ???
        # )
        # model = ABM(SchellingAgent, space; properties)
        # model = ABM(SchellingAgent, space; properties,
        #     scheduler=Schedulers.ByProperty(:group)
        # )
        model = UnremovableABM(SchellingAgent, space; properties, rng)
    
        @test nagents(model) == 0
    
        for n in 1:no_agents
            ## pos (1,1) will be changed by add_agent_single!()
            agent = SchellingAgent(n, (1,1), false, n < no_agents/2 ? 1 : 2)
            add_agent_single!(agent, model)

            ## or
            ## add_agent_single!(model, false, n < numagents/2 ? 1 : 2)
        end

        @test nagents(model) == no_agents
        @test model[2] isa SchellingAgent  # get an agent
        @test model[2].id    == 2
        @test model[2].pos   == (14,10)
        @test model[2].mood  == false
        @test model[2].group == 1
        
    
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
            agent.mood = false
            move_agent_single!(agent, model)
        end
    
        return nothing
    end

    @info "## Visualizing the data"
    groupcolor(a) = a.group == 1 ? :blue : :orange
    groupmarker(a) = a.group == 1 ? :circle : :rect
    let
        model = initialize()
        step!(model, agent_step!)
        step!(model, agent_step!,3)
        step!(model, agent_step!,10)
        ## Visualization
        
        #figure, _ = abm_plot(model; ac = groupcolor, am = groupmarker, as = 10)
        figure, _ = abmplot(model; ac = groupcolor, am = groupmarker, as = 10)
        #display(figure)
        save("schelling.png", figure)
    end
    
    @info "## Animating the evolution"
    let 
        model = initialize()
        abmvideo(
            "schelling.mp4", model, agent_step!,
            ac = groupcolor, am = groupmarker, as = 10,
            framerate = 1, frames = 20,
            title = "Schelling's segregation model"
        )
    end
    @info "## Collecting data during time evolution"
    @info "### Collect agent data"
    let
        x(agent) = agent.pos[1]
        y(agent) = agent.pos[2]
        adata = [:pos, :mood, :group, x, y] # agent data to retrieve
        model = initialize()
        agent_df, model_df = run!(model, agent_step!, 5; adata)
        OUT["agent_df"] = agent_df
    end

    @info "### Collect with sum(), mean()"
    let
        model = initialize()
        x(agent) = agent.pos[1]
        adata = [(:mood, sum), (x, mean)]
        agent_df, model_df = run!(model, agent_step!, 13; adata)
        OUT["agent_df_2"] = agent_df
    end
    @info "## Launching the interactive application"
    let
        x(agent) = agent.pos[1]
        params = Dict(:min_to_be_happy => 0:8)
        adata = [(:mood,sum), (x,mean)]
        alabels = ["happy", "avg. x"]
        model = initialize(; no_agents=300)
        fig, obs = abmexploration(model; agent_step!, dummystep, params,
            ac = groupcolor, am = groupmarker, as = 10,
            adata, alabels
        )
        #display(fig)
    end
    @info "## Saving/loading the model state"
    let
    end
    
    return OUT
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
    @show supertypes(Fisher)

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
    LearnAgents.learn_agent_type();      # include("learn_Agents.jl");LearnAgents.learn_agent_type();
    OUT = LearnAgents.learn_Schelling(); # include("learn_Agents.jl"); OUT = LearnAgents.learn_Schelling();
end
end




