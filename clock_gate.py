def main():
    g = open('garnet.v', 'r')
    g_cg = open('garnet.clock_gate', 'w')
    while True:
        line = g.readline()
        if not line:
            break

        if line.startswith('module Register_has'):
            module = line[7:-3]
            fields = module.split('_')

            areset = True
            n = 1
            for i,f in enumerate(fields):
                if f == 'reset':
                    if fields[i-1] == 'async':
                        areset = fields[i+1]
                if f == 'n':
                    n = int(fields[i+1])
            g_cg.write(line)
            if areset == 'True':
                for i in range(0,6):
                    g_cg.write(g.readline());
                for i in range(0,21):
                    g.readline()
                g_cg.write(f"    reg [{n-1}:0] O_out;\n")
                g_cg.write(f'''    always @(posedge CLK, posedge ASYNCRESET) begin
        if (ASYNCRESET) begin
            O_out <= {n}'b0;
        end
        else if (CE) begin
            O_out <= I;
        end
    end
    assign O = O_out;
endmodule
''')
            else:
                for i in range(0,5):
                    g_cg.write(g.readline())
                for i in range(0,19):
                    g.readline()
                g_cg.write(f"   reg  [{n-1}:0] O_out;\n")
                g_cg.write(f'''    always @(posedge CLK) begin
        if (CE) begin
            O_out <= I;
        end
    end
    assign O = O_out;
endmodule
''')

        else:
            g_cg.write(line)

if __name__ == '__main__':
    main()
