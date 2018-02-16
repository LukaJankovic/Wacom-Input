const int currentDevice = 1;

public class drawingPad : Gtk.Window {

	Gtk.DrawingArea drawing_area;
	Cairo.Surface drawing_surface;
	
	double x = 0;
	double y = 0;
	double pressure = 0;

   	double oldx = 0;
	double oldy = 0;	
	
	public drawingPad() {
		
		this.title = "Drawing Pad";
		set_default_size(500, 500);
		
		this.drawing_area = new Gtk.DrawingArea();
		this.add(this.drawing_area);
		
		drawing_area.set_events(Gdk.EventMask.ALL_EVENTS_MASK);
		
		drawing_area.motion_notify_event.connect((anEvent) => {
				
				var tool = anEvent.get_device_tool().get_tool_type();
				var type = anEvent.get_event_type();
				var source = anEvent.get_device().get_source();

				//Sometimes tool isn't detected. reboot / relog wayland to fix
			
				if (type == Gdk.EventType.MOTION_NOTIFY && tool == Gdk.DeviceToolType.PEN) {

					//Hide cursor
					Gdk.Window main_window = this.get_window();
					Gdk.Cursor empty_cursor = new Gdk.Cursor.for_display(Gdk.Display.get_default(), Gdk.CursorType.BLANK_CURSOR);
					
					main_window.set_cursor(empty_cursor);
					
					anEvent.get_coords(out x, out y);
					anEvent.get_axis(Gdk.AxisUse.PRESSURE, out pressure);
					
					var ctx = new Cairo.Context(this.drawing_surface);
					
					if (oldx == 0 || oldy == 0 || (oldx == 0 && oldy == 0))
						ctx.move_to(x,y);
					else
						ctx.move_to(oldx,oldy);
					
					double a, b;
					ctx.get_current_point(out a, out b);
					
					ctx.set_source_rgba(0,0,0,pressure);
					ctx.set_line_width(pressure * 10);
					ctx.line_to(x,y);
					ctx.stroke();
					
					ctx.move_to(x,y);
					
					oldx = x;
					oldy = y;
					
					this.drawing_area.queue_draw();
   				} else {
					
					//Unhide cursor
					var main_window = this.get_window();
					main_window.set_cursor(null);
				}
							
				return true;
			});
		
		this.drawing_area.configure_event.connect((anEvent) => {
				if (this.drawing_surface == null) {
					this.drawing_surface = this.get_window().create_similar_surface(Cairo.Content.COLOR_ALPHA, this.drawing_area.get_allocated_width(), this.drawing_area.get_allocated_height());
				} else {
					//Resize
					var newSurface = this.get_window().create_similar_surface(Cairo.Content.COLOR_ALPHA, this.drawing_area.get_allocated_width(), this.drawing_area.get_allocated_height());

					var ctx = new Cairo.Context(newSurface);
					ctx.set_source_surface(this.drawing_surface, 0, 0);
					ctx.paint();

					this.drawing_surface = newSurface;
				}

				return true;
			});
		
		this.drawing_area.draw.connect((ctx) => {
				
				ctx.set_source_surface(this.drawing_surface, 0, 0);
				ctx.stroke();
				ctx.paint();
				
				return false;
			});
	}
}

static int main(string[] args) {
	Gtk.init(ref args);
	Gdk.init(ref args);
	
	var pad = new drawingPad();
	pad.show_all();
	
	Gtk.main();
	
	return 0;
}