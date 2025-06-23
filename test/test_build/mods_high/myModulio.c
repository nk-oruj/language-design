
// MODULE HEADING

#define SIZE 1028

extern unsigned long long m_stack[], m_index;
extern void _close();

#define CEIL(a) if (m_index + (a) >= SIZE) _close()
#define PUSH(v) (m_stack[m_index++] = (v))

#define FLOR(a) if (m_index < (a)) _close()
#define PULL(v) (m_stack[--m_index])


// MODULE DECLERATIONS

// integer
void integer_Sum();
void integer_Dup();

// stream
void stream_Input();
void stream_Print();

// myOtherModulio
void myOtherModulio_OtherFunctionio();

// myModulio
void myModulio_MainFunctionio();


// MODULE IMPLEMENTATIONS

void myModulio_MainFunctionio()
{
    CEIL(2);
    PUSH(634);
    PUSH(1245);
    integer_Sum();
    integer_Dup();
    stream_Print();
    myOtherModulio_OtherFunctionio();
}
