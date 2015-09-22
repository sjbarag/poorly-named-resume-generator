from jinja2._compat import text_type
import re

def do_right(value, width=80):
    """Right-justifies the value in a field of a given width."""
    return text_type(value).rjust(width)

_LATEX_SUBS = (
    (re.compile(r'\\'), r'\\textbackslash'),
    (re.compile(r'([{}_#%&$])'), r'\\\1'),
    (re.compile(r'~'), r'\~{}'),
    (re.compile(r'\^'), r'\^{}'),
    (re.compile(r'"'), r"''"),
    (re.compile(r'\.\.\.+'), r'\\ldots'),
    (re.compile(r'&'), r'&')
)

def escape_tex(value):
    """
    Escapes TeX characters to avoid breaking {La,Lua,Xe}Tex compilers.

    Kang'd (with permission!) from http://flask.pocoo.org/snippets/55/
    """
    newval = value
    for pattern, replacement in _LATEX_SUBS:
        newval = pattern.sub(replacement, newval)
    return newval

