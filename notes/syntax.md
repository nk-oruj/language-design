```ebnf

module = module_head, module_body;

module_head = 'name';
module_body = { element, '::' };

element = element_head, element_body;

element_head = 'name';
element_body = { element };

element = term | call;

term = 'int';
call = 'name', ['.', 'name'];

```