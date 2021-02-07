/atom/movable/screen/screentip
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "TOP,LEFT"
	maptext_height = 480
	maptext_width = 480
	maptext = ""

	var/hovered_item

/atom/MouseEntered(location, control, params)
	. = ..()

	var/subtext
	if (screentip_subtext)
		subtext += "<br>[screentip_subtext]"

	var/datum/hud/hud = usr.hud_used
	hud.screentip_text.maptext = MAPTEXT("<span style='text-align: center'><span style='font-size: 32px'>[shows_screentips ? name : ""]</span>[subtext]</span>")
