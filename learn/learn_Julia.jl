# Learn basic Julia stuff
module MyJulia

using Test
import Serialization

# Learn operator overloading
mutable struct Node
    id::Int64

    Node() = ( # incomplete initialization
        me = new();
        me
    )
    Node(id) = (
        me = new();
        me.id = id;
        me
    )
end
# https://discourse.julialang.org/t/proper-way-to-overload-operators/19872

# One can use function name or symbol to implement operator overloading

Base.:(<)(x::Node, y::Node) = x.id < y.id # Base.isless(x::Node, y::Node) = x.id < y.id
function Base.:(==)(x::Node,y::Node) 
    return x.id == y.id
end
# used by sort()
Base.isless(x::Node, y::Node) = error("Unsupported operation")

# isequal => ===
#Base.isequal(x::Node, y::Node) = x.id == y.id

"""

Boolean product
See pp.193 of Discrete Mathematics and Its Applications
"""
function product(A::Matrix{Bool}, B::Matrix{Bool})
    # Check size(A)[2] == size(B)[1] ???
    X = Matrix{Bool}(undef, size(A)[1], size(B)[2])
    for i in 1:size(A)[1]
        for j in 1:size(B)[2]
            X[i,j] = any(A[i,:] .& B[:,j])
        end
    end

    return X
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

    for i in 1:2, j in 3:4
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
end

function learn_Serialization()
    node = MyJulia.Node(13)

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

    # pp.193 of Discrete Mathematics and Its Applications
    # Example 9
    C = Bool[0 0 1; 1 0 0; 1 1 0;]
    C2 = product(C,C)
    @test C2 == [1 1 0; 0 0 1; 1 0 1;]
    C3 = product(C2,C)
    @test C3 == [1 0 1; 1 1 0; 1 1 1;]
    C4 = product(C3,C)
    @test C4 == [1 1 1; 1 0 1; 1 1 1;]
    C5 = product(C4,C)
    @test C5 == [1 1 1; 1 1 1; 1 1 1;]
end

"""

See ``learn_Distributions.jl`` for more examples and
more advanced usage.
"""
function learn_rand()
    # 1 random number bewteen 1:50
    @test 1<= rand(1:50) <= 50
    
    # 1000 random numbers between 1:10
    r = rand(1:10, 1000)
    @test all(1 .<= r .<= 10)

    # 10x10 random numbers
    Ans = rand(10,10)
    @test size(Ans) == (10,10)
    
    # Random numbers in normal distribution
    Ans = randn(50)
    @test size(Ans) == (50,)
end

@testset "Node" begin
    #MyJulia.learn_Node()
    learn_Node()
end
@testset "Basic" begin
    learn_resize!()
    learn_searchsortedfirst()

    learn_CartesianIndex()
    learn_Serialization()

    learn_rand()
end
@testset "For-Loop" begin
    learn_for_comma()
    learn_comprehension()
    learn_for_zip()
end
@testset "Matrix" begin
    learn_Matrix()
end
#learn_exception()


end # module MyJulia

nothing