import argparse

def parse_memcore(filename):
    f = open(filename, 'r')

    # Read past header
    # Area report is 20, power report is 21
    header = 20
    for i in range(0, header):
        f.readline()

    results = {}

    line = f.readline()
    while line:
        split = line.split()
        if len(split) > 4:
            field = split[0].strip()
            total = float(split[-1].strip())/10e9

            # UNIFIED/DOUBLE BUFFER CONTROLLER
            part_of_db = False
            if "range_" in field:
                part_of_db = True
            elif "stride_" in field:
                part_of_db = True
            elif "iter_cnt" in field:
                part_of_db = True
            elif "depth" in field:
                part_of_db = True
            elif "starting_addr" in field:
                part_of_db = True
            elif "stencil_width" in field:
                # currently not considering this part of DB
                part_of_db = False
            elif "switch_db_reg_sel" in field:
                part_of_db = True
            elif "enable_chain" in field:
                part_of_db = True
            elif "arbitrary_addr" in field:
                part_of_db = True
            elif field.startswith("switch_db"):
                # switch_db_reg_sel, switch_db_reg_value, switch_db_sel
                part_of_db = True
            elif field.startswith("chain_wen_in"):
                # chain_wen_in_reg_value, chain_wen_in_reg_sel, chain_wen_in_sel
                part_of_db = True
            elif "rate_matched" in field:
                part_of_db = True
            elif "doublebuffer_control" in field:
                part_of_db = True

            if part_of_db:
                if "doublebuffer_control" in results.keys():
                    total += results["doublebuffer_control"]
                results["doublebuffer_control"] = total

            # SEPARATE INSTANCES
            if field == "Tile_MemCore":
                results[field] = total
            if field == "MemCore_inst0":
                results[field] = total
            if "mem_inst" in field:
                if "mem_inst" in results.keys():
                    total += results["mem_inst"]
                results["mem_inst"] = total
            if field == "fifo_control" or field == "circular_en":
                if "fifo_control" in results.keys():
                    total += results["fifo_control"]
                results["fifo_control"] = total
            if field == "linebuffer_control":
                results[field] = total
            if field == "sram_control":
                results[field] = total
            
            # INTERCONNECT
            part_of_interconnect = False
            if field == "SB_ID0_5TRACKS_B16_MemCore":
                part_of_interconnect = True
            elif field == "SB_ID0_5TRACKS_B1_MemCore":
                part_of_interconnect = True
            elif line.startswith("  CB_"):
                part_of_interconnect = True

            if part_of_interconnect:
                if "interconnect" in results.keys():
                    total += results["interconnect"]
                results["interconnect"] = total

        line = f.readline()

    other = results["Tile_MemCore"] - (results["doublebuffer_control"] + results["fifo_control"] + results["linebuffer_control"] + results["sram_control"] + results["mem_inst"] + results["interconnect"])
    print("TOTAL,%f" % results["Tile_MemCore"])
    print("DOUBLE BUFFER control,%f" % results["doublebuffer_control"])
    print("FIFO control,%f" % results["fifo_control"])
    print("LINEBUFFER control,%f" % results["linebuffer_control"])
    print("SRAM control,%f" % results["sram_control"])
    print("MEMORY,%f" % results["mem_inst"])
    print("INTERCONNECT,%f" % results["interconnect"])
    print("OTHER,%f" % other)
    print("OTHER2,%f" % (results["fifo_control"] + results["linebuffer_control"] + results["sram_control"] + other))

def parse_pe(filename):
    f = open(filename, 'r')

    # Read past header
    # Area report is 20, power report is 21
    header = 20
    for i in range(0, header):
        f.readline()

    results = {}

    line = f.readline()
    while line:
        split = line.split()
        if len(split) > 4:
            field = split[0].strip()
            total = float(split[-1].strip())/10e9

            if field == "Tile_PE":
                results[field] = total
            if field == "PE_comb_inst0":
                results["alu"] = total;
            if field == "SB_ID0_5TRACKS_B16_PE" or field == "SB_ID0_5TRACKS_B1_PE":
                if "SB" in results.keys():
                    total += results["SB"]
                results["SB"] = total
            if line.startswith("  CB_"):
                if "CB" in results.keys():
                    total += results["CB"]
                results["CB"] = total

        line = f.readline()

    other = results["Tile_PE"] - (results["alu"] + results["SB"] + results["CB"])
    print("TOTAL,%f" % results["Tile_PE"])
    print("ALU,%f" % results["alu"])
    print("CONNECTION BOX,%f" % results["CB"])
    print("SWITCH BOX,%f" % results["SB"])
    print("OTHER,%f" % other)
    print("%.3E,%.3E,%.3E,%.3E" % (results['alu'],results['CB'],results['SB'],other))

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=str, default="", help="input file")
    args = parser.parse_args()

    if args.input == "":
        print("please include file to parse")
        return

    if "Tile_MemCore" in args.input:
        parse_memcore(args.input)
    elif "Tile_PE" in args.input:
        parse_pe(args.input)
    else:
        parse_memcore(args.input)
        parse_pe(args.input)

if __name__ == '__main__':
    main()
