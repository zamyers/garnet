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

    pin_objs = {'left': [], 'right': [], 'top': [], 'bottom': [], 'other': []}   
 
    for port in primary.ports:
        if port.owner() in kwargs.values():
            for side, inst in kwargs.items():
                if inst == port.owner():
                    pinning[side].append(port)
        else:
            pinning['other'] << port

    
    # Make L/R, T/B ordering consistent

    # Spit out the pin names for each side 
    pin_names = {'left': [], 'right': [], 'top': [], 'bottom': [], 'other': []}
    for side, pin_list in pin_objs.items():
        for pin in pin_list:
            pin_names[side].append(pin.qualified_name())

    print(f"{pin_names[left]} \n {pin_names[right]} \n {pin_names[top]} \n {pin_names[bottom]}")
