using Mustache

tpl = mt"""
Hello {{name}}
You have just won {{value}} dollars!
{{#in_ca}}
Well, {{taxed_value}} dollars, after taxes.
{{/in_ca}}
"""

d = Dict(
"name" => "Chris",
"value" => 10000,
"taxed_value" => 10000 - (10000 * 0.4),
#"in_ca" => true
)

Ans = render(tpl, d);
print(Ans)

tpl = mt"""
<html>
<head>
<title>{{:TITLE}}</title>
</head>
<body>
<table>
<tr><th>name</th><th>summary</th></tr>
{{#:D}}
<tr><td>{{:names}}</td><td>{{:summs}}</td></tr>
{{/:D}}
</body>
</html>
"""
_names = String[]
_summaries = String[]
for s in sort(map(string, names(Main)))
    v = Symbol(s)
    if isdefined(Main,v)
        push!(_names, s)
        push!(_summaries, summary(eval(v)))
    end
end

using DataFrames
d = DataFrame(names=_names, summs=_summaries)

out = render(tpl, TITLE="A quick table", D=d)
print(out)
