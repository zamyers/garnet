import sys
import os
from tabulate import tabulate

def parse_fields(line):
    breakdown = line.split()
    field_map = {
                 'name': 0,
                 'module': 1,
                 'int_power': 2,
                 'switch_power': 3,
                 'leak_power': 4,
                 'total_power': 5,
                 'percentage': 6
                }

    if len(breakdown) < len(field_map):
        return {}

    fields = {}
    for i,(k,v) in enumerate(field_map.items()):
        fields[k] = breakdown[v]

    return fields

def process_line(line):
    level = (len(line) - len(line.lstrip())) / 2
    fields = parse_fields(line)
    if len(fields) == 0:
       return None, None 

    return level, fields

def peek_line(p):
    pos = p.tell()
    line = p.readline()
    p.seek(pos)
    return line

def main():
    p = open(sys.argv[1], 'r')

    while True:
        line = p.readline()
        if not line:
            break
        if line.startswith('----------'):
            break

    tile = p.readline().split()
    total_power = float(tile[-2])

    power_breakdown = {
                       'switch_box': 0.0,
                       'connection_box': 0.0,
                       'pe_core': 0.0,
                       'other': 0.0
                      }
    alu_breakdown = {'other': 0.0}
    alu_power = 0.0

    while True:
        line = p.readline()
        if not line:
            break

        level, fields = process_line(line)
        if level is None or fields is None:
            break

        # higher level module blocks 
        if level == 1:
            component_power = float(fields['total_power'])
            # switch box
            if 'SB' in fields['name']:
                power_breakdown['switch_box'] += component_power
            # connection box
            elif 'CB' in fields['name']:
                power_breakdown['connection_box'] += component_power
            # pe core
            elif '(PE_unq1)' == fields['module']:
                power_breakdown['pe_core'] += component_power
            # other things
            else:
                power_breakdown['other'] += component_power

        # ALU breakdown
        if '(alu)' == fields['module']:
            alu_power = float(fields['total_power'])
            next_line = peek_line(p)
            next_level, _ = process_line(next_line)
            if next_level is None:
                break
            while next_level > level:
                line = p.readline()
                next_level, fields = process_line(line)
                # if it is not directly below PE_comb then don't care about it
                if next_level > level + 1:
                    continue

                component_power = float(fields['total_power'])
                module_breakdown = fields['module'][1:-1].split('_')

                lib = module_breakdown[0] 
                op_libs = {'corebit', 'coreir', 'float'}
                # if it is not an operation, then it is other
                if lib not in op_libs:
                    alu_breakdown['other'] += component_power
                    continue

                op = module_breakdown[1]
                bit_width = module_breakdown[2]
                op_id = fields['module'][1:-1]
                if lib == 'coreir':
                    op_id = f"{lib}_{op}_{bit_width}"
                if lib == 'corebit':
                    op_id = f"{lib}_{op}"

                if op_id in alu_breakdown:
                    alu_breakdown[op_id] += component_power
                else:
                    alu_breakdown[op_id] = component_power

                next_line = peek_line(p)
                next_level, _ = process_line(next_line)
                if next_level is None:
                    break

    clk_period = float(os.getenv('clock_period')) * 10e-9

    # print power numbers
    power_percentage = {}
    for i,(k,v) in enumerate(power_breakdown.items()):
        power_percentage[k] = v / total_power * 100

    power_summary = open('outputs/power.summary', 'w')
    headers = ['Type', 'Energy (J)', 'Percentage']
    data = []
    for k,_ in sorted(power_breakdown.items(), key=lambda kv: (-kv[1], kv[0])):
        data.append([k, f"{power_breakdown[k]*clk_period:.3e}", f"{power_percentage[k]:.2f}"])
    power_summary.write(tabulate(data, headers=headers,tablefmt='plain'))
    power_summary.write(f'\n\nTotal: {total_power*clk_period:.3e} J')

    # print alu power numbers
    alu_percentage = {}
    for i,(k,v) in enumerate(alu_breakdown.items()):
        alu_percentage[k] = v / alu_power * 100

    alu_summary = open('outputs/alu.summary', 'w')
    headers = ['Type', 'Energy (J)', 'Percentage']
    data = []
    for k,_ in sorted(alu_breakdown.items(), key=lambda kv: (-kv[1], kv[0])):
        data.append([k, f"{alu_breakdown[k]*clk_period:.3e}", f"{alu_percentage[k]:.2f}"])
    alu_summary.write(tabulate(data, headers=headers,tablefmt='plain'))
    alu_summary.write(f'\n\nTotal: {alu_power*clk_period:.3e} J ({alu_power/total_power*100:.2f}% of total power)')

    p.close()
    power_summary.close()
    alu_summary.close()

if __name__ == '__main__':
    main()
