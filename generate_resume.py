import argparse
import jinja2
import os
import yaml

from debug.debug import dprint

class OutputFormat(object):
    def __init__(self, arg_name, template_extension, output_suffix, output_extension):
        self.arg_name = arg_name
        self.template_extension = template_extension
        self.output_suffix = output_suffix
        self.output_extension = output_extension


# maps output format to template file extension
_OUTPUT_FORMATS = {
    'pdf': OutputFormat('pdf', 'tex', None, 'pdf'),
    'formatted_text': OutputFormat('formatted_text', 'txt', '_formatted', 'txt'),
    'plain_text': OutputFormat('plain_text', 'txt', None, 'txt')
}

def load_templates(template_dir=os.path.join(os.getcwd(), 'template')):
    loader = jinja2.FileSystemLoader(template_dir)
    environment = jinja2.environment.Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)
    return environment

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
            description="Generates multiple resume outputs from a singular YAML-formatted source")
    parser.add_argument('--formats', '-f', help="output formats to generate.  There must be a template of the same name in template/", nargs='+', choices=_OUTPUT_FORMATS.keys(), default=_OUTPUT_FORMATS.keys())
    parser.add_argument('--destination', '-d', help="directory used to write generated documents", default="output")
    parser.add_argument('--output-name', '-o', dest='output_name', help="base name used for generated files in 'destination'", default="document")
    parser.add_argument('source_file', help="yaml-formatted containing the desired resume sections")
    args = parser.parse_args()

    environment = load_templates()
    dprint("found templates {}".format(environment.list_templates()))

    with open(args.source_file, 'r') as source_file:
        # create an output directory if one doesn't yet exist
        try:
            os.mkdir(args.destination)
        except (OSError):
            pass

        raw = yaml.load(source_file)

        # generate all requested formats
        for doc_format in args.formats:
            output_ext = _OUTPUT_FORMATS[doc_format].output_extension
            template_ext = _OUTPUT_FORMATS[doc_format].template_extension
            suffix = _OUTPUT_FORMATS[doc_format].output_suffix
            if suffix is None:
                suffix = ""

            output_file = os.path.join(args.destination, args.output_name + suffix + os.path.extsep + output_ext)
            with open(output_file, 'w') as output:
                try:
                    template_name = os.path.join(doc_format, 'base' + os.path.extsep + template_ext)
                    template = environment.get_template(template_name)
                    output.write(template.render(root=raw))
                except (jinja2.TemplateNotFound):
                    print("Unable to find base template {}".format(template_name))
