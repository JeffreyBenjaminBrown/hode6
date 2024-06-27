TypeDB is a typed knowledge graph. I like typed things; they're safer, which means I waste less time trying to understand dumb things I shouldn't have done. But more importantly, TypeDB offers two things that I consider extremely important: (1) relationships of arbitrary arity (not just two members but one (useful for relationships like "maybe" or "not") or three or whatever) and (2) arbitrary nesting -- relationships can themselves be members of relationships.

TypeDB can run in a Docker container. Emacs can run bash in one buffer, and send text input to that bash buffer from another buffer. So running TypeDB in Bash in Emacs makes it easy to send commands to TypeDB.

Emacs Lisp is esoteric, and Python is extremely popular. Therefore I'd like to put most of the logic in Python, and make the Emacs Lisp layer as thin as possible.

There's a TypeDB API for Python. I'm imagining running a Python REPL in the same Docker container that's running TypeDB as a background service. Sending text from one buffer to be evaluated in another is easy in Emacs -- I already do that when I play with TidalCycles. And Emacs has some ability to recognize when files have been updated and redraw a buffer accordingly.

A minimal viable product, therefore, would be a buffer in Emacs that displays a file that Python is constantly overwriting, and an interface that uses the minibuffer to let users tell Python how to change the data and the view.

This might not be the most elegant way to wire those things together, but I suspect it's the easiest, and it won't incur any performance penalty, because the traffic between those units will be very little bandwidth. The major downside regards installation -- having a lot of parts makes it harder for users to install things. But I don't think that concern should get much weight initially.

(TypeDB does not need Docker to run, but my memory from a year or three ago is that that's the easiest way to use it.)

Initially, putting all the parts together is more important than making any one of them amazing. The first data model can be as simple as the org-roam model: There are notes, and some of them link to "children". That model can be extended later. Similarly, the UI can be extended later -- use some key command when the cursor is on a note to show its children, or its parents, etc.

Eventually I'd like to incorporate a language for data entry and querying, along the lines of Hash:

https://github.com/JeffreyBenjaminBrown/hode/blob/master/docs/hash/the-hash-language.md
