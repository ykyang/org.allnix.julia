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
    
    text = render(tpl,db)
    print(text)
end

learn_example_1()

end

nothing