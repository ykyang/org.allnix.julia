module LearnDates
# See Julia Dates
# https://docs.julialang.org/en/v1/stdlib/Dates/#stdlib-dates-api-1

# TODO: remove logging using test instead
using Test
using Logging
logger = ConsoleLogger(stdout, Logging.Info)
global_logger(logger)

using DataFrames

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
    # Partial construction
    @test DateTime(2013,1,1) == DateTime(2013)   # partial
    @test DateTime(2013,7,1) == DateTime(2013,7) # partial

    # Formatter
    @test DateTime(2022,02,05) == DateTime("2022-02-05", "yyyy-mm-dd")

    @test_throws ArgumentError DateTime(2013,2,29) # 29 out of range (1:28)

    @test now()              isa DateTime
    @test Date(2020, 12, 23) isa Date
    @test Date(now())        isa Date

    # Construct DateTime from Date
    @test DateTime(2020,1,1) == DateTime(Date(2020,1,1))

    # Construct Time
    @test Time(10,30,00) == Time("10:30")
    @test Time(22,30,00) == Time("22:30")
    @test Time(22,30,00) == Time("10:30PM", "HH:MMp") 
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

# https://docs.julialang.org/en/v1/stdlib/Dates/#Period-Types
function learn_period_types()
    @test 1 == Year(1).value
    @test Year(3) == Year(1) + Year(2)
    
    @test 5       == div(Year(10), Year(2))
    @test Year(5) == div(Year(10), 2) # Year(10) ÷ 2
    @test Year(5) == Year(10) / 2
    @test 5       == Year(10) / Year(2)

    @test Year(3) == div(Year(10), 3)
    @test_throws InexactError Year(10) / 3

    @test 10 == Millisecond(10).value
    @test 10 == Dates.value(Millisecond(10))
end

# https://docs.julialang.org/en/v1/stdlib/Dates/#Rounding
function learn_rounding()
    @test Date(1985,8,1) == floor(Date(1985,8,16), Month)
    @test DateTime(2013,2,13,0,45,0) == ceil(DateTime(2013,2,13,0,31,20), Minute(15))
    @test DateTime(2016,8,7) == round(DateTime(2016,8,6,20,15), Day)
    # ISO 8601 standard, 0000-01-01T00:00:00 was chosen as base (or "rounding epoch") 
end

function learn_parse()
    @test Date(2021,6,18) == Date("06/18/2021", DateFormat("m/d/y"))
    @test Date(2021,6,18) == Date("06/18/2021", dateformat"m/d/y")
    @test Date(2021,6,18) == Date("6/18/2021",  dateformat"m/d/y")
    @test Date(0021,6,18) == Date("6/18/21",    dateformat"m/d/y")
    @test Date(0021,6,18) == Date("6/18/21",    dateformat"m/d/y")

    @test Date(2021,6,18) == Date("2021-Jun-18", dateformat"y-u-d")

    @test DateTime(2021,6,18,15,38, 17) == DateTime("2021-Jun-18T15:38:17", DateFormat("y-u-dTHH:MM:SS"))
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

    # Built-in formats
    # ISODateFormat     dateformat"yyyy-mm-dd"
    # ISODateTimeFormat dateformat"yyyy-mm-ddTHH:MM:SS.s"    
        
    # How to compare?
    #@test isequal(ISODateTimeFormat, dateformat"yyyy-mm-ddTHH:MM:SS.s")
end

function learn_arithemtic()
    # Date - Date = Day
    @test isa(Date(2021,6,21) - Date(2021,6,18), Day)

    # DateTime - DateTime = Millisecond
    @test isa(DateTime(2021,6,21) - DateTime(2021,6,18), Millisecond)

    # Time - Time = Nanosecond
    #@show Time(10,00,01) - Time(10,00,00)

    # +
    @test Date(2021,6,21) == Date(2021,6,18) + Day(3)
    @test_throws MethodError Date(2021,6,18) + Millisecond(3*86400*1000)
    #@test Date(2021,6,21) == Date(2021,6,18) + Millisecond(3*86400*1000)
    @test Date(2021,6,21) == DateTime(2021,6,18) + Millisecond(3*86400*1000)
    @test isa(DateTime(2021,6,18) + Year(1), DateTime)

    # -
    @test Day(11) == Date(2021,10,31) - Date(2021, 10,20) 
    @test Day(11) == convert(Day, DateTime(2021,10,31) - DateTime(2021, 10,20)) # milliseconds
    @test Millisecond(11*86400*1000) == DateTime(2021,10,31) - DateTime(2021, 10,20)

    # >
    @test Date(2021,6,21) > Date(2021,6,18)

    # Access value as Int64
    @test 11 == Day(11).value
    @test Day(11).value isa Int64

    # Comparing between Date and DateTime
    @test Date(2021,10,31) == DateTime(2021,10,31)
    @test Date(2021,10,31) > DateTime(2021,10,30, 23)
    @test Date(2021,10,31) < DateTime(2021,10,31, 1)
end


"""

Create a list of dates from `t1` to `t2` such that
`[t1, lastdayofmonth(t1), lastdayofmonth(t1+Month(1)) ... t2]`

"""
function schedule(t1::DateTime, t2::DateTime)
    df = DataFrame(
        "date" => DateTime[],
        "data" => Int64[],    # Data for testing
    )

    push!(df, [t1, 1])
    push!(df, [t2, 10000])

    endofmonths = lastdayofmonth.(collect(t1:Month(1):t2))
    df2 = DataFrame(
        "date" => endofmonths,
        "data" => fill(Int64(-9999), size(endofmonths))
    )

    append!(df, df2)

    # Remove rows later than t2
    df = subset(df, :date => x -> x .<= t2)
    # Remove duplicated rows (keep first occurance)
    df = unique(df, :date)
    # Sort
    df = sort(df, [:date])
end

function learn_schedule_monthly()
    # Create a monthly schedule to print at the end of each month
    # start date
    # lastdayofmonth()
    # ...
    # end data

    # In addition, there are data associated with each date.
    # Using a DataFrame seem like an easy solution.
    


    

    # Create a list of date including t1, lastdayofmonth(t1), lastdayofmonth(t1+Month(1)) ... t2
    # t1 = DateTime(2022,01,15) # Start date
    # t2 = DateTime(2023,02,16) # End date

    

    df = schedule(DateTime(2022,01,01), DateTime(2023,02,19))
    @test nrow(df) == 15
    df = schedule(DateTime(2022,01,01), DateTime(2023,02,01))
    @test nrow(df) == 15
    df = schedule(DateTime(2022,01,01), DateTime(2023,02,15))
    @test nrow(df) == 15
    df = schedule(DateTime(2022,01,01), DateTime(2023,02,28))
    @test nrow(df) == 15
    

    df = schedule(DateTime(2022,01,15), DateTime(2023,02,19))
    @test nrow(df) == 15
    df = schedule(DateTime(2022,01,15), DateTime(2023,02,01))
    @test nrow(df) == 15
    df = schedule(DateTime(2022,01,15), DateTime(2023,02,15))
    @test nrow(df) == 15
    df = schedule(DateTime(2022,01,15), DateTime(2023,02,28))
    @test nrow(df) == 15

    df = schedule(DateTime(2022,01,31), DateTime(2023,02,19))
    @test nrow(df) == 14
    df = schedule(DateTime(2022,01,31), DateTime(2023,02,01))
    @test nrow(df) == 14
    df = schedule(DateTime(2022,01,31), DateTime(2023,02,15))
    @test nrow(df) == 14
    df = schedule(DateTime(2022,01,31), DateTime(2023,02,28))
    @test nrow(df) == 14


    df = schedule(DateTime(2022,01,31), DateTime(2023,02,28))
    @test nrow(df) == 14
    
    

    return df
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

# @test DateTime("2019-2-1T00:00:00") == DateTime(2019, 2, 1)

# @test DateTime(2020, 12, 29) > DateTime(2020, 12, 25)
# io = stdout
# io = devnull
# print_dates(io)


end # module LearnDates