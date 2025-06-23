
// MODULE HEADING

#define SIZE 1028

extern unsigned long long m_stack[], m_index;
extern void _close();

#define CEIL(a) if (m_index + (a) >= SIZE) _close()
#define PUSH(v) (m_stack[m_index++] = (v))

#define FLOR(a) if (m_index < (a)) _close()
#define PULL(v) (m_stack[--m_index])

// MODULE DECLARATIONS

// integer
void integer_Sum();
void integer_Dup();

// MODULE IMPLEMENTATIONS (LOW)

void integer_Sum()
{
    FLOR(2);
    PUSH(PULL() + PULL());
}

void integer_Dup()
{
    unsigned long long a;

    FLOR(1);
    a = PULL();
    CEIL(2);
    PUSH(a);
    PUSH(a);
}
