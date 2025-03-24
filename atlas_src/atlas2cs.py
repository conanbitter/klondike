from string import Template


field = ""
fields = {}

template_string = ""

with open("sprites.atlas", 'r') as f:
    while line := f.readline():
        line = line.strip()
        if line.startswith("bounds:") and field != "":
            fields[field] = line[7:].replace(",", ", ")
        else:
            field = line

with open("Atlas.template", 'r') as tm:
    template_string = tm.read()

template = Template(template_string)
result = template.substitute(fields)

with open("../AtlasConstants.cs", 'w') as out:
    out.write(result)
