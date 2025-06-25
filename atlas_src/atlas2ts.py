from string import Template


field = ""
fields = {}
size = [0, 0]

template_string = ""

with open("sprites.atlas", 'r') as f:
    while line := f.readline():
        line = line.strip()
        if line.startswith("bounds:") and field != "":
            fields[field] = line[7:].replace(",", ", ")
        elif line.startswith("size:"):
            size = [int(item.strip()) for item in line[5:].split(',')]
        else:
            field = line

fields["_texture_width"] = size[0]
fields["_texture_height"] = size[1]

with open("atlas.template", 'r') as tm:
    template_string = tm.read()

template = Template(template_string)
result = template.substitute(fields)

with open("../src/atlas.ts", 'w') as out:
    out.write(result)
