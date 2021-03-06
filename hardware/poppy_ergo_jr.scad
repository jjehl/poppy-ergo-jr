include <poppy_ergo_jr_def.scad>

include <robotis-scad/ollo/ollo_def.scad>
include <robotis-scad/dynamixel/xl320_def.scad>
include <robotis-scad/specific_frames/specific_frame_def.scad>

use <robotis-scad/dynamixel/xl320.scad>

use <robotis-scad/frames/side_to_side_frame.scad>
use <robotis-scad/frames/three_ollo_to_horn_frame.scad>
use <robotis-scad/frames/U_horn_to_horn_frame.scad>
use <robotis-scad/frames/U_three_ollo_to_horn_frame.scad>
use <robotis-scad/frames/U_three_ollo_frame.scad>

use <robotis-scad/specific_frames/base_frame.scad>
use <robotis-scad/specific_frames/pen_holder_frame.scad>
use <robotis-scad/specific_frames/cylinder_head_frame.scad>
use <robotis-scad/specific_frames/lamp_head_frame.scad>
use <robotis-scad/specific_frames/raspberry_pi_Bplus_base_frame.scad>
use <robotis-scad/specific_frames/wheel_tools.scad>

use <MCAD/rotate.scad>

module poppy_ergo_jr(direction="front", endTool="pen_holder"){
  if (direction == "front")
    xl320();
  if (direction == "back")
    rotate([0,0,180])
      xl320();

  translate_to_xl320_top()
    verticalize_U_horn_to_horn_frame(A){
      U_horn_to_horn_frame(A);
      xl320_two_horns();
      translate_to_box_back()
        translate([0,OlloSpacing/2,0])
          rotate([180,90,0])
            add_three_ollo_to_horn_frame(B)
              rotate([0,90,180]) {
                xl320_two_horns();
                translate_to_box_back()
                  translate([0,OlloSpacing/2,0])
                    rotate([180,90,0])
                        add_U_three_ollo_to_horn_frame(length=C, radius=OlloLayerThickness/2)
                          rotate([90,0,0])
                            translate([0,0,-MotorHeight/2-OlloLayerThickness]) {
                              xl320();
                              translate([0,-OlloSpacing*3,0])
                                rotate([180,0,0])
                                  add_three_ollo_to_horn_frame(D)
                                    rotate([0,90,180]) {
                                      xl320_two_horns();
                                      translate_to_box_back()
                                        translate([0,OlloSpacing/2,0])
                                          rotate([180,90,0])
                                            add_three_ollo_to_horn_frame(E)
                                              rotate([0,90,180]) {
                                                xl320_two_horns();
                                                translate_to_box_back()
                                                  translate([0,OlloSpacing/2,0])
                                                    rotate([180,90,0])
                                                      add_end_tool(endTool);
                                              }
                                    }
                            }
              }
    }
}

module add_end_tool(endTool) {
  if (endTool=="pen_holder")
    pen_holder_frame(length=F);
  if (endTool=="cylinder_head")
    cylinder_head_frame(length=F);
  if (endTool=="lamp_head")
    lamp_head_frame(length=F);
  if (endTool=="simple_U")
    U_three_ollo_frame(length=F);
}

// Testing
echo("##########");
echo("In poppy_ergo_jr.scad");
echo("This file should not be included, use ''use <filemane>'' instead.");
echo("##########");

p = 1;
if (p==1) {
  circular_base_frame(BaseRadius, BaseHeight);
  poppy_ergo_jr(endTool="cylinder_head");

  translate([100,0,0]) {
    translate([0, - RaspberryPiBplusWidth/2 - RaspberryPiBplusFrameDistanceBoardToMotor - MotorLength + MotorAxisOffset, -MotorHeight/2-ollo_segment_thickness(1)])
      raspberry_pi_Bplus_base_frame_with_raspberry_board();

    poppy_ergo_jr(endTool="pen_holder");
  }

  translate([200,0,0]) {
    translate([0,-3*OlloSpacing,0])
      circular_vertical_raspberry_pi_Bplus_base_frame_with_raspberry_board();
    poppy_ergo_jr(endTool="lamp_head");
  }

  translate([300,0,0]) {
    translate([0, - RaspberryPiBplusWidth/2 - RaspberryPiBplusFrameDistanceBoardToMotor - MotorLength + MotorAxisOffset, -MotorHeight/2-ollo_segment_thickness(1)]) {

      raspberry_pi_Bplus_base_frame_with_wheels();

      translate([0,RaspberryPiBplusWidth+RaspberryPiBplusFrameDistanceBoardToMotor,MotorHeight/2+ollo_segment_thickness(1)])
        xl320();
      translate([0,RaspberryPiBplusFrameLenght-RaspberryPiBplusWidth/2-RaspberryPiBplusFrameCameraDistFromEnd,-RaspberryPiBplusFrameHeight+MotorHeight/2])
        passive_wheel();

      translate([-RaspberryPiBplusFrameWidth/2+MotorHeight/2,1.5*OlloSpacing,-RaspberryPiBplusFrameHeight])
        rotate([0,-90,0])
          add_wheel("lego");

      translate([RaspberryPiBplusFrameWidth/2-MotorHeight/2,1.5*OlloSpacing,-RaspberryPiBplusFrameHeight])
        rotate([0,90,0])
          add_wheel("lego");
    }

    poppy_ergo_jr(endTool="simple_U");
  }

}
