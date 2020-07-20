# https://juliagraphics.github.io/Gtk.jl/latest/manual/builder/
using Gtk
# b = GtkBuilder(filename="path/to/myapp.glade")
# 
# Alternatively, if we would store above XML definition in a Julia string myapp we can initalize the builder by
# 
# b = GtkBuilder(buffer=myapp)
# Now we want to access a widget from the XML file in order to actually display it on the screen. To do so we call
# 
# win = b["window1"]
# showall(win)

b = GtkBuilder(filename="myapp.glade")
win = b["window1"] # "window1" came from myapp.glade
showall(win)