
#include "main.h"

void stream_Print()
{
    char buf[32];
    long i = 31;
    unsigned long long n;

    FLOR(1);
    n = PULL();

    buf[i--] = '\n';

    do {
        buf[i--] = '0' + (n % 10);
        n /= 10;
    } while (n);

    long len = 31 - i;

    __asm__(
        "mov $1, %%rax\n\t"
        "mov $1, %%rdi\n\t"
        "lea (%0), %%rsi\n\t"
        "mov %1, %%rdx\n\t"
        "syscall"
        :
        : "r"(&buf[i + 1]), "r"(len)
        : "%rax", "%rdi", "%rsi", "%rdx"
    );
}