$fn = 50;

module enclosure() {

  // Defined properties.

  spark_length = 37.338;
  spark_width  = 20.32;
  spark_height = 12.7;

  wall_size  = 3;
  padding    = 1;
  peg_height  = 2;
  peg_radius = 0.8;

  wire_radius = 2;

  micro_usb_width  = 5;
  micro_usb_height = 2.5;

  // Computed properties.

  inside_length  = spark_length + (padding * 2);
  outside_length = inside_length + (wall_size * 2);
  inside_width   = spark_width + (padding * 2);
  outside_width  = inside_width + (wall_size * 2);
  inside_height  = spark_height + (padding * 2);
  outside_height = inside_height + (wall_size * 2);

  // Useful properties.
  overflow_size = 1;

  difference() {
  	// Outer box.
    cube([outside_length, outside_width, outside_height], center=true);

  	// Inner box.
    translate([0, 0, padding + wall_size]) {
      cube([inside_length, inside_width, outside_height], center=true);
    }

  	// Pegs.
    translate([((outside_length / 2) - (wall_size / 2)), ((outside_width / 2) - (wall_size / 2)), (outside_height / 2) - peg_height ]) {
      cylinder(h=peg_height, r=peg_radius);
    }
    translate([-((outside_length / 2) - (wall_size / 2)), ((outside_width / 2) - (wall_size / 2)), (outside_height / 2) - peg_height ]) {
      cylinder(h=peg_height, r=peg_radius);
    }
    translate([((outside_length / 2) - (wall_size / 2)), -((outside_width / 2) - (wall_size / 2)), (outside_height / 2) - peg_height ]) {
      cylinder(h=peg_height, r=peg_radius);
    }
    translate([-((outside_length / 2) - (wall_size / 2)), -((outside_width / 2) - (wall_size / 2)), (outside_height / 2) - peg_height ]) {
      cylinder(h=peg_height, r=peg_radius);
    }

    // Micro USB.
    translate([-((inside_length / 2) + (wall_size / 2)), 0, 0]) {
      cube([wall_size + overflow_size, micro_usb_width, micro_usb_height], center=true);
    }

    // Wire port.
    translate([((inside_length / 2) + (wall_size / 2)), 0, 0]) {
      rotate([0, 90, 0]) {
        cylinder(wall_size + overflow_size, r=wire_radius, center=true);
      }
    }
  }
}

enclosure();