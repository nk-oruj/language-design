
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
// stream
void stream_Input();
void stream_Print();
// myOtherModulio
void myOtherModulio_OtherFunctionio();

// MODULE IMPLEMENTATIONS

void myOtherModulio_OtherFunctionio()
{
    stream_Input();
    integer_Sum();
    stream_Print();
}
