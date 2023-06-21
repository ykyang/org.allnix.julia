using DomainSets
using Test

@test 0.5 in UnitInterval()
@test 0 in UnitInterval()

@test 0.1 in ClosedInterval(-1,1)
@test -1 in ClosedInterval(-1,1)
@test 1.0 in ClosedInterval(-1,1)