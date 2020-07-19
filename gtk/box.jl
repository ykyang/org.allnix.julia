# https://juliagraphics.github.io/Gtk.jl/latest/manual/layout/

using Gtk

# win = GtkWindow("New title")
# hbox = GtkBox(:h)  # :h makes a horizontal layout, :v a vertical layout
# push!(win, hbox)
# cancel = GtkButton("Cancel")
# ok = GtkButton("OK")
# push!(hbox, cancel)
# push!(hbox, ok)
# showall(win)

win = GtkWindow("New Title")
hbox = GtkBox(:h)    # :h makes a horizontal layout, :v a vertical layout
push!(win, hbox)
cancel = GtkButton("Cancel")
ok = GtkButton("OK")
push!(hbox, cancel)
push!(hbox, ok)

showall(win)

# julia> length(hbox)
# 2
# 
# julia> get_gtk_property(hbox[1], :label, String)
# "Cancel"
# 
# julia> get_gtk_property(hbox[2], :label, String)
# "OK"

label = get_gtk_property(hbox[1], :label, String)
label = get_gtk_property(hbox[1], "label", String)
label = get_gtk_property(hbox[2], :label, String)

# set_gtk_property!(hbox,:expand,ok,true)
# set_gtk_property!(hbox,:spacing,10)

set_gtk_property!(hbox, :expand, ok, true)
set_gtk_property!(hbox, :spaceing, 10)

# destroy(hbox)
# ok = GtkButton("OK")
# cancel = GtkButton("Cancel")
# hbox = GtkButtonBox(:h)
# push!(win, hbox)
# push!(hbox, cancel)
# push!(hbox, ok)

destroy(hbox)
ok = GtkButton("OK")
cancel = GtkButton("Cancel")
hbox = GtkButtonBox(:h)
push!(win, hbox)
push!(hbox, cancel)
push!(hbox, ok)
showall(win)