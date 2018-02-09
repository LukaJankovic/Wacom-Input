const int currentDevice = 1;

public class drawingPad : Gtk.Window {

	Gtk.DrawingArea drawing_area;
	
	public drawingPad() {
		this.title = "Drawing Pad";
		set_default_size(500, 500);

		this.drawing_area = new Gtk.DrawingArea();
		add(this.drawing_area);
	}

	public void callback_func(Gdk.Event anEvent) {

		var source = anEvent.get_device().get_source();
		var tool = anEvent.get_device_tool().get_tool_type();
		
//		stdout.printf("device %s did something\n", anEvent.get_device().name);

		if (tool == Gdk.DeviceToolType.PEN) {
			stdout.printf("pen activity detected\n");
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
	
	var pad = new drawingPad();
	pad.show_all();

	pad.init_pen();
   	
	Gtk.main();
		
	return 0;
}