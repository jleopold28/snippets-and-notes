import ruamel.yaml as yaml
from ctdt import CTDTOptimizer

# gather weights as parameter dict from input file
WEIGHTS = yaml.safe_load(open('params.yaml').read())

# construct class object with parameter dict from input file
OPT = CTDTOptimizer(WEIGHTS)

# display for each position
for position in WEIGHTS.keys():
    OPT.display_position_ranked(position=position)
