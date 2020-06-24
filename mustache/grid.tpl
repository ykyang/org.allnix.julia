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
    {{! another way to display array}}
    {{! . means current element, ^ means invert}}
    DeltaZ = [{{#dzv}}{{.}}{{^.[end]}} {{/.[end]}}{{/dzv}}]
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
