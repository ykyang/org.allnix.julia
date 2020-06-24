# Dynamic
BoxPropertyEdit "ROCK_REGION" [
    I1    I2    J1    J2    K1    K2    Grid    Property    Expression
    # all
    #1    9    1    80    1    5    "CoarseGrid"    "SAT_TAB"    "1"
    {{#rock_region}}
    {{:I1}}     {{:I2}}     {{:J1}}     {{:J2}}     {{:K1}}     {{:K2}}     {{:Grid}}     {{:Property}}    {{:Expression}}
    {{/rock_region}}
]
