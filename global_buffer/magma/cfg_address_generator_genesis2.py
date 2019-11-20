import magma
from gemstone.common.genesis_wrapper import GenesisWrapper
from gemstone.common.generator_interface import GeneratorInterface

"""
Defines the global buffer's i/o address generator using genesis2.

Example usage:
    >>> cfg_addr_gen = cfg_address_generator.generator()()

"""
interface = GeneratorInterface()

type_map = {
    "clk": magma.In(magma.Clock),
    "reset": magma.In(magma.AsyncReset),
}

cfg_addr_gen_wrapper = GenesisWrapper(
    interface, "cfg_address_generator", [
        "global_buffer/genesis/cfg_address_generator.svp",
    ], system_verilog=True, type_map=type_map)

if __name__ == "__main__":
    """
    This program generates the verilog for the global buffer and parses
    it into a Magma circuit. The circuit declaration is printed at the
    end of the program.
    """
    # These functions are unit tested directly, so no need to cover them
    cfg_addr_gen_wrapper.main()  # pragma: no cover