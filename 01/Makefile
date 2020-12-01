part_1: ats

part_2: awk

ats:
	patscc -D_GNU_SOURCE -DATS_MEMALLOC_LIBC -o a a.dats
	./a < input.txt

awk:
	gawk a.awk < input.txt
