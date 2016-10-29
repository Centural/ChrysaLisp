%include 'inc/func.inc'
%include 'class/class_obj.inc'

def_func class/obj/inst_of
	;inputs
	;r0 = object
	;r1 = vtable pointer of tested type
	;outputs
	;r0 = object
	;r1 = 0 if not, else vtable of object
	;trashes
	;r2

	vp_cpy r1, r2
	loop_flist_forward r0 + obj_vtable, r1, r1
	loop_until r1, ==, r2
	if r1, ==, r2
		vp_cpy [r0 + obj_vtable], r1
	endif
	vp_ret

def_func_end
