#include <stdio.h>

#if 1

#include "input.h"
#define WIDTH 31

#else

#include "test.h"
#define WIDTH 11

#endif

long count(int dx, int dy) {
    int x = 0, y = 0;
    long n = 0;
    for (; y < input_len / (WIDTH + 1); y += dy, x += dx) {
        x = x % WIDTH;
        n += input[y * (WIDTH + 1) + x] == '#';
    }
    printf("count(%d,%d) == %ld\n", dx,dy,n);
    printf("%d %d\n", x, y);
    return n;
}

int main() {
    long res = count(1,1) * count(3,1) * count(5,1) * count(7,1) * count(1,2);
    printf("%ld\n", res);
}
