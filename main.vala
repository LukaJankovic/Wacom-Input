const int currentDevice = 1;

public class drawingPad : Gtk.Window {

	Gtk.DrawingArea drawing_area;
	double x = 0;
	double y = 0;
	double pressure = 0;
	
	GtkClutter.Embed embed;
	
	public drawingPad() {
		this.title = "Drawing Pad";
		set_default_size(500, 500);

		embed = new GtkClutter.Embed() {
				width_request = 500,
				height_request = 500
					};
		add(embed);
	}

	public void callback_func(Gdk.Event anEvent) {

//		var source = anEvent.get_device().get_source();
		var tool = anEvent.get_device_tool().get_tool_type();
		var type = anEvent.get_event_type();

		if (tool == Gdk.DeviceToolType.PEN && type == Gdk.EventType.MOTION_NOTIFY) {

			//TODO: pressure
			
			anEvent.get_coords(out x, out y);
			anEvent.get_axis(Gdk.AxisUse.PRESSURE, out pressure);

			stdout.printf("%f\n", pressure);
			
			var t = new Clutter.Actor() {
					x = (int)this.x,
						y = (int)this.y,
						width = (int)(pressure * 10),
						height = (int)(pressure * 10),
						background_color = Clutter.Color.from_string("black")};
			
			this.embed.get_stage().add_child(t);
		}
	   
		Gtk.main_do_event(anEvent);
	}
	
	public void init_pen() {
		
		Gdk.EventFunc d = this.callback_func;
		Gdk.Event.handler_set(d);	  	
	}
}

static int main(string[] args) {
	Gtk.init(ref args);
	Gdk.init(ref args);
	GtkClutter.init(ref args);
	
	var pad = new drawingPad();
	pad.show_all();

	pad.init_pen();
   	
	Gtk.main();
	
	return 0;
}