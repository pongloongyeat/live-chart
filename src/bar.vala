using Cairo;

namespace LiveChart { 
    public class Bar : Drawable, Object {
        public Gdk.RGBA color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0,
                green = 1.0,
                blue = 1.0,
                alpha = 1.0
            };
        }

        private Points points;
        public Bar(Points points) {
            this.points = points;
        }

        public void draw(Context ctx, Geometry geometry) {
                
            ctx.set_source_rgba(this.color.red, this.color.green, this.color.blue, this.color.alpha);

            double current_x_pos = geometry.width - geometry.padding.right;
            for (int pos = this.points.size - 1; pos >= 0; pos--) {
                
                if (current_x_pos < geometry.padding.left) {
                    break;
                }
                var current_point = this.points[pos];
                var previous_point = pos == this.points.size - 1 ? current_point : this.points.get(pos + 1);

                var bar_width = (current_point.x - previous_point.x) / 1.2;
                ctx.rectangle(current_x_pos, geometry.height - geometry.padding.bottom - (current_point.y * geometry.y_ratio), bar_width, (current_point.y * geometry.y_ratio));
                ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
                ctx.fill();
                current_x_pos = current_x_pos - (previous_point.x - current_point.x);
            }

            ctx.stroke();
        }
    }
}