const int currentDevice = 1;

public class drawingPad : Gtk.Window {

	Gtk.DrawingArea drawing_area;
	double x = 0;
	double y = 0;

	GtkClutter.Embed embed;
	
	public drawingPad() {
		this.title = "Drawing Pad";
		set_default_size(500, 500);

		embed = new GtkClutter.Embed() {
				width_request = 500,
				height_request = 500
					};
		add(embed);
			
/*		this.drawing_area = new Gtk.DrawingArea();
		add(this.drawing_area);*/
	}

	public void callback_func(Gdk.Event anEvent) {

		var source = anEvent.get_device().get_source();
		var tool = anEvent.get_device_tool().get_tool_type();

		if (tool == Gdk.DeviceToolType.PEN) {
//			stdout.printf("pen activity detected\n");

			//TODO: pressure
			
			anEvent.get_coords(out x, out y);

			x = x - 20;
			y = y - 50;
			
/*			this.drawing_area.draw.connect((context) => {

					stdout.printf("%f %f\n", this.x, this.y);
					
					context.set_source_rgba (1, 0, 0, 1);
					context.set_line_width (1);

					context.move_to (x, y);
					context.line_to (x+1, y+1);
					
					context.stroke();

					this.drawing_area.queue_draw();
					
					return true;
				});

				this.drawing_area.queue_draw();*/

			var t = new Clutter.Text() {
					text = ".",
						x = (int)this.x,
						y = (int)this.y
						};
			this.embed.get_stage().add_child(t);
		}
		
		/*if (source == Gdk.InputSource.MOUSE) {
			stdout.printf("mouse\n");
		} else if (source == Gdk.InputSource.PEN) {
			stdout.printf("pen\n");
		} else if (source == Gdk.InputSource.ERASER) {
			stdout.printf("eraser\n");
		} else {
			stdout.printf("something else\n");
		}*/
		
		Gtk.main_do_event(anEvent);
	}
	
	public void init_pen() {
		
		stdout.printf("init pen\n");

		var devices = new List<Gdk.Device>();

		Gdk.Display.get_default().get_default_seat().get_slaves(Gdk.SeatCapabilities.TABLET_STYLUS).foreach((device) => {
				stdout.printf("%s\n", device.name);
				devices.append(device);
			});
		
		Gdk.Window main_window = this.get_window();
		
		if (main_window == null) {
			stdout.printf("gdk window is null\n");
		} else {
			stdout.printf("gdk window is not null\n");
		}
			
//		Gdk.Display.get_default().get_default_seat().grab(main_window, Gdk.SeatCapabilities.TABLET_STYLUS, true, null, null, null);

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