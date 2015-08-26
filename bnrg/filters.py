from jinja2._compat import text_type

def do_right(value, width=80):
    """Right-justifies the value in a field of a given width."""
    return text_type(value).rjust(width)
