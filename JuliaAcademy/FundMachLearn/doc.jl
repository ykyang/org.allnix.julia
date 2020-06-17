import Weave
import Images
import Glob

img = Images.load("data/array2d.png")
img = Images.imresize(img, ratio=0.15)
Images.save("data/array2d_s.png", img)

filepath = "ch0100.jl"
Weave.weave(filepath; doctype = "md2html", out_path = :pwd)


filepath = "ch0100quiz.jl"
height = 200
img = Images.load("data/array_cartoon.png")
ratio = height/size(img)[1]
img = Images.imresize(img, ratio=ratio)
Images.save("data/array_cartoon_s.png", img)
img = Images.load("data/without_arrays.png")
ratio = height/size(img)[1]
img = Images.imresize(img, ratio=ratio)
Images.save("data/without_arrays_s.png", img)
Weave.weave(filepath; doctype = "md2html", out_path = :pwd)

# Remove tmp folder
tmpfiles = Glob.glob("jl_??????")
for f in tmpfiles
    rm(f, force=true, recursive=true)
end
