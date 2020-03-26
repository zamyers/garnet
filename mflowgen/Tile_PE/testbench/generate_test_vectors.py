from random import random
import math
import numpy as np
import binascii
import struct

def main():
    f = open("test_vectors.txt", "w")
    raw = open("raw_input.csv", "r")

    fields = raw.readline().split(",")
    
    def get_hex (x, l):
      return str(binascii.hexlify(struct.pack('>I', x)))[10-l:10] # I is for unsigned int -- 32 bits

    while True:
        line = raw.readline().strip()
        if not line:
            break

        str_nums = line.split(",")
        nums = [int(thing) for thing in str_nums]

        to_write = ""

        i = 0;
        for num in nums:
            width = 16
            if 'config_config' in fields[i]:
                width = 32
            elif 'read_config_data_in' == fields[i]:
                width = 32

            hex_num = get_hex(num, int(width/4))
            if width == 32:
                hex_num = hex_num[0:4] + "_" + hex_num[4:8]
            to_write = "_" + hex_num + to_write

            i += 1
        f.write(to_write[1:])
        f.write("\n")
    
    f.close()
    raw.close()

if __name__ == '__main__':
    main()
