# USAGE

First download the Docker image:
```
docker pull jeffreybbrown/hode:latest
```
Then evaluate the code in `main.el` in this folder from Emacs
(by visiting that code in a buffer and running `eval-buffer`).
This will launch a buffer running a Docker container,
and within it, Python.
It will also launch a view of the document.

From the view of the document,
play around with the commands in `interface.el`
(which were defined when you evaluated `main.el`):
```
  (defun invis-demo-insert-node ...
  (defun invis-demo-increment-node-at-cursor ...
```

# PURPOSE

This demonstrates how to use hidden characters
to communicate between Emacs and Python.
The document model, in Python, is a list of (ID, int) pairs.
In Emacs one can use the following two interactive functions:
```
  (defun invis-demo-insert-node ...
  (defun invis-demo-increment-node-at-cursor ...
```
to manipulate the document. The first adds a new line
(that is, a new pair) to the model.
The second increments the integer in that pair.
THe document appears in Emacs only as a list of integers --
the IDs are hidden.

In the second function, `invis-demo-increment-node-at-cursor`,
Emcas tells Python how to change the model
by referring to the ID of the relevant pair,
which is encoded as hidden text
at the beginning of the line representing that pair.
