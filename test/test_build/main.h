
#define SIZE 1028
extern unsigned long long m_stack[], m_index;
extern void _close();

#define CEIL(a) if (m_index + (a) >= SIZE) _close()
#define PUSH(v) (m_stack[m_index++] = (v))

#define FLOR(a) if (m_index < (a)) _close()
#define PULL()  (m_stack[--m_index])
