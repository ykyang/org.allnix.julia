# https://juliagraphics.github.io/Gtk.jl/latest/manual/listtreeview/#List-Store-1

using Gtk

# List Store

# Lets start with a very simple example: A table with three columns
# representing the name, the age and the gender of a person. Each column must
# have a specific type. Here, we chose to represent the gender using a boolean
# value where true represents female and false represents male. We thus
# initialize the list store using

ls = GtkListStore(String, Int, Bool)

# Now we will the store with data

push!(ls,("Peter",20,false))
push!(ls,("Paul",30,false))
push!(ls,("Mary",25,true))

# If we want so insert the data at a specific position we can use the insert
# function

insert!(ls, 2, ("Susanne", 35, true))

# You can use ls like a matrix like container. Calling length and size will
# give you

@show length(ls)
@show size(ls)

# Specific element can be be accessed using

@show ls[1,1]
@show ls[1,1]

# List View

# Now we actually want to display our data. To this end we create a tree view
# object

tv = GtkTreeView(GtkTreeModel(ls))

# Then we need specific renderers for each of the columns. Usually you will
# only need a text renderer, but in our example we want to display the boolean
# value using a checkbox.

rTxt = GtkCellRendererText()
rTog = GtkCellRendererToggle()

# Finally we create for each column a TreeViewColumn object

c1 = GtkTreeViewColumn("Name", rTxt, Dict([("text",0)]))
c2 = GtkTreeViewColumn("Age", rTxt, Dict([("text",1)]))
c3 = GtkTreeViewColumn("Female", rTog, Dict([("active",2)]))

# We need to push these column description objects to the tree view

push!(tv, c1, c2, c3)

# Then we can display the tree view widget in a window

win = GtkWindow(tv, "List View")
showall(win)

# If you prefer that the columns are resizable by the user call

for c in [c1, c2, c3]
    GAccessor.resizable(c, true)
end

# Sorting

# We next want to make the tree view sortable

for (i,c) in enumerate([c1,c2,c3])
  GAccessor.sort_column_id(c,i-1)
end

# If you now click on one of the column headers, the data will be
# sorted with respect to the selected column. You can even make
# the columns reorderable

for (i,c) in enumerate([c1, c2, c3])
    #GAccessor.reorderable(c, i)
    # gtk_tree_view_column_set_reorderable 
    GAccessor.reorderable(c, true)
end