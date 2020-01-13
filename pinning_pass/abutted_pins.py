import magma
from gemstone.generator.const import Const
from gemstone.generator.generator import Generator
from hwtypes import BitVector
from collections import defaultdict
from gemstone.generator.port_reference import PortReferenceBase

# Use kwargs left, right, top, bottom to match other blocks
# with correct side of primary block
# Allowed kwargs : left, right, top, bottom 
def assign_abutted_pins(primary: Generator, **kwargs):
    # Make sure kwargs are valid
    for side in kwargs.keys():
        if side not in ['left', 'right', 'top', 'bottom']:
            raise Exception('kwarg key must be left, right, top, or bottom')

    pinning = {'left': [], 'right': [], 'top': [], 'bottom': [], 'other': []}   
 
    for port in primary.ports():
        if port.owner() in kwargs.values():
            for side, inst in kwargs.items():
                if inst == port.owner()
                    pinning[side].append(port)
        else:
            pinning['other'] << port

