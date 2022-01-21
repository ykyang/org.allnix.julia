## See Mustache/ for more details

module MyMustache

using Mustache

function learn_example_1()
    tpl = mt"""
    Hello {{name}}
    You have just won {{value}} dollars!
    {{#in_ca}}
    Well, {{taxed_value}} dollars, after taxes.
    {{/in_ca}}
    """

    db = Dict(
        "name"=>"Chris",
        "value" => 10000,
        "taxed_value" => 10000*(1-0.4),
        "in_ca" => true,
    )
    
    text = render(tpl,db) # this way
    text = tpl(db)        # or this way
    
    print(text)
end

function learn_sections()
    # a is replaced by function length
    # one is the argument
    tpl = mt"length(one)={{#a}}one{{/a}}"
    text = render(tpl, Dict("a"=>length))
    println(text)

    # | indicates that value is substituted before invoking lambda
    tpl = mt"""{{|lambda}}{{value}}{{/lambda}} dollars"""
    fmt(txt) = string(round(parse(Float64,txt),digits=2)) # return type is string
    text = render(tpl, Dict("value"=>1.23456, "lambda"=>fmt))
    println(text)
end

function learn_inverted()
    tpl = mt"{{^sec}}sec == false{{/sec}}"
    text = render(tpl, Dict("sec"=>false))
    println(text)
end

#learn_example_1()
#learn_sections()
learn_inverted()

end # module MyMustache

nothing