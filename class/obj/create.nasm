%include 'inc/func.inc'
%include 'class/class_obj.inc'

def_func class/obj/create
	;outputs
	;r0 = 0 if error, else object

	;always error
	vp_xor r0, r0
	vp_ret

def_func_end
