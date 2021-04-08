import HTTP
import JSON

# https://juliaweb.github.io/HTTP.jl/dev

function sec_requests()
    r = HTTP.request("GET", "http://httpbin.org/ip") # = HTTP.get()

    #@show r.status
    #@show r.headers
    #@show String(r.body)

    #@info "Request body examples"
    #r = HTTP.post("http://httpbin.org/post", [], "post body data")
    #@show r.status
    #@show r.headers
    #@show String(r.body)
    @show r.body
    #str = String(r.body[1:end-1]) # need to remove last byte?
    str = String(r.body) # need to remove last byte?
    println(str)
    #@show JSON3.read(String(r.body))
   
    obj = JSON.parse(str)
    @show obj    



    return r
end

sec_requests()

nothing