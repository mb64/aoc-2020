input.h: input.txt
	xxd -i $< | sed -e 's/_txt//' > $@

c: input.h t.c
	gcc t.c -o t
	./t

