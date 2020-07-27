# https://juliagraphics.github.io/Gtk.jl/latest/manual/textwidgets/#Label-1

using Gtk

# A GtkLabel is the most basic text widget that has already been used behind
# the scene in any previous example involving a GtkButton. A GtkLabel is
# constructed by calling
# 
# label = GtkLabel("My text")
# The text of a label can be changed using
# 
# GAccessor.text(label,"My other text")

win = GtkWindow("Text Widgets", 400, 200)
label = GtkLabel("My text")
push!(win, label)
showall(win)

GAccessor.text(label, "My other text")

# Furthermore, a label has limited support for adding formatted text. This is
# done using the markup function:
# 
# GAccessor.markup(label,"""<b>My bold text</b>\n
#                           <a href=\"https://www.gtk.org\"
#                           title=\"Our website\">GTK+ website</a>""")
# The syntax for this markup text is borrowed from html and explained here:
# https://developer.gnome.org/pygtk/stable/pango-markup-language.html

GAccessor.markup(label, 
"""<b>My bold text</b>\n
<a href="https://www.gtk.org"
title="Our website">GTK websitee</a>""")

# 
# A label can be made selectable using
# 
# GAccessor.selectable(label,true)
# This can be used if the user should be allowed to copy the text.
# 

GAccessor.selectable(label, true)

# The justification of a label can be changed in the following way:
# 
# GAccessor.justify(label,Gtk.GConstants.GtkJustification.RIGHT)
# Possible values of the enum GtkJustification are LEFT,RIGHT,CENTER, and FILL.

GAccessor.justify(label, Gtk.GConstants.GtkJustification.RIGHT)

# 
# Automatic line wrapping can be enabled using
# 
# GAccessor.text(label,repeat("Very long text! ",20))
# GAccessor.line_wrap(label,true)
# Note that this will only happen, if the size of the widget is limited using
# layout constraints.

GAccessor.text(label, repeat("Very long text! ", 20))
GAccessor.line_wrap(label, true)