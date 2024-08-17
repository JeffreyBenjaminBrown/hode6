viewfile_path = "/mnt/write/view.hode"

def overwrite_viewfile (s : str):
  with open ( viewfile_path, "w") as viewfile:
    viewfile . write ( s )

def initialize ():
  overwrite_viewfile ("""Welcome to Hode.
This introduction might someday explain what's going on.""")
