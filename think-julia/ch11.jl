module ch11
# Dictionaries
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#chap11

# -------------------------
# A Dictionary is a Mapping
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_a_dictionary_is_a_mapping
# -------------------------

eng2sp = Dict()
eng2sp["one"] = "uno"

# Create new Dict
eng2sp = Dict("one"=>"uno", "two"=>"dos", "three"=>"tres")
eng2sp["two"]

try
    eng2sp["four"]
catch e
    if e isa KeyError
        println("Missing key")
        println(e)
    else
        println(e)
    end
end


length(eng2sp)

# keys
keylist = keys(eng2sp)
for key in keylist
    println(key)
end

# put keys into an array
x = collect(keylist)

# IN operator
"one" ∈ keylist

# values
valuelist = values(eng2sp)
for value in values(eng2sp)
    println(value)
end

# --------------------------------------
# Dictionary as a Collection of Counters
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#dictionary_collection_counters
# --------------------------------------
function histogram(str)
    dic = Dict()
    for char in str
        if char ∉ keys(dic)
            dic[char] = 1
        else
            dic[char] += 1
        end
    end

    return dic
end

dic = histogram("audreyandryan")

dic['a']

# get to access Dict
get(dic, 'a', 0)
get(dic, 'z', 0)


# ------------------------
# Looping and Dictionaries
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_looping_and_dictionaries
# ------------------------
function printhist(dict)
    for key in keys(dict)
        println(key, " ", dict[key])
    end
end
printhist(dic)

# --------------
# Reverse Lookup
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_reverse_lookup
# --------------

# isequal
func = isequal(3)
func(4)
func(3)

findall(isequal(3), dic)

# -----------------------
# Dictionaries and Arrays
# https://benlauwens.github.io/ThinkJulia.jl/latest/book.html#_dictionaries_and_arrays
# -----------------------

# inverts a dictionary
function invertdict(dict)
    idict = Dict()
    for key in keys(dict)
        value = dict[key]
        if value ∈ keys(idict)
            push!(idict[value], key)
        else
            idict[value] = [key] # make it an array
        end
    end

    return idict
end

idict = invertdict(dic)
#idict[2]
@show(idict[2])
