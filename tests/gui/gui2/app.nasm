%include 'inc/func.inc'
%include 'inc/mail.inc'
%include 'inc/gui.inc'
%include 'class/class_window.inc'
%include 'class/class_flow.inc'
%include 'class/class_button.inc'

;;;;;;;;;;;
; test code
;;;;;;;;;;;

	fn_function tests/gui/gui2/app

		def_structure	app
			def_long	app_last_event
			def_long	app_window
			def_long	app_window_panel
			def_long	app_panel
			def_long	app_button1
			def_long	app_button2
			def_long	app_button3
			def_long	app_button4
		def_structure_end

		;init app vars
		vp_sub app_size, r4

		;create my window
		static_call window, create
		fn_assert r0, !=, 0
		vp_cpy r0, [r4 + app_window]
		static_call window, get_panel
		vp_cpy r1, [r4 + app_window_panel]
		vp_lea [rel title], r1
		static_call window, set_title
		vp_lea [rel status], r1
		static_call window, set_status

		;add my panel
		static_call flow, create
		fn_assert r0, !=, 0
		vp_cpy r0, [r4 + app_panel]
		vp_cpy flow_flag_down | flow_flag_fillw, r1
		static_call flow, set_flow_flags
		vp_xor r1, r1
		static_call flow, set_color
		vp_cpy [r4 + app_window_panel], r1
		static_call flow, add

		;add launch buttons to my app panel
		static_call button, create
		fn_assert r0, !=, 0
		vp_cpy r0, [r4 + app_button1]
		vp_cpy 0xffffff00, r1
		static_call button, set_color
		vp_lea [rel child_task1], r1
		static_call button, set_text
		vp_cpy [r4 + app_panel], r1
		static_call button, add

		static_call button, create
		fn_assert r0, !=, 0
		vp_cpy r0, [r4 + app_button2]
		vp_cpy 0xffffff00, r1
		static_call button, set_color
		vp_lea [rel child_task2], r1
		static_call button, set_text
		vp_cpy [r4 + app_panel], r1
		static_call button, add

		static_call button, create
		fn_assert r0, !=, 0
		vp_cpy r0, [r4 + app_button3]
		vp_cpy 0xffffff00, r1
		static_call button, set_color
		vp_lea [rel child_task3], r1
		static_call button, set_text
		vp_cpy [r4 + app_panel], r1
		static_call button, add

		static_call button, create
		fn_assert r0, !=, 0
		vp_cpy r0, [r4 + app_button4]
		vp_cpy 0xffffff00, r1
		static_call button, set_color
		vp_lea [rel child_task4], r1
		static_call button, set_text
		vp_cpy [r4 + app_panel], r1
		static_call button, add

		;set to pref size
		vp_cpy [r4 + app_window], r0
		method_call window, pref_size
		vp_cpy 256, r8
		vp_cpy 256, r9
		static_call window, change

		;set owner
		static_call sys_task, tcb
		vp_cpy r0, r1
		vp_cpy [r4 + app_window], r0
		static_call window, set_owner

		;add to screen and dirty
		static_call gui_gui, add
		static_call window, dirty_all

		;app event loop
		loop_start
			static_call sys_mail, mymail
			vp_cpy r0, [r4 + app_last_event]

			;dispatch event to view
			vp_cpy r0, r1
			vp_cpy [r1 + (ml_msg_data + ev_data_view)], r0
			method_call view, event

			;launch button ?
			vp_cpy [r4 + app_last_event], r0
			vp_cpy [r0 + (ml_msg_data + ev_data_view)], r1
			vp_cpy [r0 + (ml_msg_data + ev_data_buttons)], r2
			if r2, ==, 0
				switch
				case r1, ==, [r4 + app_button1]
					vp_lea [rel child_task1], r0
					static_call sys_task, open_child
					break
				case r1, ==, [r4 + app_button2]
					vp_lea [rel child_task2], r0
					static_call sys_task, open_child
					break
				case r1, ==, [r4 + app_button3]
					vp_lea [rel child_task3], r0
					static_call sys_task, open_child
					break
				case r1, ==, [r4 + app_button4]
					vp_lea [rel child_task4], r0
					static_call sys_task, open_child
					break
				default
				endswitch
			endif

			;free event message
			vp_cpy [r4 + app_last_event], r0
			static_call sys_mem, free
		loop_end

		;deref window
		vp_cpy [r4 + app_window], r0
		static_call window, deref

		vp_add app_size, r4
		vp_ret

	title:
		db 'Test Runner', 0
	status:
		db 'Status Text', 0
	child_task1:
		db 'tests/farm', 0
	child_task2:
		db 'tests/array', 0
	child_task3:
		db 'tests/pipe', 0
	child_task4:
		db 'tests/global', 0

	fn_function_end
