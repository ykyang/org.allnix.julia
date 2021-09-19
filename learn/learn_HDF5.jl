using HDF5
using Test

function learn_open_hdf5()
    fname = tempname(pwd())
    @test !isfile(fname)
    
    fid = h5open(fname, "cw")
    @test isfile(fname)

    close(fid)
    @test isfile(fname)

    rm(fname)
    @test !isfile(fname)

    # The "do" syntax
    h5open(fname, "cw") do fid
        @test isfile(fname)
    end
    rm(fname)
    @test !isfile(fname)
end

function learn_writing_a_group_or_dataset()
    # Test const data
    data = [13.0, 17.0, 19.0]

    ## Create aHDF5 file
    # Must close at the end
    # One can use the do syntax
    #   h5open(fname, "cw") do fid
    #   end
    fname = tempname(pwd())
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
    learn_writing_a_group_or_dataset()
end

nothing
