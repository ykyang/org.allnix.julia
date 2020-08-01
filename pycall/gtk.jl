using PyCall

gi = pyimport("gi")
gi.require_version("Gtk", "3.0")

grepo = pyimport("gi.repository")
gtk = pyimport("gi.repository.Gtk")

win = gtk.Window(title="Hello World")
win.connect("destroy", gtk.main_quit)
win.show_all()
gtk.main()
