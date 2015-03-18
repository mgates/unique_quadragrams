# Unique Quadragrams

## Purpose
`unique_quadragrams` is a small program to tell you what unique quadragrams are in a list of words.

You can run it without arguments to get usage information:
````
% bin/unique_quadragrams
    There weren't enough arguments.
usage: unique_quadragrams dictionaryfile quadragramsfile wordsfile
  use - for dictionaryfile to read from STDIN
  use - for for the other to write to STDOUT
    if you use - for both output files, you'll have to split it up yourself
options:
  -f overwrite files if they exist
````

## Output

Given, for instance, the input

````
arrows
carrots
give
me
````
you'll get two output files, the first, 

````
rrow                                                                                                                                                                                                                                                               [5/2429]
rows
carr
rrot
rots
give
````
will have the unique quadragrams, and the second

````
arrows
arrows
carrots
carrots
carrots
give
````
will have the words they are in in the same order.

## Testing

`unique_quadragrams` has a test suite. You can run it with `bundle exec rspec`.

## Versions

`unique_quadragrams` runs on, at least, MRI 1.9.3, 2.0.0, 2.1.0 and 2.2.0.

## Performance

It should run in roughly linear time (depending mostly on the performance of Hash). You can give yourself a small bit of reassurance that this is true with `bundle exec rspec --tag benchmark`, if you have a large dictionary at `/usr/share/dict/words` (at least OS X does). This will pass if the CPU time it takes to do half the list is close to half the time it takes to do the whole list (and likewise with one quarter of it). This is, of course, a very rough test, and shouldn't be counted on too much. 

It should run with linear memory too, but there's no benchmark for that.

As a reference, with Ruby 2.1.0, on a 15" Macbook 2.3 GHz Intel Core i7, reading from the system dictionary (235,886 words), and writing to /dev/null, finding the unique quadragrams takes just under 8 seconds.

## Assumptions

It is assumed that you:
  * Don't care about the order, as long as the output files match (although on 1.9.3 and above, it will be in dictionary order).
  * Don't care about the case. Quadragrams are found unique case-insensitively.
  * Only want quadragrams that are letters. `[[:alpha:]]` is used, so this should include most unicode letters, but this hasn't been tested extensively.

## Next Steps

If I had all the time in the world, here are some things I'd do:
  * Separate the IO writing from the finding of quadragrams.
  * Take some of the tests that run the executable, and have them test the Application class, mostly for speed.
  * Rename the project to "unique_ngrams", and take an optional argument for n. Maybe allow case sensitivity, etc too.
  * Format the output nicely if both output files are STDOUT.
  * Gemify everything.
  * Have some more robust benchmarking.
  * Check the user's email.
