import argparse
import jinja2
import os
import yaml

from debug.debug import dprint

def load_templates(template_dir=os.path.join(os.getcwd(), 'template')):
    loader = jinja2.FileSystemLoader(template_dir)
    environment = jinja2.environment.Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)
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
            try:
                template_name = os.path.join('plain_text','base'+os.path.extsep+'txt')
                template = environment.get_template(template_name)
            except (jinja2.TemplateNotFound):
                print("Unable to find base template {}".format(template_name))

            output.write(template.render(root=raw))
