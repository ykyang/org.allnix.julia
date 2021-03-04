# Purposely not using "using"
using Revise

import Dates
import OilData    # purposely not using "using"

od = OilData

using Logging
logger = SimpleLogger(stdout, Logging.Info)
global_logger(logger)


function find_start_date(io::IOStream)
    for line in eachline(io)
        if !startswith(line, "SECTION  Starting the simulation on")
            continue
        end
        line = strip(line)
        #tokens = split(line, x -> x in [' ', '.'], keepempty=false)
        tokens = split(line, [' ', '.'], keepempty=false)
        
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


function count_row(io::IOStream)
    # 1
    readline(io)
    # 1st dash line
    readline(io)
    # Summary
    readline(io)    
    # 2nd dash line
    readline(io)

    # 4 lines of header
    readline(io)
    readline(io)
    readline(io)
    readline(io)
    # 3rd dash line
    readline(io)

    # start counting
    row_count = 0
    for line in eachline(io)
        if length(line) == 1 # line has only 1 char "1"
            return row_count
        end
        if !isempty(line)
            row_count += 1
        end
    end
    
    return row_count
end
function read_section(io::IOStream, row_count)
    # 1
    line = readline(io)

    # 1st dash line
    line = readline(io)
    
    # Summary
    line = readline(io)

    # 2nd dash line
    line = readline(io)

    col_width = 15
    # 1st ID
    line = readline(io)
    line = line[2:end] # remove 1st char (space)
    col_count = length(line) ÷ col_width
    
    ids = Vector{String}(undef, col_count)
    values = ids
    for col = 1:col_count
        start_ind = (col-1)*col_width + 1
        end_ind   = col*col_width
        token = line[start_ind:end_ind]
        values[col] = strip(token)
    end
    #@show ids
    # Unit
    line = readline(io)
    line = line[2:end] # remove 1st char (space)
    values = units = Vector{String}(undef, col_count)
    for col = 1:col_count
        start_ind = (col-1)*col_width + 1
        end_ind   = col*col_width
        token = line[start_ind:end_ind]
        values[col] = strip(token)
    end
    #@show units
    # FIELD/Well Name
    line = readline(io)
    line = line[2:end] # remove 1st char (space)
    values = id2s = Vector{String}(undef, col_count)
    for col = 1:col_count
        start_ind = (col-1)*col_width + 1
        end_ind   = col*col_width
        token = line[start_ind:end_ind]
        values[col] = strip(token)
    end
    #@show id2s
    # Reservoir ID?
    # Block ID: 23 12 11
    line = readline(io)
    line = line[2:end] # remove 1st char (space)
    values = id3s = Vector{String}(undef, col_count)
    for col = 1:col_count
        start_ind = (col-1)*col_width + 1
        end_ind   = col*col_width
        token = line[start_ind:end_ind]
        values[col] = strip(token)
    end
    #@show id3s
    # 3rd dash line
    line = readline(io)

    table = Array{Float64}(undef, row_count, col_count)
    # Read values
    for rind = 1:row_count
        line = readline(io)
        tokens = split(line, keepempty=false)
        for (cind,token) = enumerate(tokens)
            value = parse(Float64, token)
            table[rind,cind] = value
        end
    end
    #@show table
end
function read_rsm(io::IOStream, row_count)
    # count number of rows
    # actual read
    reservoir_id = 0
    section_id = 0
    more = true
    while !eof(io)
        read_section(io, row_count)
    end
    # for line in eachline(io)
    #     line = rstrip(line)
    #     if isempty(line)
    #         continue
    #     end
    #     if length(line) > 1
    #         continue
    #     end
    #     # Is this reservoir ID?
    #     reservoir_id = parse(Int, line)
    #     #if line == "1"
    #     section_id += 1
    #     println("Section $section_id")
    #     read_section(io)
    #     #end
    # end
end

begin
    prt_file = joinpath(pwd(), "Project-2_16_158.PRT")
    start_datetime = od.find_prt_start_date(prt_file)
    @info "Start Date: $start_datetime"
    #start_datetime = Dates.DateTime(start_date, Dates.dateformat"d-u-Y")
    #@info "Start DateTime: $start_datetime"
    end_datetime = od.add_day(start_datetime, 12.5)
    @info "End DateTime: $end_datetime"
end

begin
    rsm_file = joinpath(pwd(), "Project-2_16_158.RSM")
    row_count = 0
    open(rsm_file, "r") do io
        global row_count = count_row(io)
    end
    
    open(rsm_file, "r") do io
        read_rsm(io, row_count)
    end
end

nothing
