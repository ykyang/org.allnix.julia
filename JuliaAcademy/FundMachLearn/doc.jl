import Weave
import Images

img = Images.load("data/array2d.png")
img = Images.imresize(img, ratio=0.15)
Images.save("data/array2d_s.png", img)


filepath = "ch0100.jl"
Weave.weave(filepath; doctype = "md2html", out_path = :pwd)
