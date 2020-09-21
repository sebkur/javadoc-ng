#!/bin/bash

for f in *.png; do
  echo $f;
  convert $f -gravity south -crop x722+0+0 +repage $f;
done
