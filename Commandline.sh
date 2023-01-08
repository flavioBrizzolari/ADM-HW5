#!/bin/bash

# 1. What is the most popular pair of heroes (often appearing together in the comics)?

echo
echo "the most popular pair of heroes:" `awk -F'\t' '{print $1}' hero-network.csv | sort |uniq -c | sort -r |head -2`

# this is the easy way because we would not use both columns but combine them using tab separator instead of comma separator
# we use head -2 because the first grouping of most populair pair is "PATRIOT/JEFF MACE","PATRIOT/JEFF MACE" so we print the first
# two couples so that we have a real pair made out of two superheroes.

# 2. Number of comics per hero.
# this one is actually pretty simple because in "edges" we have two columns in the first one the heroes, and the second one the
# comics they appeared in so in fact we can just count the occurencies in the first column:

echo
echo " the number of comics per hero:" `awk -F',' '{print $1}' edges.csv | sort |uniq -c | sort -r | head -10`

# We used 'head -10' to display the first ten heroes for most comics appearances, but if we wanted to display them all
# we could just remove the '| head -10' command

# 3. The average number of heroes in comics.
# the idea is to pick all comics present in the network and count how many they are, then check and count how many heroes appears in each comic and finally compute the average number of heroes for each comic in all network.

# create a new file with one column containing the names of all the comics(column 2 of the 'edges.csv' file)
awk -F, '{print $2}' edges.csv > comics.txt

# sort the comics and remove duplicates('-u flag') in such a way that we can calculate the total number of the comics presents
sort -u comics.txt > sorted_comics.txt

# count the number of unique comics(it will be the denominator to compute average)
num_comics=$(awk 'END {print NR}' sorted_comics.txt)
# the “END” keyword will tell the system that read the input and finally do the command, it only needs to count the number of records of the text file, "print NR" the total number

# create a new file with one column containing the number of heroes in each comic
awk -F, '{count[$2]++} END {for (comic in count) {print count[comic]}}' edges.csv > comic_counts.txt
# pick total number of heroes in each comic cycling in the second column of 'edges.csv' file counting how many heroes appears in it 
# (print count[comic]) is the output in comic_counts.txt for each comic after we have count the heroes in it (count[$2]++)

# sum the number of heroes in all the comics
total_heroes=$(awk '{sum += $1} END {print sum}' comic_counts.txt)

# divide the total number of heroes by the number of comics to get the average
average=$(awk "BEGIN {printf \"%.2f\", $total_heroes/$num_comics}")

# print the result
echo
echo "Average number of heroes per comic: $average"

# remove the temporary files
rm comics.txt sorted_comics.txt comic_counts.txt

