import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=str, default="", help="input file")
    args = parser.parse_args()

    if args.input == "":
        print("please include file to parse")
        return

    f = open(args.input, 'r')

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
            total = float(split[-1].strip())

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
            if field == "fifo_control":
                results[field] = total
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

if __name__ == '__main__':
    main()
