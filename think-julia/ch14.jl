module ch14

using Printf
# -------------------
# Reading and Writing
# -------------------
fout = open("output.txt", "w")
line = "This here's the wattle,\n"
write(fout, line)
line = "the emblem of our land.\n"
write(fout, line)
close(fout)

# ----------
# Formatting
# ----------
fout = open("output.txt", "w")
write(fout, string(150))
camels = 42
#println(fout, "I have spotted $camels camels.")
@printf(fout, "I have spotted %i camels", camels)
close(fout)

# Filenames and Paths
cwd = pwd()
abspath("output.txt")
ispath("output.txt")
isdir("output.txt")
isfile("output.txt")
readdir(cwd)
# joinpath
# walkdir


# Command Objects
cmd = `echo hello`
run(cmd)
ret = read(cmd, String)

# repr()
# dump()
end
