using Markdown
#data = read("learn_markdown.md", String)
d = Markdown.parse_file("learn_markdown.md")
h = html(d)
open("learn_markdown.html", "w") do io
    println(io, h)
end
