set search_path [list \
    /tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tphn16ffcllgv18e_110c/ \
    /tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn16ffcllbwp16p90_100a/ \
    /tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn16ffcllbwp16p90lvt_100a/ \
    /tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn16ffcllbwp16p90ulvt_100a/ \
    /tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn16ffcllbwp16p90pm_100a/ \
    /sim/thofstee/mc/
]

# Some old settings
set corner_pad ssgnp0p72v1p62v40c
set corner_mem ssgnp0p72vm40c
set corner ssgnp0p72vm40c

# Ankita's settings
set corner_pad ssgnp0p72v1p62v40c
set corner_mem ssgnp0p72vm40c
set corner tt0p75v85c

# New typical co?rner settings
set corner_pad tt0p8v1p8v85c
set corner_mem tt0p8v110c
set corner tt0p8v85c

set link_path [list \
    * \
    {*} \
    tphn16ffcllgv18e${corner_pad}.db \
    tcbn16ffcllbwp16p90${corner}.db \
    tcbn16ffcllbwp16p90lvt${corner}.db \
    tcbn16ffcllbwp16p90ulvt${corner}.db \
    tcbn16ffcllbwp16p90pm${corner}.db \
    ts1n16ffcllsblvtc2048x64m8sw_130a_${corner_mem}.db \
    ts1n16ffcllsblvtc512x16m8s_130a_${corner_mem}.db
]
