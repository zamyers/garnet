import os
from gemstone.common.run_verilog_sim import verilog_sim_available
import pytest


@pytest.mark.skipif(not verilog_sim_available(),
                    reason="verilog simulator not available")
def test_global_buffer_verilog_sim():
    result = os.system("make -C global_buffer run")
    assert result == 0
