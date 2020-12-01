#!/bin/gawk -f
BEGIN {
    count = 0;
}
{ items[count++] = $0; }
END {
    for (i in items) {
        for (j in items) {
            for (k in items) {
                if (items[i] + items[j] + items[k] == 2020) {
                    print (items[i] * items[j] * items[k]);
                }
            }
        }
    }
}
