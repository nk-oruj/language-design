
#include "core/scanner.h"

uint_1 scanner_next_symbol(scanner_symbol *symbol)
{
    uint_1 *ptr = symbol->ptr_b;

    // ignore controls
    while (*ptr >= 0x01 && *ptr <= 0x20) ptr++;

    // core character switch
    symbol->ptr_a = ptr;

    switch (*ptr)
    {
        // end-of-file case
        case '\0':
            symbol->id = ss_eof;
            break;

        // seperators
        case ':':
            

        // invalid character case
        default:
            symbol->id = ss_invalid;
            ptr++;
            break;
    }

    symbol->ptr_b = ptr;

    return 0;
}