import Weave

filepath = "/home/ykyang/work/org.allnix.julia/JuliaAcademy/JuliaAcademyMaterials/Courses/Foundations of machine learning/0100.Representing-data-in-a-computer.jl"
Weave.weave(filepath; doctype = "md2html", out_path = :pwd)
