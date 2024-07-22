""" Probably want to open a repl, define the filename as a global variable, and define functions for manipulating it. Or, use that filename as an argument to those function each time."""

with open ( filename, "a") as the_file:
    the_file . write ( "appended text\n" )
