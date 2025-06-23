
// MODULE HEADING

#define SIZE 1028

extern unsigned long long m_stack[], m_index;
extern void _close();

#define LIMA(a) if (m_index + (a) >= SIZE) _close()
#define PUSH(v) (m_stack[m_index++] = (v))

#define LIMB(a) if (m_index < (a)) _close()
#define PULL(v) (m_stack[--m_index])


// MODULE DECLARATIONS

// integer
void integer_Sum();
void integer_Dup();


// MODULE IMPLEMENTATIONS (LOW)

void integer_Sum()
{
    unsigned long long a;
    unsigned long long b;

    LIMB(2);
    a = PULL();
    b = PULL();

    LIMA(1);
    PUSH(a + b);
}

void integer_Dup()
{
    unsigned long long a;

    LIMB(1);
    a = PULL();

    LIMA(2);
    PUSH(a);
    PUSH(a);
}
