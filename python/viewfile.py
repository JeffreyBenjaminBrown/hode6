# TODO: Rather than a bunch of globals,
# it would be cleaner to use a singleton HodeView class.
path = "/mnt/write/view.hode"
state = ""


def write ():
  with open ( path, "w") as viewfile:
    viewfile . write ( state )

def append (content : str):
  """This must be faster than writing the whole file."""
  global state
  state = state + content
  with open ( path, "a") as view:
    view . write ( content )

def initialize ():
  global state
  state = "Welcome to Hode!\n"
  write ()
