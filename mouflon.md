```ebnf

module := module_header module_body module_footer;

module_header := token_module token_name;
module_footer := token_finish token_name;

module_body := { module_element };
module_body_element := module_constance | module_structure | module_procedure;

module_structure := module_body_domain token_structure token_name module_structure_body;

module_structure_body := token_record { module_structure_body_element } token_finish;
module_structure_body_element := token_name token_as module_structure_body_element_type;


module_domain := token_extern | token_intern;

```