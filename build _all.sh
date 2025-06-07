cd src/ &&
find . -type d -exec mkdir -p -- output/{} \

find . -name '*.tex' | while read -r texfile; do
  make4ht -u -e build.lua "$texfile"
done
