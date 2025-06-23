
// GLOBAL STACK ORIENTATION
unsigned long long m_stack[1028], m_index = 0;
void _close();


// EXECUTION SUBJECT
void myModulio_MainFunctionio();


// EXECUTION
void _close() {
    __asm__(
        "mov $0, %%rdi\n\t"
        "mov $60, %%rax\n\t"
        "syscall"
        :
        :
        : "%rdi", "%rax"
    );
}

void _start()
{
    myModulio_MainFunctionio();
    _close();
}
