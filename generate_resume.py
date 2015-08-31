import argparse
import jinja2
import os
import yaml
import bnrg.filters
from distutils import dir_util

import logging, sys

class OutputFormat(object):
    def __init__(self, arg_name, template_extension, output_suffix):
        self.arg_name = arg_name
        self.template_extension = template_extension
        self.output_suffix = output_suffix

# maps output format to template file extension
_OUTPUT_FORMATS = {
    'latex': OutputFormat('latex', 'tex', None),
    'formatted_text': OutputFormat('formatted_text', 'txt', '_formatted'),
    'plain_text': OutputFormat('plain_text', 'txt', None)
}

def load_templates(template_dir=os.path.join(os.getcwd(), 'template')):
    loader = jinja2.FileSystemLoader(template_dir)
    environment = jinja2.environment.Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)
    _register_filters(environment)
    return environment

def _register_filters(environment):
    environment.filters['right'] = bnrg.filters.do_right


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
            description="Generates multiple resume outputs from a singular YAML-formatted source")
    parser.add_argument('--formats', '-f', help="output formats to generate.  There must be a template of the same name in template/", nargs='+', choices=_OUTPUT_FORMATS.keys(), default=_OUTPUT_FORMATS.keys())
    parser.add_argument('--destination', '-d', help="directory used to write generated documents", default="output")
    parser.add_argument('--output-name', '-o', dest='output_name', help="base name used for generated files in 'destination'", default="document")
    parser.add_argument('source_file', help="yaml-formatted containing the desired resume sections")
    parser.add_argument('--verbose', '-v', help="Enable verbose logging", action='store_true')
    args = parser.parse_args()

    if args.verbose:
        logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)


    with open(args.source_file, 'r') as source_file:

        # copy static-content into destination directory
        # use distutils' dir_util instead of shutil.copytree, because copytree requires the destination to not exist before calling.
        # removing the entire output directory every time just to use the convenient copytree() is confusing for users.
        dir_util.copy_tree('./static-content', args.destination, update=True)

        raw = yaml.load(source_file)

        # generate all requested formats
        for doc_format in args.formats:
            template_ext = _OUTPUT_FORMATS[doc_format].template_extension
            output_ext = template_ext # all existing templates generate files with the same file extension
            suffix = _OUTPUT_FORMATS[doc_format].output_suffix
            if suffix is None:
                suffix = ""

            output_file = os.path.join(args.destination, args.output_name + suffix + os.path.extsep + output_ext)
            with open(output_file, 'w') as output:
                try:
                    template_name = os.path.join(doc_format, 'base' + os.path.extsep + template_ext)
                    logging.debug("template name = {}".format(template_name))
                    logging.debug("template name in template list: {}".format(template_name in environment.list_templates()))
                    template = environment.get_template(template_name)
                    output.write(template.render(root=raw))
                except jinja2.TemplateNotFound as tnf:
                    print("Unable to find base template {}:\n{}".format(template_name, tnf))
