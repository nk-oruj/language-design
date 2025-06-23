
// MODULE HEADING

#define SIZE 1028

extern unsigned long long m_stack[], m_index;
extern void _close();

#define LIMA(a) if (m_index + (a) >= SIZE) _close()
#define PUSH(v) (m_stack[m_index++] = (v))

#define LIMB(a) if (m_index < (a)) _close()
#define PULL(v) (m_stack[--m_index])


// MODULE DECLARATIONS

// stream
void stream_Input();
void stream_Print();


// MODULE IMPLEMENTATIONS (LOW)

void stream_Input()
{
    char buf[32];
    long size;

    // syscall: read(0, buf, sizeof(buf))
    __asm__ volatile (
        "mov $0, %%rax\n\t"
        "mov $0, %%rdi\n\t"
        "mov %1, %%rsi\n\t"
        "mov %2, %%rdx\n\t"
        "syscall\n\t"
        "mov %%rax, %0"
        : "=r"(size)
        : "r"(buf), "r"(sizeof(buf))
        : "%rax", "%rdi", "%rsi", "%rdx"
    );

    unsigned long long result = 0;
    int i = 0;

    // ignore controls
    while (i < size && (buf[i] >= 0x01 && buf[i] <= 0x20))
    {
        i++;
    }

    // parse digits
    while (i < size && (buf[i] >= 0x30 && buf[i] <= 0x39))
    {
        result = result * 10 + (buf[i] - 0x30);
        i++;
    }

    LIMA(2);
    PUSH(result);
}

void stream_Print()
{
    char buf[32];
    long i = 31;
    unsigned long long n;

    LIMB(1);
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
