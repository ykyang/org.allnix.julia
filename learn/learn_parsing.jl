# Purposely not using "using"
import Dates

function find_start_date(io::IOStream)
    for line in eachline(io)
        if !startswith(line, "SECTION  Starting the simulation on")
            continue
        end
        line = strip(line)
        tokens = split(line, x -> x in [' ', '.'], keepempty=false)
        
        start_date = tokens[6] # "01-Feb-2019"

        return start_date
    end

    nothing
end
function find_start_date(path::String)
    open(path, "r") do io
        return find_start_date(io)
    end
end

function add_day(datetime::Dates.DateTime, days::AbstractFloat)
    d = datetime + Dates.Millisecond(Int(days*86400*1000)) # convert days to ms
    return d
end

begin
    prt_file = joinpath(pwd(), "Pad-2_16_158.PRT")
    start_date = find_start_date(prt_file)
    println("Start Date: $start_date")
    start_datetime = Dates.DateTime(start_date, Dates.dateformat"d-u-Y")
    println("Start DateTime: $start_datetime")
    c_datetime = add_day(start_datetime, 12.5)
    println("End DateTime: $c_datetime")
end

nothing
