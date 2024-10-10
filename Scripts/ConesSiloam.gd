extends Node3D

#need to track that the player travels through the areas in order backwards or forwards
# i.e travel through areas 1-5 or areas 5-1
var area_0 :bool
var area_1 :bool
var area_2 :bool
var area_3 :bool
var area_4 :bool
var area_5 :bool
var area_6 :bool

func _on_area_3d_area_entered(area):
	if area_1 == true && area_2 == true && area_3 == true && area_4 == true && area_5 == true && area_6 == true: #if all others are true then entering the last area means finishing the siloam
		area_0 = true
		print("completed siloam")
		#TODO add code to update siloam task
	if area_1 == false && area_2 == false && area_3 == false && area_4 == false && area_5 == false && area_6 == false: #if all are false then we are just starting the siloam
		area_0 = true
	else: #otherwise some were skipped and so we should reset the siloam task
		area_0 = false 
		area_1 = false
		area_2 = false
		area_3 == false
		area_4 == false
		area_5 == false
		area_6 == false

func _on_area_3d_1_area_entered(area):
	if (area_0 == true && area_2 == false) or (area_0 == false && area_2 == true):
		area_1 = true

func _on_area_3d_2_area_entered(area):
	if (area_1 == true && area_3 == false) or (area_1 == false && area_3 == true):
		area_2 = true

func _on_area_3d_3_area_entered(area):
	if (area_2 == true && area_4 == false) or (area_2 == false && area_4 == true):
		area_3 = true

func _on_area_3d_4_area_entered(area):
	if (area_3 == true && area_5 == false) or (area_3 == false && area_5 == true):
		area_4 = true

func _on_area_3d_5_area_entered(area):
	if (area_4 == true && area_6 == false) or (area_4 == false && area_6 == true):
		area_5 = true

func _on_area_3d_6_area_entered(area):
	if area_0 == true && area_1 == true && area_2 == true && area_3 == true && area_4 == true && area_5 == true: #if all others are true then entering the last area means finishing the siloam
		area_6 = true
		print("completed siloam")
		#TODO add code to update siloam task
	if area_0 == false && area_1 == false && area_2 == false && area_3 == false && area_4 == false && area_5 == false: #if all are false then we are just starting the siloam
		area_6 = true
	else: #otherwise some were skipped and so we should reset the siloam task
		area_0 = false 
		area_1 = false
		area_2 = false
		area_3 == false
		area_4 == false
		area_5 == false
		area_6 == false
