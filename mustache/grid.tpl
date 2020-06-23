MODEL_DEFINITION
{{#grid}}
StructuredInfo "CoarseGrid" {
    FirstCellId={{offset}}{{! unitoffset}}
    NumberCellsInI={{nx}}
    NumberCellsInJ={{ny}}
    NumberCellsInK={{nz}}
}

StraightPillarGrid "CoarseGrid" {
    Units = "ECLIPSE_FIELD"
    DeltaX = {{dxv}}
    DeltaY = {{dyv}}
    DeltaZ = {{dzv}}
    OriginX = 0
    OriginY = 0
    OriginZ = {{tops}}
}

GridReport {
  FileFormat="EGRID"
  On=True
}
{{/grid}}
END_INPUT
