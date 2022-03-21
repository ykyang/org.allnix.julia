# https://docs.julialang.org/en/v1/manual/modules/

using Test

module Bar
    x = 13.0
    
    function foo()
        return x
    end
end

#import .Bar # . relative import path

@test 13 == Bar.foo()

module A
    x = 17.0
    function foo()
        return x
    end

    module AA
        x = 19.0
        function foo()
            return x
        end
    end
    module AB
        x = 23.0
        function foo()
            return x
        end
    end

    module AAB
        import ..AA
        import ..AB
        
        function foo()
            return AA.foo() + AB.foo()
        end
    end
end

#import .A

@test 17 == A.foo() 

@test 19 == A.AA.foo()
@test 23 == A.AB.foo()

#import .A.AAB
@test 42 == A.AAB.foo()

## Use variable for shortcut
x = A
@test x.foo() == 17
x = A.AA
@test x.foo() == 19
x = A.AB
@test x.foo() == 23
x = A.AAB
@test x.foo() == 42
nothing

