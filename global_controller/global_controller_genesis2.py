
import dataclasses
import magma
from gemstone.common.genesis_wrapper import GenesisWrapper
from gemstone.common.generator_interface import GeneratorInterface


@dataclasses.dataclass(eq=True, frozen=True)
class GlobalControllerParams:
    cfg_data_width: int = 32
    cfg_addr_width: int = 32
    cfg_op_width: int = 5
    axi_addr_width: int = 13
    axi_data_width: int = 32
    block_axi_addr_width: int = 12
    num_glb_tiles: int = 16
    glb_addr_width: int = 22


def gen_wrapper(params: GlobalControllerParams = None):
    type_map = {
        "clk_in": magma.In(magma.Clock),
        "clk_out": magma.Out(magma.Clock),
        "tck": magma.In(magma.Clock),
        "reset_in": magma.In(magma.AsyncReset),
        "reset_out": magma.Out(magma.AsyncReset),
        "trst_n": magma.In(magma.AsyncReset),
    }
    interface = GeneratorInterface()
    if params is not None:
        genesis_params = dataclasses.asdict(params)
        for k, v in genesis_params.items():
            interface = interface.register(k, int, v)

    gc_wrapper = GenesisWrapper(interface,
                                "global_controller",
                                ["global_controller/design/genesis/global_controller.svp",
                                 "global_controller/design/genesis/jtag.svp",
                                 "global_controller/design/genesis/glc_axi_ctrl.svp",
                                 "global_controller/design/genesis/glc_axi_addrmap.svp",
                                 "global_controller/design/genesis/glc_jtag_ctrl.svp",
                                 "global_controller/design/genesis/tap.svp",
                                 "global_controller/design/genesis/flop.svp",
                                 "global_controller/design/genesis/cfg_and_dbg.svp"],
                                system_verilog=True, type_map=type_map)
    return gc_wrapper
