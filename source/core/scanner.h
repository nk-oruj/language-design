
#include "util/types.h"

enum
{
    ss_invalid,
    ss_eof,

    ss_name,
    ss_int,

    ss_delim, // ::
    ss_size
};

typedef struct
{
    uint_1 id;
    uint_1 *ptr_a;
    uint_1 *ptr_b;
}
scanner_symbol;

uint_1 scanner_next_symbol(scanner_symbol *symbol);
