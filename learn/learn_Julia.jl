# Learn basic Julia stuff
module LearnJulia

using Test
import Serialization

## Use Julia generated document, @doc Node, to doc the struct.
"""
    Node

$(replace(string(@doc Node), "No documentation found.\n\n"=>""))
"""
mutable struct Node
    id::Int

    Node(id) = (me = new(); me.id = id; me) # Inner constructor
end

Node() = Node(0) # Outer constructor

# https://discourse.julialang.org/t/proper-way-to-overload-operators/19872

# One can use function name or symbol to implement operator overloading

#Base.:(<)(x::Node, y::Node) = x.id < y.id # Base.isless(x::Node, y::Node) = x.id < y.id
function Base.:(==)(x::Node,y::Node) 
    return x.id == y.id
end
# used by sort()
#Base.isless(x::Node, y::Node) = error("Unsupported operation")
Base.isless(x::Node, y::Node) = x.id < y.id

# isequal => ===
#Base.isequal(x::Node, y::Node) = error("Unsupported operation")

## required by Set
function Base.hash(n::Node, h::UInt)
    return hash(n.id, h)
end

struct OrderedPair
    x::Real
    y::Real
    # Inner constructor
    OrderedPair(x,y) = x > y ? error("out of order") : new(x,y)
end

OrderedPair(x) = OrderedPair(x,x)

function Base.:(==)(x::OrderedPair,y::OrderedPair) 
    return x.x == y.x && x.y == y.y
end

function learn_Node()
    @test Node(7) == Node(7)
    @test Node(7) != Node(13)
    
    @test Node(7) < Node(13)
    @test Node(7) <= Node(13)
    @test Node(13) <= Node(13)

    @test Node(13) > Node(7)
    @test Node(13) >= Node(7)
    @test Node(13) >= Node(13)
end


function learn_arguments()
    function varg(x, args...; nargs...)
        # @show typeof(args)
        # @show args
        # @show typeof(nargs)
        # @show nargs
        for arg in args
            @show arg
        end
        for narg in nargs
            @show narg
        end
    end
    function varg2(x, args...; nargs...)
        varg(x, args...; nargs...)
    end

    varg2(1, 2, 3;x=1, y=2)
    """
    arg = 2
    arg = 3
    narg = :x => 1
    narg = :y => 2
    """
end

function learn_exception()
    ## Show stack trace after catch
    # https://docs.julialang.org/en/v1/manual/stacktraces/#Exception-stacks-and-[current_exceptions](@ref)
    try
        error("(A) The root cause")
    catch
        try
            error("(B) An exception in catch")
        catch
            # (exception,backtrace)
            for (exc, bt) in current_exceptions()
                showerror(stdout, exc, bt)
                println(stdout)                
            end
        end
    end
end


#mj = MyJulia

#mj.learn_Node()

function learn_resize!()
    x = [1,2,3]
    y = x
    @test y === x
    @test 3 == length(y)

    resize!(x, 1)
    @test y === x
    @test 1 == length(y)
    @test 1 == y[1]

    resize!(x, 0)
    @test y === x
    @test isempty(y)
    
end

function learn_searchsortedfirst()
    v = Float64[1, 2, 3, 4, 5]
    
    i = searchsortedfirst(v, 1)
    @test 1 == i

    i = searchsortedfirst(v, 1.5)
    @test 2 == i

    i = searchsortedfirst(v, 2)
    @test 2 == i
end

"""

Learn for-loop syntax
```
for i in 1:2, j in 3:4
end
```
"""
function learn_for_comma()
    ijs = []

    for i in 1:2, j in 3:4 # loop through j first
        push!(ijs, (i,j))
    end

    @test [
        (1,3),
        (1,4),
        (2,3),
        (2,4)
    ] == ijs
end

"""
    learn_comprehension()

There are two ways to do two for-loops using comprehension.
"""
function learn_comprehension()
    # List of pairs
    x1 = [(i,j) for i in 1:2 for j in 3:4]
    @test [
        (1, 3), 
        (1, 4), 
        (2, 3), 
        (2, 4)
    ] == x1

    # Matrix of pairs
    x2 = [(i,j) for i in 1:2,j in 3:4]
    @test [
        (1, 3) (1, 4); 
        (2, 3) (2, 4)
    ] == x2

    # Flatten
    # Notice the order is different from x1
    @test [(1, 3), (2, 3), (1, 4), (2, 4)] == x2[:]
    @test [
        (1, 3), 
        (2, 3), 
        (1, 4), 
        (2, 4)
    ] == vec(x2)
end

function learn_for_zip()
    # Learn zip 3 arrays
    Ans = []
    for (i,j,k) in zip([1,2], [3,4], [5,6])
        push!(Ans, (i,j,k))
    end 

    @test [
        (1,3,5),
        (2,4,6)
    ] == Ans


    # Learn enumerate with zip
    Ans = []
    for (ind, (i,j,k)) in enumerate(zip([1,2], [3,4], [5,6]))
        push!(Ans, [ind, i,j,k])
    end

    @test Ans == [
        [1,1,3,5],
        [2,2,4,6],
    ]
end

function learn_CartesianIndex()
    ind = CartesianIndex(1,2,3)

    @test (1,2,3) == ind.I

    inds = [CartesianIndex(1,2,3), CartesianIndex(4,5,6)]
    shifted_inds = [ind + CartesianIndex(1,0,0) for ind in inds]
    @test shifted_inds == [CartesianIndex(2,2,3), CartesianIndex(5,5,6)]
    
end

function learn_Serialization()
    node = LearnJulia.Node(13)

    filename = "serialization.jls"
    open(filename, "w") do io
        Serialization.serialize(io, node)
    end

    node_deserialized = Serialization.deserialize(filename)

    @test node_deserialized == node
end

function learn_Matrix()
    A = Matrix{Int64}(undef, 2, 2)
    A .= [1 2; 
          3 4;]
    @test A == [1 2; 3 4;]
    @test A[2,1] == 3
    @test A[1,2] == 2
    
    A = Int64[1 2; 3 4] # Another way to init a matrix
    @test A == [1 2; 3 4;]
    @test A[2,1] == 3
    @test A[1,2] == 2

    B = Matrix{Bool}(undef, 2,2)
    B .= [
        1 1;
        0 0;
    ]
    @test B == [true true; false false;]
    @test B[2,1] == 0
    @test B[1,2] == 1

    B = Bool[true true; false false;]
    @test B == [true true; false false;]
    @test B[2,1] == false
    @test B[1,2] == true
end

function learn_floor_fld_ceil_cld()
    @test floor(11/3) == 3
    @test floor(11/3) isa Float64
    @test   fld(11,3) == 3
    @test   fld(11,3) isa Int64

    @test floor(-11/3) == -4
    @test floor(-11/3) isa Float64
    @test   fld(-11,3) == -4
    @test   fld(-11,3) isa Int64

    @test ceil(11/3) == 4
    @test ceil(11/3) isa Float64
    @test  cld(11,3) == 4
    @test  cld(11,3) isa Int64

    @test ceil(-11/3) == -3
    @test ceil(-11/3) isa Float64
    @test  cld(-11,3) == -3
    @test  cld(-11,3) isa Int64
end

"""

The Division Algorithm, 
```
a = dq + r
q = a div d 
r = a mod d

0 ≤ r < d
```


The functions for `div` are `fld(a,d)` or `div(a,d,RoundDown)`.
The function for `mod` is `mod(a,d)`.
"""
function learn_div_mod()
    # Discrete Mathematics and Its Applications, pp.253

    a = 101; d = 11; q = 9; r = 2;
    # a   =  d*q + r
    # 101 = 11*9 + 2
    @test div( a,  d, RoundDown) == q
    @test div(101,11, RoundDown) == 9
    @test fld(a,d) == div(a,d,RoundDown) # from doc of func
    @test div( a,  d)            == q
    @test div(101,11)            == 9

    @test mod(  a, d) == r
    @test mod(a,d) == a - d*fld(a,d) # from doc of func
    @test mod(101,11) == 2
    @test a - d*q        == r
    @test a - d*fld(a,d) == r

    # Notice the use of RoundDown
    a = -11; d = 3; q = -4; r = 1;
    #   a=  d*q    + r
    # -11 = 3*(-4) + 1
    @test div( a,  d, RoundDown) == q
    @test div(-11, 3, RoundDown) == -4  # Follow the definition in math
    @test fld(a,d) == div(a,d,RoundDown) # from doc of func
    @test div( a,  d)            == q + 1
    @test div(-11, 3)            == -3  # Default RoundToZero
    

    @test mod(  a, d) == r
    @test mod(a,d) == a - d*fld(a,d) # from doc of func
    @test mod(-11, 3) == 1
    @test a - d*q        == r
    @test a - d*fld(a,d) == r
end

"""

Print "01234543210"
"""
function learn_123()
    for i in -5:5
        print(5 - abs(i))
    end
end



function learn_reduce()
    @test reduce(*, [2,3,4])          == 24
    @test reduce(*, [2,3,4], init=-1) == -24
    @test reduce(*, [], init=-1)      == -1
    @test_throws MethodError reduce(*, [])  # must specify init
end

"""
    learn_summarysize()

Size of array, type, etc
"""
function learn_summarysize()
    @test Base.summarysize(Int(13))       == 8
    @test Base.summarysize(fill(Int, 1))  == 40 +  1*8 # Overhead 40 bytes
    @test Base.summarysize(fill(Int, 2))  == 40 +  2*8
    @test Base.summarysize(fill(Int, 10)) == 40 + 10*8


end

function learn_types()
    supertype(Int64)
    supertypes(Int64)
    subtypes(Real)
end

function learn_bin_oct_dec_hex_()
    @test string(17, base=10) == "17"
    @test string(17, base=8)  == "21"
    @test string(17, base=16) == "11"
    @test string(17, base=2)  == "10001"
end

function learn_Tuple()
    let
        x = (1,2,3)
        @test x[1] == 1
    end
    let
        x = (a=1, b=2, c=3)
        @test x.a == 1
    end
    let
        props = (a=Float64[], b=Int[])
        #@show typeof(x.a)
        #@show eltype(x.a)
        z = eltype(props.a)[]
        #@show z
        push!(z, 123)
        @test z[1] == 123


        for prop in props
            #@show prop
        end
    end 
end

function learn_Pair()
    let
        props = ["a"=>1, "b"=>2]
        for prop in props
            # @show prop
            # @show prop[1]
        end
    end
end

struct Point{T}
    x::T
    y::T
end


function learn_struct_1()
    p = Point{Int}(1,2)
    @test Point{Float64} <: Point
    #@show p
    Number 

    nothing
end

function printab(; a, b)
    println(a, ", ", b)
end

function learn_keyword_argument()
    a = 1; b = 2;
    printab(;a=a,b=b) 
    printab(;a,b)     # This works?
    printab(;a=a,b)   # What about this?
    printab(;a,b=b)   # What about this?
end

## Learn metaprogramming
for op in (:set_xlim, :set_ylim)
    eval(quote
        function $op(a, b...; nargs...)
            @show a
            for arg in b
                @show arg
            end
            for narg in nargs
                @show narg
            end
        end
    end)
end

#learn_bin_oct_dec_hex_()

#learn_exception()
#learn_123()

export Node, OrderedPair
end # module

nothing