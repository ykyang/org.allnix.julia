using HTTP
using Genie.Renderer.Json
import JSON
using Test

host = "localhost"
port = 8001

# Test geniews.jl
function test_learn_interactive_environment()
    r = HTTP.request("GET", "http://localhost:$port/hello/world")
    @test "Hello World!" == String(r.body)

    r = HTTP.request("GET", "http://localhost:$port/echo/ciao")
    @test "ciao" == String(r.body)

    r = HTTP.request("GET", "http://localhost:$port/sum/3/2")
    @test "5" == String(r.body)

    r = HTTP.request("GET", "http://localhost:$port/sum/3/2?initial_value=10")
    @test "15" == String(r.body)

    r = HTTP.request("GET", "http://localhost:$port/hello.html")
    @test "Hello World" == String(r.body)

    r = HTTP.request("GET", "http://localhost:$port/hello.json")
    @test "\"Hello World\"" == String(r.body)

    r = HTTP.request("GET", "http://localhost:$port/hello.txt")
    @test "Hello World" == String(r.body)
end

function test_learn_simple_api_backend()
    r = HTTP.request("GET", "http://$host:$port/")
    j = JSON.parse(IOBuffer(r.body))
    #JSON.print(stdout, j, 4)
    @test "Hi there!" == j["message"]

    #response = HTTP.request("POST", "http://$host:$port/echo", [("Content-Type", "application/json")], """{"message":"hello", "repeat":3}""")
    
    payload = Dict(
        "message" => "hello",
        "repeat" => 3,
    )
    response = HTTP.request(
        "POST", 
        "http://$host:$port/echo",
        [("Content-Type", "application/json")], 
        JSON.json(payload)
    )

    j = JSON.parse(IOBuffer(response.body))
    JSON.print(stdout, j, 4)
end

#test_learn_interactive_environment()
test_learn_simple_api_backend()


nothing