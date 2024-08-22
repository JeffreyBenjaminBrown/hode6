import random
import string


def random_uid () -> str:
  """Draws from a universe of 69**16 (more than 2e29) things. Since a billion is 1e9, if you drew 10 billion of these at random, the probability that any two of them were equal would be less than one in a billion. That's because, for big numbers, a good approximation for the "birthday problem", giving the probability of a math in K random draws from a size-N universe, is 1 - exp(- K^2 / N)"""
  return '' . join ( random.choice ( string.ascii_letters +
                                     string.digits +
                                     "_-,=+:~" )
                     for _ in range (16) )
