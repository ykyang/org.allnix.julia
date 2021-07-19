using Conda
using PyCall


begin # See learn_PyCall.jl
    path = Conda.bin_dir(dirname(PyCall.pyprogramname))
    if isnothing(findfirst(path, ENV["PATH"])) && Sys.iswindows()
        ENV["PATH"] = path * ";" * ENV["PATH"]
    end
end


# Must load in Python before loading in Julia

py"""
import wx
"""
#pygui_start(:wx)
wx = pyimport("wx")



# https://wiki.wxpython.org/Getting%20Started
function learn_hello()
    app = wx.App(false)
    frame = wx.Frame(nothing, wx.ID_ANY, "Hello World")
    frame.Show(true)
    app.MainLoop()

end

# https://wiki.wxpython.org/Getting%20Started#Building_a_simple_text_editor
function learn_building_a_simple_text_editor()
    # py"""
    # import wx
    # class MyFrame(wx.Frame):
    #     def __init__(self, parent, title):
    #         wx.Frame.__init__(self, parent, title=title, size=(200,100))
    #         self.control = wx.TextCtrl(self, style=wx.TE_MULTILINE)
    #         self.Show(True)
    # """
    # app = wx.App(false)
    # frame = py"MyFrame"(nothing, "Small editor")
    # app.MainLoop()


    
    # Use my own package
    lwx = pyimport("learnall.wx")
    app = wx.App(false)
    frame = lwx.MyFrame(nothing, "Small editor")
    #app.MainLoop()
    
end

#learn_hello()
#learn_building_a_simple_text_editor()

nothing