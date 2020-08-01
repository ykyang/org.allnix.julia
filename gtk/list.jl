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

# Selection
# Usually the interesting bit of a list will be the entry being selected. This
# is done using an additional GtkTreeSelection object that can be retrieved by

selection = GAccessor.selection(tv)

# One either have single selection or multiple selections. We toggle this by
# calling


#selection = GAccessor.mode(selection,Gtk.GConstants.GtkSelectionMode.MULTIPLE) # not supported yet
# selected_rows(selection) crashes
selection = GAccessor.mode(selection,Gtk.GConstants.GtkSelectionMode.SINGLE)

# We will stick with single selection for now and want to know the index of the selected item

@show ls[selected(selection),1]

#"Pete"
# Since it can happen that no item has been selected at all, it is a good idea
# to put this into an if statement

if hasselection(selection)
  # do something with selected(selection)
end
# Sometimes you want to invoke an action of an item is selected. This can be done by

signal_connect(selection, "changed") do widget
  if hasselection(selection)
    currentIt = selected(selection)

    # now you can to something with the selected item
    println("Name: ", ls[currentIt,1], " Age: ", ls[currentIt,1])
  end
end
# Another useful signal is "row-activated" that will be triggered by a double click of the user.

# Note: getting multiple selections still not implemented