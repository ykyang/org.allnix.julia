using Genie, Genie.Router
using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, Genie.Requests






# https://genieframework.github.io/Genie.jl/dev/guides/Interactive_environment.html
function learn_interactive_environment()
    route("/") do
        "Hi there!"
    end

    function hello_world()
        return "Hello World!"
    end

    route("/hello/world", hello_world)

    route("/hello.html") do
        html("Hello World")
    end

    route("/echo/:message") do
        return @params(:message)
    end

    route("/sum/:x::Int/:y::Int") do
        x = @params(:x)
        y = @params(:y)

        return x+y
    end

    route("/sum/:x::Int/:y::Int") do
        x = @params(:x)
        y = @params(:y)
        initial_value = get(@params, :initial_value, "0")
        initial_value = parse(Int, initial_value)

        return x + y + initial_value
    end


    route("/hello.json") do
        json("Hello World")
    end

    route("/hello.txt") do
        respond("Hello World", :text)
    end
end

# https://genieframework.github.io/Genie.jl/dev/guides/Simple_API_backend.html
function learn_simple_api_backend()
    route("/") do
        (:message => "Hi there!") |> json
    end

    route("/echo", method=POST) do
        message = Genie.Requests.jsonpayload()
        Ans = (message["message"] * " ") ^ message["repeat"]
        return (:echo => Ans) |> json
    end
end


#learn_interactive_environment()
learn_simple_api_backend()


up(8001, async=false) # async=false so script does not exit
