import magma
import warnings
from gemstone.generator.const import Const
from gemstone.generator.generator import Generator
from hwtypes import BitVector
from collections import defaultdict
from gemstone.generator.port_reference import PortReferenceBase

# Use kwargs left, right, top, bottom to match other blocks
# with correct side of primary block
# Allowed kwargs : left, right, top, bottom

def reorder_pins(pin_dict, side_1, side_2):
    s1_pins = pin_dict[side_1]
    s2_pins = pin_dict[side_2]
    s2_pin_names = list(map(lambda pin_obj: pin_obj.qualified_name(), s2_pins))
    for i, pin in enumerate(s1_pins):
        if pin._connections[0].qualified_name() in s2_pin_names:
            curr_idx = s2_pin_names.index(pin._connections[0].qualified_name())
            s2_pin_names.insert(i, s2_pin_names.pop(curr_idx))
            s2_pins.insert(i, s2_pins.pop(curr_idx))
        else:
            warnings.warn(f"{side_1} side pin {pin.qualified_name()} not found \
                            in {side_2} side connections. Abutment may not \
                            be possible")
    return pin_dict
            

def assign_abutted_pins(primary: Generator, **kwargs):
    # Make sure kwargs are valid
    for side in kwargs.keys():
        if side not in ['left', 'right', 'top', 'bottom']:
            raise Exception('kwarg key must be left, right, top, or bottom')

    pin_objs = {'left': [], 'right': [], 'top': [], 'bottom': [], 'other': []}   

    for port in primary.ports.values():
        # Remove any internal connections
        conns = []
        for conn in port._connections:
            if conn.owner() in kwargs.values():
                conns.append(conn)
        if len(conns) == 1:
            for side, inst in kwargs.items():
                if conns[0].owner() == inst:
                    pin_objs[side].append(port)
                    break
        elif len(conns) == 0:
            pin_objs['other'].append(port)
        else:
            raise Exception('cannot abut port with fanout connection')

    # Make L/R, T/B ordering consistent
    pin_objs = reorder_pins(pin_objs, 'left', 'right') 
    pin_objs = reorder_pins(pin_objs, 'top', 'bottom') 

    # Spit out the pin names for each side 
    pin_names = {'left': [], 'right': [], 'top': [], 'bottom': [], 'other': []}
    for side, pin_list in pin_objs.items():
        for pin in pin_list:
            pin_names[side].append(pin.qualified_name())

    print(pin_names)
