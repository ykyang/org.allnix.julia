# See Julia Dates
# https://docs.julialang.org/en/v1/stdlib/Dates/#stdlib-dates-api-1

# TODO: remove logging using test instead
using Test
using Logging
logger = ConsoleLogger(stdout, Logging.Info)
global_logger(logger)

using Dates
# https://docs.julialang.org/en/v1/stdlib/Dates/#Dates.DateFormat
# y	        1996, 96	    Returns year of 1996, 0096
# Y	        1996, 96	    Returns year of 1996, 0096. Equivalent to y
# m	        1, 01	        Matches 1 or 2-digit months
# u	        Jan	            Matches abbreviated months according to the locale keyword
# U	        January	        Matches full month names according to the locale keyword
# d	        1, 01	        Matches 1 or 2-digit days
# H	        00	            Matches hours (24-hour clock)
# I	        00	            For outputting hours with 12-hour clock
# M	        00	            Matches minutes
# S	        00	            Matches seconds
# s	        .500	        Matches milliseconds
# e	        Mon, Tues	    Matches abbreviated days of the week
# E	        Monday	        Matches full name days of the week
# p	        AM	            Matches AM/PM (case-insensitive)
# yyyymmdd	19960101	    Matches fixed-width year, month, and day

# https://docs.julialang.org/en/v1/stdlib/Dates/#Constructors
function learn_constructors()
    @test DateTime(2013,1,1) == DateTime(2013)   # partial
    @test DateTime(2013,7,1) == DateTime(2013,7) # partial

    @test_throws ArgumentError DateTime(2013,2,29) # 29 out of range (1:28)

    @test now()              isa DateTime
    @test Date(2020, 12, 23) isa Date
    @test Date(now())        isa Date
end
# https://docs.julialang.org/en/v1/stdlib/Dates/#Durations/Comparisons
function learn_durations_comparisons()
    date_1 = Date(2000,2,1)
    date_2 = Date(2012,2,29)
    
    @test date_1 <  date_2
    @test date_1 != date_2
   
    @test_throws MethodError date_1 + date_2
    @test_throws MethodError date_1 * date_2
    @test_throws MethodError date_1 / date_2
   
    # Duration in Day()
    @test Day( 4411) == date_2 - date_1
    @test Day(-4411) == date_1 - date_2

    dt_1 = DateTime(date_1)
    dt_2 = DateTime(date_2)

    # Duration in Millisecond()
    @test Millisecond(381110400000) == dt_2 - dt_1
end

# https://docs.julialang.org/en/v1/stdlib/Dates/#Accessor-Functions
function learn_accessor()
    date = Date(2014,1,31)

    @test 2014 == year(date)
    @test 1    == month(date)
    @test 5    == week(date)
    @test 31   == day(date)
    
   
    @test Year(2014) == Year(date)
    @test 2014       != Year(date)
    @test Day(31)    == Day(date)
    @test 31         != Day(date)

    @test (2014, 1)     == yearmonth(date)
    @test (1, 31)       == monthday(date)
    @test (2014, 1, 31) == yearmonthday(date)
end

# https://docs.julialang.org/en/v1/stdlib/Dates/#Query-Functions
function learn_query()
    date = Date(2014,1,29)

    @test 3           == dayofweek(date) # Wednesday
    @test "Wednesday" == dayname(date)
    @test "Wed"       == dayabbr(date)
    @test "January"   == monthname(date)
    @test "Jan"       == monthabbr(date)
    @test 31          == daysinmonth(date)
    @test false       == isleapyear(date)
    @test 29          == dayofyear(date)
    @test 1           == quarterofyear(date)
    @test 29          == dayofquarter(date)
    # There are a lot more.
end

function learn_time_type_period_arithmetic()
    @test false == isleapyear(2014)

    @test Date(2014,2,28) == Date(2014,1,29) + Month(1)
    @test Date(2014,2,28) == Date(2014,1,30) + Month(1)
    @test Date(2014,2,28) == Date(2014,1,31) + Month(1)

    # Tricky stuff
    @test Date(2014,2,28)  == (Date(2014,1,29) + Day(1)) + Month(1)
    @test Date(2014,3,1)  ==  Date(2014,1,29) + Day(1)  + Month(1)
    @test Date(2014,3,1)  ==  Date(2014,1,29) + Month(1) + Day(1)

    # How to test this?
    ref_date = Date(2014,1,29) 
    for date in Date(2014,1,29):Day(1):Date(2014,2,3)
        @test ref_date == date
        ref_date += Day(1)
    end

    # Trick
    ref_date = Date(2014,1,31) 
    for date in Date(2014,1,31):Month(1):Date(2014,7,31)
        #@test ref_date == date # does not work
        ref_date += Month(1)
    end
end

# https://docs.julialang.org/en/v1/stdlib/Dates/#Adjuster-Functions
function learn_adjuster()
    @test Date(2014,7,14) ==         firstdayofweek(Date(2014,7,16))
    @test "Monday"        == dayname(firstdayofweek(Date(2014,7,16)))

    @test Date(2014,7,31) == lastdayofmonth(Date(2014,7,16))
    @test Date(2014,9,30) == lastdayofquarter(Date(2014,7,16))

    istuesday = x -> Tuesday == dayofweek(x)

    # 2014-07-13 is a Sunday, the following Tuesday is 2014-07-15
    @test Date(2014,7,15) == tonext(istuesday, Date(2014,7,13))
    # Convenience method to do above
    @test Date(2014,7,15) == tonext(Date(2014,7,13), Tuesday)

    # Find the following Thanksgiving
    @test Date(2014,11,27) == tonext(Date(2014,7,13)) do date
        # Return true when it is the 4th Thursday of November, 
        # that is Thanksgiving.
        Thursday == dayofweek(date) &&
        4        == dayofweekofmonth(date) && # 4th Thursday
        November == month(date)
    end

    # filter
    # Pittsburgh street cleaning: Every 2nd Tuesday from April to November
    Ans = filter(Date(2014):Day(1):Date(2015)) do date
        Tuesday == dayofweek(date) &&
        April <= month(date) <= November &&
        2 == dayofweekofmonth(date)
    end
    @test Ans == [Date("2014-04-08"), Date("2014-05-13"), Date("2014-06-10"), Date("2014-07-08"), Date("2014-08-12"), Date("2014-09-09"), Date("2014-10-14"), Date("2014-11-11")] == [Date("2014-04-08"), Date("2014-05-13"), Date("2014-06-10"), Date("2014-07-08"), Date("2014-08-12"), Date("2014-09-09"), Date("2014-10-14"), Date("2014-11-11")]
end

function learn_parse()
    @test Date(2021,6,18) == Date("06/18/2021", DateFormat("m/d/y"))
    @test Date(2021,6,18) == Date("06/18/2021", dateformat"m/d/y")
    @test Date(2021,6,18) == Date("6/18/2021",  dateformat"m/d/y")
    @test Date(0021,6,18) == Date("6/18/21",    dateformat"m/d/y")
    @test Date(0021,6,18) == Date("6/18/21",    dateformat"m/d/y")

    @test Date(2021,6,18) == Date("2021-Jun-18", dateformat"y-u-d")
end

function learn_print()
    @test "Friday"      == Dates.format(Date(2021,6,18), "E")
    @test "Saturday"    == Dates.format(Date(2021,6,19), "E")
    @test "Friday-2021" == Dates.format(Date(2021,6,18), "E-yyyy")
    @test "Friday-21"   == Dates.format(Date(2021,6,18), "E-yy")

    @test "2021-Jun-18" == Dates.format(Date(2021,6,18), "yyyy-u-d")
    @test "2021-Jun-18" == Dates.format(Date(2021,6,18), "yyyy-u-dd")
    @test "2021-Jun-1"  == Dates.format(Date(2021,6,1), "yyyy-u-d")
    @test "2021-Jun-01" == Dates.format(Date(2021,6,1), "yyyy-u-dd")

    # ISODateFormat     dateformat"yyyy-mm-dd"
    # ISODateTimeFormat dateformat"yyyy-mm-ddTHH:MM:SS.s"    
        
    # How to compare?
    #@test isequal(ISODateTimeFormat, dateformat"yyyy-mm-ddTHH:MM:SS.s")
end

function learn_arithemtic()
    # +
    @test Date(2021,6,21) == Date(2021,6,18) + Day(3)
    @test_throws MethodError Date(2021,6,18) + Millisecond(3*86400*1000)
    @test Date(2021,6,21) == DateTime(2021,6,18) + Millisecond(3*86400*1000)
    

    # -
    @test Day(11) == Date(2021,10,31) - Date(2021, 10,20) 
    @test Day(11) == convert(Day, DateTime(2021,10,31) - DateTime(2021, 10,20)) # milliseconds
    @test Millisecond(11*86400*1000) == DateTime(2021,10,31) - DateTime(2021, 10,20)

    # >
    @test Date(2021,6,21) > Date(2021,6,18)

    # Access value as Int64
    @test 11 == Day(11).value
    @test Day(11).value isa Int64

    @test Date(2021,10,31) == DateTime(2021,10,31)
end

"""
Use to generate a list of dates for use in production schedule.
"""
function print_dates(io::IO)
    for date in Date(2014,1,29):Day(1):Date(2014,2,3)
        str = Dates.format(date, "dd-u-Y")
        println(io, "DATE \"$str\"")
    end
end

# generate a list of date


@test DateTime("2019-2-1T00:00:00") == DateTime(2019, 2, 1)

@test DateTime(2020, 12, 29) > DateTime(2020, 12, 25)
io = stdout
io = devnull
print_dates(io)

@testset "Base" begin
    learn_constructors()
    learn_durations_comparisons()
    learn_accessor()
    learn_query()
    learn_time_type_period_arithmetic()
    #learn_adjuster()
    learn_parse()
    learn_print()
    learn_arithemtic()

    learn_adjuster() # remove and uncomment above once done
end
nothing # suppress last line printout