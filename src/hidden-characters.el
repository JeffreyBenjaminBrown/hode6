123
5678
0
123

HOW TO USE THIS PROGRAM:
Don't touch the above text.
Each digit in that text represents the last of its position --
for instance the 0 is at position 10.
Try evaluating each of the commands below, individually,
in various orders, futzing with the numbers.
These might be the only functions I need for Hode.

(put-text-property 6 8 'invisible 'hode-id)
(put-text-property 6 8 'invisible nil)
(next-single-property-change 7 'invisible)
(previous-single-property-change 7 'invisible)
