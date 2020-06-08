import VegaDatasets
import DataFrames

DF = DataFrames

data = VegaDatasets.dataset("cars")
C = DF.DataFrame(data)
DF.dropmissing!(C)
M = Matrix(C[:,2:7])
@show DF.names(C)

car_origin = C[:,"Origin"]
carmap = MLBase.labelmap(car_origin)
uniqueids = MLBase.labelencode(carmap, car_origin)
