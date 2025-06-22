
unsigned long long m_stack[1028], m_index = 0;
void _close();

void myModulio_MainFunctionio();

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
