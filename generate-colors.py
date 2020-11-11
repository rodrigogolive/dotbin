#!/usr/bin/env python3
import re
import sys
from pathlib import Path
from subprocess import run


class Generator:
    color_table = {}

    def __init__(self):
        self.read_colors()

    def read_colors(self):
        command = ["xrdb", "-query"]
        result = run(command, capture_output=True, text=True)

        regex = r"(?P<name>color[0-9]+):\s*#(?P<color>[a-f,0-9]{6})"
        r = re.compile(regex)

        match = r.finditer(result.stdout)
        for m in match:
            self.color_table[m.group("name")] = m.group("color")

    def print_colors(self):
        for color in self.color_table:
            line = "{} #{}".format(f"{color}:".ljust(8), self.color_table[color])

            print(line)

    def generate(self, template, output):
        def repl(match):
            if match:
                return self.color_table.get(match["tag"], "00ffff")

        outfile = open(output, "w")

        regex = r"{{(?P<tag>color[0-9]*)}}"
        r = re.compile(regex)

        with open(template) as template_file:
            for line in template_file:
                outline = r.sub(repl, line)
                outfile.write(outline)

        outfile.close()


if __name__ == "__main__":
    # XXX use ArgumentParser (and add option to just print the color table)
    if len(sys.argv) < 3:
        print("Usage: {} <template> <output>".format(sys.argv[0]))
        sys.exit()

    template = sys.argv[1]
    output = sys.argv[2]

    if not Path(template).is_file():
        print(f"Template file {template} doesn't exist!")
        sys.exit(-1)

    if Path(output).is_file():
        # XXX ask user if should ovewrite or cancel/ add flag to define
        # behaviour
        print(f"WARNING: Output file {output} exists, overwriting")

    generator = Generator()
    generator.generate(template, output)
