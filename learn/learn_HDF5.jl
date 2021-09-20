using HDF5
using Test

function learn_open_hdf5()
    
    fname = tempname(pwd())
    @test !isfile(fname)
    
    # https://juliaio.github.io/HDF5.jl/stable/
    # "r"	read-only
    # "r+"	read-write, preserving any existing contents
    # "cw"	read-write, create file if not existing, preserve existing contents
    # "w"	read-write, destroying any existing contents (if any)
    fid = h5open(fname, "cw") # Open
    @test isfile(fname)

    close(fid)                # Close
    @test isfile(fname)

    rm(fname)                 # Clean
    @test !isfile(fname)

    # The "do" syntax
    h5open(fname, "cw") do fid     # Open with the "do" syntax
        @test isfile(fname)
    end

    rm(fname)                 # Clean
    @test !isfile(fname)
end

function learn_create_group()
    fname = tempname(pwd(), cleanup=true)
    fid = h5open(fname, "cw")
    @test fid isa HDF5.File
    
    create_group(fid, "/g1")     # Create at root
    create_group(fid, "/g2/g3")  # Create multiple layers
    
    @test keys(fid) == ["g1", "g2"]
    @test keys(fid["g2"]) == ["g3"]

    create_group(fid["g1"], "g4")    # /g1/g4
    @test keys(fid["g1"]) == ["g4"]

    # Create /g1/g5 while /g1 exists
    create_group(fid, "/g1/g5")           
    @test keys(fid["g1"]) == ["g4", "g5"] 

    close(fid)
    # rm(fname) # tempname() will delete files
end

function learn_create_dataset()
    data = [13.0, 17.0, 19.0] # const data

    fname = tempname(pwd(), cleanup=true)
    h5 = h5open(fname, "cw")

    # 4 ways to create dataset
    # Some set the dataset to the value provided
    # Some set the dataset to default values

    # The content of dataset is [0.0, 0.0, 0.0] not [13.0, 17.0, 19.0]
    name = "mydata1"
    xd, dtype = create_dataset(h5, name, data)
    @test xd    isa HDF5.Dataset 
    @test dtype isa HDF5.Datatype   #@show dtype # HDF5.Datatype: H5T_IEEE_F64LE
    @test h5[name][:] == [0.0, 0.0, 0.0]

    name = "mydata2"
    xd = create_dataset(h5, name, datatype(eltype(data)), dataspace(size(data)))
    @test xd isa HDF5.Dataset
    @test h5[name][:] == [0.0, 0.0, 0.0]

    name = "mydata3"
    h5[name] = data               # Create
    @test h5[name] isa HDF5.Dataset
    @test h5[name][:] == [13.0, 17.0, 19.0]

    name = "mydata4"
    write(h5, name, data)
    @test h5[name] isa HDF5.Dataset
    @test h5[name][:] == [13.0, 17.0, 19.0]

    close(h5)
end

function learn_dataset()
    data = [13.0, 17.0, 19.0] # const data

    fname = tempname(pwd(), cleanup=true)
    name = "mydata"
    
    # Create
    h5open(fname, "cw") do h5
        @test !haskey(h5, name)
        h5[name] = data         # HDF5.Dataset
        @test haskey(h5, name)
        @test_throws ErrorException h5[name] = data # Cannot create again
        @test h5[name][:] == [13.0, 17.0, 19.0]
    end
    
    # Modify
    h5open(fname, "cw") do h5
        d = h5[name]     # HDF5.Dataset
        d[1] = 11.0
        @test h5[name][:] == [11.0, 17.0, 19.0]
    end 

    # Re-open, persistent
    h5open(fname, "r") do h5
        @test h5[name][:] == [11.0, 17.0, 19.0]
    end

    # Access non-existent dataset
    h5open(fname, "r") do h5
        name = "na"
        @test_throws KeyError h5[name]
    end
end


function learn_attribute()
    data = [13.0, 17.0, 19.0] # const data

    fname = tempname(pwd(), cleanup=true)
    name = "mydata"

    # Attribute for group
    h5open(fname, "cw") do h5 
        g = create_group(h5, "G")
        attr, dtype = create_attribute(g, "attr-1", 13.0) # HDF5.Attribute
        @test attr isa HDF5.Attribute
        @test read(attr) == 0.0
    end

    h5open(fname, "cw") do h5
        attr = attributes(h5["G"])["attr-1"]
        @test attr isa HDF5.Attribute
        write(attr, 11.0)
        @test read(attr) == 11.0
    end

    h5open(fname, "cw") do h5
        attr = open_attribute(h5["G"], "attr-1")
        @test attr isa HDF5.Attribute
        @test read(attr) == 11.0
    end
        
end

function learn_writing_a_group_or_dataset()
    # Test const data
    data = [13.0, 17.0, 19.0]

    ## Create aHDF5 file
    # Must close at the end
    # One can use the do syntax
    #   h5open(fname, "cw") do fid
    #   end
    fname = tempname(pwd(), cleanup=true)
    fid = h5open(fname, "cw")
    
    ## Create group: /mygroup/
    # Group is like a folder
    g = create_group(fid, "mygroup")       # Create
    # Access non-existing group
    @test_throws KeyError fid["thegroup"]
    # Access a group
    x = fid["mygroup"]                     # Get
    @test g    != x      
    @test g.id != x.id
    @test g.file == x.file

    ## Create dataset 1
    # From the source code
    # Create datasets and attributes with "native" types, but don't write the data.
    # The return syntax is: dset, dtype = create_dataset(parent, name, data; properties...)
    name = "mydata1"
    xd, dtype = create_dataset(fid, name, data)
    @test xd isa HDF5.Dataset 
    @test dtype isa HDF5.Datatype #@show dtype # HDF5.Datatype: H5T_IEEE_F64LE
    x = read(fid, name)             # Read
    @test x isa Vector{Float64}
    @test x == [0.0, 0.0, 0.0]
    @test x != [13.0, 17.0, 19.0]   # x is not [13.0, 17.0, 19.0]
    x[1] = 7.0                      # Modify x does not modify the file
    x = read(fid, name)             # Read
    @test x ==  [0.0, 0.0, 0.0]     #
    xd[1] = 7.0                     # Modify dset modifies the file
    x = read(fid, name)             # Read
    @test x ==  [7.0, 0.0, 0.0]     #

    ## Create dataset 2
    # Create by specifing data type and size.
    name = "mydata2"
    xd = create_dataset(fid, name, datatype(eltype(data)), dataspace(size(data)))
    @test xd isa HDF5.Dataset 
    x = read(fid, name)
    @test x isa Vector{Float64}
    @test x == [0.0, 0.0, 0.0]      # Initialized to zeros
    x[1] = 7.0                      # Modify x does not modify the file 
    x = read(fid, name)             # Read
    @test x ==  [0.0, 0.0, 0.0]
    xd[1] = 7.0                     # Modify dset modifies the file
    x = read(fid, name)
    @test x ==  [7.0, 0.0, 0.0]

    ## Create dataset 3
    # Create by [] operator
    name = "mydata3"
    fid[name] = data               # Create
    x = read(fid, name)            # Read
    @test x isa Vector{Float64}
    @test x == [13.0, 17.0, 19.0]  # x is set correctly
    x[1] = 7.0                     # This does not change the data
    x = read(fid, name)
    @test x == [13.0, 17.0, 19.0]
    d = open_dataset(fid, name)    # Get
    d[1] = 7.0                     # Write
    x = read(fid, name)            # Read
    @test x == [7.0, 17.0, 19.0]   # Data is set correctly
        
    ## Create dataset 4
    # Create by write()
    name = "mydata4"
    write(fid, name, data)
    x = read(fid, name)
    @test x == [13.0, 17.0, 19.0]  # x is set correctly
    d = open_dataset(fid, name)    # Get
    d[1] = 7.0                     # Write
    x = read(fid, name)            # Read
    @test x == [7.0, 17.0, 19.0]   # Data is set correctly

    close(fid)
    
    rm(fname)
end

@testset "Basic" begin
    learn_open_hdf5()
    learn_create_group()
    learn_create_dataset()
    learn_dataset()
    learn_attribute()

    learn_writing_a_group_or_dataset()
end

nothing
