%include 'inc/func.inc'

	fn_function sys/mail_deinit, no_debug_enter

		;deinit mail message heap
		static_bind sys_mail, statics, r0
		static_jmp sys_heap, deinit, {[r0 + ml_statics_heap]}

	fn_function_end
