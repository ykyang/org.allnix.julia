# https://juliagraphics.github.io/Gtk.jl/latest/manual/textwidgets/#Entry-1

using Gtk

# The entry widget allows the user to enter text. The entered text can be read
# and write using
# 
# ent = GtkEntry()
# set_gtk_property!(ent,:text,"My String")
# str = get_gtk_property(ent,:text,String)
# The maximum number of characters can be limited using
# set_gtk_property!(ent,:max_length,10).

win = GtkWindow("Text Widgets", 400, 200)
ent = GtkEntry()
push!(win, ent)
set_gtk_property!(ent, :text, "My String")
set_gtk_property!(ent, :max_length, 10)

showall(win)


# 
# Sometimes you might want to make the widget non-editable. This can be done by
# a call
# 
# # using the accessor methods
# GAccessor.editable(GtkEditable(ent),false)
# # using the property system
# set_gtk_property!(ent,:editable,false)

#set_gtk_property!(ent, :editable, false)

# If you want to use the entry to retrieve passwords you can hide the
# visibility of the entered text. This can be achieve by calling
# 
# set_gtk_property!(ent,:visibility,false)

#set_gtk_property!(ent, :visibility, false)

# To get notified by changes to the entry one can listen the "changed" event.

function entryChanged(ent)
    text = get_gtk_property(ent, :text, String)
    println("Text: $text")
end
sid = signal_connect(entryChanged, ent, "changed")

# TODO: setting progress and setting icons in entry
