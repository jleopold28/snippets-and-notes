import ruamel.yaml as yaml
from ctdt import CTDTOptimizer


# construct class object with parameter dict from input file
OPT = CTDTOptimizer(yaml.safe_load(open('params.yaml').read()))

# display for each position
OPT.display_position_ranked(position='FW')
