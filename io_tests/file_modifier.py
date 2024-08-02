# TODO: Rather than a bunch of globals,
# it would be cleaner to use a singleton HodeView class.
view_path = "/mnt/write/view.hode"
view_state = ""


def write_view ():
  with open ( view_path, "w") as view:
    view . write ( view_state )

def append_to_view (content : str):
  """This must be faster than writing the whole file."""
  global view_state
  view_state = view_state + content
  with open ( view_path, "a") as view:
    view . write ( content )

def initialize_view ():
  global view_state
  view_state = "Welcome to Hode!\n"
  write_view ()
