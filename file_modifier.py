import sys

# Why these don't work in a (value if else) expression,
# I don't know.
if len (sys.argv) >= 2:
  filename = sys.argv[1] # Before this is listed the program name.
else: filename = input ()
