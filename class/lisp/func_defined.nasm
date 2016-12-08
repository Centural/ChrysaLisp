%include 'inc/func.ninc'
%include 'class/class_vector.ninc'
%include 'class/class_error.ninc'
%include 'class/class_lisp.ninc'

def_func class/lisp/func_defined
	;inputs
	;r0 = lisp object
	;r1 = args
	;outputs
	;r0 = lisp object
	;r1 = value

	ptr this, args, value
	ulong length

	push_scope
	retire {r0, r1}, {this, args}

	devirt_call vector, get_length, {args}, {length}
	vpif {length == 1}
		func_call vector, get_element, {args, 0}, {value}
		vpif {value->obj_vtable == @class/class_symbol}
			func_call lisp, env_find, {this, value}, {value, _}
			vpif {value}
				assign {this->lisp_sym_t}, {value}
			else
				assign {this->lisp_sym_nil}, {value}
			endif
			func_call ref, ref, {value}
		else
			func_call error, create, {"(def? var) not a symbol", args}, {value}
		endif
	else
		func_call error, create, {"(def? var) wrong number of args", args}, {value}
	endif

	expr {this, value}, {r0, r1}
	pop_scope
	return

def_func_end