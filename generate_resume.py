import argparse
import jinja2
import os
import types
import yaml

from debug.debug import dprint

def load_templates(template_dir=os.path.join(os.getcwd(), 'template')):
    loader = jinja2.FileSystemLoader(template_dir)
    environment = jinja2.environment.Environment(loader=loader)
    return environment

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
            description="Generates multiple resume outputs from a singular YAML-formatted source")
    parser.add_argument('source_file', help="yaml-formatted containing the desired resume sections")
    args = parser.parse_args()

    environment = load_templates()
    dprint("found templates {}".format(environment.list_templates()))


    with open('resume.txt', 'w') as output:
        with open(args.source_file, 'r') as source_file:
            raw = yaml.load(source_file)
            for section, value in zip(raw.keys(), raw.values()):
                try:
                    # Wow this is gross.  refactor a _ton_
                    template = environment.get_template(os.path.join('plain_text',section+os.path.extsep+'txt'))
                    dprint("found template {}".format(template))

                    metatype = types.new_class(section)
                    dprint("created metatype {}".format(metatype))
                    metaobject = metatype()
                    metaobject.__dict__ = value
                    dprint("metaobject = {}".format(str(metaobject)))
                    dprint("metaobject = {}".format(metaobject.__dict__))

                    metaargs = dict()
                    metaargs[section] = metaobject
                    output.write(template.render(metaargs))
                except (jinja2.TemplateNotFound):
                    print("Source section '{}' found in source file, but no template exists".format(section))
