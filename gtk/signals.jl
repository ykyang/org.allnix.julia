# https://juliagraphics.github.io/Gtk.jl/latest/manual/signals/

using Gtk

# b = GtkButton("Press me")
# win = GtkWindow(b, "Callbacks")
# showall(win)

# function button_clicked_callback(widget)
#     println(widget, " was clicked!")
# end

# id = signal_connect(button_clicked_callback, b, "clicked")

win = GtkWindow("Callbacks")
b = GtkButton("Press me")
push!(win, b)
showall(win)

function clicked_callback(widget)
    println(widget, " was clicked!")
end

# https://developer.gnome.org/gtk3/stable/GtkButton.html#gtk-button-clicked
id = signal_connect(clicked_callback, b, "clicked") # emit "clicked" signal

# Use do- syntax
win2 = GtkWindow("Callbacks")
b2 = GtkButton("Press me 2")
push!(win2, b2)
# See https://docs.julialang.org/en/v1/manual/functions/index.html#Do-Block-Syntax-for-Function-Arguments-1
id2 = signal_connect(b2, "clicked") do widget
     println(widget, " was clicked 2!")
end

id2_2 = signal_connect(b2, "clicked") do widget
    println("\"", get_gtk_property(widget,:label,String), "\" was clicked!")
end

# Disconnect signal
signal_handler_disconnect(b2, id2)

# Block signal
#signal_handler_block(b2, id2_2)
#signal_handler_unblock(b2, id2_2)
showall(win2)


# https://developer.gnome.org/gtk3/stable/GtkWidget.html#GtkWidget-button-press-event
b = GtkButton("Pick a mouse button")
win = GtkWindow(b, "Callbacks")
id = signal_connect(b, "button-press-event") do widget, event # must have event
    println("widget: $widget")
    println(event)
    println("You pressed button ", event.button)
end
showall(win)
