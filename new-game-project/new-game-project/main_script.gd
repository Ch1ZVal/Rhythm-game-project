extends Node2D

@export var note_scene: PackedScene
@onready var audio_stream = $AudioStreamPlayer
@onready var playfield = $Playfield
@onready var fx_particles = $GPUParticles2D 
@onready var particle_scene: PackedScene = preload("res://particles_2d.tscn")
@onready var score_text = $Score

const NOTE_TEMPLATE = preload("res://Note.tscn")
const RECEPTOR_Y = 859.0 #where the Y recetor is. Basically feeds on the notes at that Y.
const SPAWN_Y = 0.0 #the y in which notes spawn

var current_time: float = 0.0
var travel_time: float = 1.5 #1.5 seconds to travel down
var note_speed: float = 572.6
var score = 0



var selected_song = ""
var selected_chart = "" #james edit this
 
#region Shine as usual. So many lines
var shine_as_usual_chart: Array[Dictionary] = [
{"spawn_time": 2.550, "lane": 1},
{"spawn_time": 4.250, "lane": 1},
{"spawn_time": 4.750, "lane": 2},
{"spawn_time": 5.200, "lane": 1},
{"spawn_time": 5.200, "lane": 2},
{"spawn_time": 5.900, "lane": 2},
{"spawn_time": 6.400, "lane": 3},
{"spawn_time": 6.900, "lane": 4},
{"spawn_time": 7.600, "lane": 3},
{"spawn_time": 8.050, "lane": 3},
{"spawn_time": 8.650, "lane": 2},
{"spawn_time": 9.250, "lane": 2},
{"spawn_time": 9.700, "lane": 1},
{"spawn_time": 10.300, "lane": 2},
{"spawn_time": 10.750, "lane": 3},
{"spawn_time": 11.350, "lane": 4},
{"spawn_time": 11.950, "lane": 3},
{"spawn_time": 12.400, "lane": 2},
{"spawn_time": 13.000, "lane": 3},
{"spawn_time": 13.450, "lane": 2},
{"spawn_time": 14.050, "lane": 2},
{"spawn_time": 14.550, "lane": 3},
{"spawn_time": 15.000, "lane": 2},
{"spawn_time": 15.500, "lane": 3},
{"spawn_time": 16.100, "lane": 2},
{"spawn_time": 16.700, "lane": 2},
{"spawn_time": 17.150, "lane": 1},
{"spawn_time": 17.600, "lane": 1},
{"spawn_time": 18.200, "lane": 2},
{"spawn_time": 18.900, "lane": 1},
{"spawn_time": 19.400, "lane": 2},
{"spawn_time": 20.000, "lane": 2},
{"spawn_time": 20.700, "lane": 3},
{"spawn_time": 21.200, "lane": 2},
{"spawn_time": 21.650, "lane": 3},
{"spawn_time": 22.150, "lane": 4},
{"spawn_time": 22.850, "lane": 4},
{"spawn_time": 23.550, "lane": 3},
{"spawn_time": 24.000, "lane": 3},
{"spawn_time": 24.600, "lane": 2},
{"spawn_time": 25.300, "lane": 3},
{"spawn_time": 25.900, "lane": 3},
{"spawn_time": 26.350, "lane": 2},
{"spawn_time": 26.850, "lane": 3},
{"spawn_time": 27.350, "lane": 4},
{"spawn_time": 27.800, "lane": 3},
{"spawn_time": 28.250, "lane": 2},
{"spawn_time": 28.850, "lane": 1},
{"spawn_time": 29.300, "lane": 2},
{"spawn_time": 29.750, "lane": 3},
{"spawn_time": 30.250, "lane": 3},
{"spawn_time": 30.750, "lane": 2},
{"spawn_time": 31.450, "lane": 2},
{"spawn_time": 31.950, "lane": 3},
{"spawn_time": 32.550, "lane": 2},
{"spawn_time": 33.250, "lane": 2},
{"spawn_time": 33.250, "lane": 4},
{"spawn_time": 33.500, "lane": 3},
{"spawn_time": 33.800, "lane": 2},
{"spawn_time": 34.050, "lane": 1},
{"spawn_time": 34.050, "lane": 2},
{"spawn_time": 34.300, "lane": 3},
{"spawn_time": 34.650, "lane": 4},
{"spawn_time": 34.950, "lane": 4},
{"spawn_time": 35.250, "lane": 2},
{"spawn_time": 35.250, "lane": 3},
{"spawn_time": 35.550, "lane": 4},
{"spawn_time": 35.900, "lane": 3},
{"spawn_time": 35.900, "lane": 4},
{"spawn_time": 36.150, "lane": 2},
{"spawn_time": 36.500, "lane": 3},
{"spawn_time": 36.800, "lane": 2},
{"spawn_time": 37.200, "lane": 1},
{"spawn_time": 37.500, "lane": 1},
{"spawn_time": 37.750, "lane": 1},
{"spawn_time": 38.000, "lane": 1},
{"spawn_time": 38.300, "lane": 1},
{"spawn_time": 38.700, "lane": 1},
{"spawn_time": 38.950, "lane": 1},
{"spawn_time": 39.350, "lane": 1},
{"spawn_time": 39.750, "lane": 1},
{"spawn_time": 40.150, "lane": 1},
{"spawn_time": 40.450, "lane": 1},
{"spawn_time": 40.450, "lane": 4},
{"spawn_time": 40.700, "lane": 2},
{"spawn_time": 41.100, "lane": 1},
{"spawn_time": 41.400, "lane": 1},
{"spawn_time": 41.400, "lane": 2},
{"spawn_time": 41.650, "lane": 2},
{"spawn_time": 41.650, "lane": 4},
{"spawn_time": 41.950, "lane": 3},
{"spawn_time": 42.250, "lane": 4},
{"spawn_time": 42.500, "lane": 4},
{"spawn_time": 42.850, "lane": 3},
{"spawn_time": 43.200, "lane": 3},
{"spawn_time": 43.500, "lane": 2},
{"spawn_time": 43.750, "lane": 1},
{"spawn_time": 44.000, "lane": 1},
{"spawn_time": 44.350, "lane": 1},
{"spawn_time": 44.600, "lane": 2},
{"spawn_time": 44.900, "lane": 3},
{"spawn_time": 45.250, "lane": 4},
{"spawn_time": 45.500, "lane": 3},
{"spawn_time": 45.750, "lane": 4},
{"spawn_time": 46.000, "lane": 4},
{"spawn_time": 46.350, "lane": 3},
{"spawn_time": 46.700, "lane": 4},
{"spawn_time": 47.050, "lane": 3},
{"spawn_time": 47.300, "lane": 1},
{"spawn_time": 47.300, "lane": 2},
{"spawn_time": 47.650, "lane": 1},
{"spawn_time": 48.000, "lane": 1},
{"spawn_time": 48.000, "lane": 2},
{"spawn_time": 48.400, "lane": 2},
{"spawn_time": 48.400, "lane": 3},
{"spawn_time": 48.700, "lane": 4},
{"spawn_time": 49.000, "lane": 4},
{"spawn_time": 49.350, "lane": 4},
{"spawn_time": 49.600, "lane": 3},
{"spawn_time": 49.900, "lane": 4},
{"spawn_time": 50.300, "lane": 3},
{"spawn_time": 50.600, "lane": 3},
{"spawn_time": 50.600, "lane": 4},
{"spawn_time": 50.900, "lane": 4},
{"spawn_time": 51.250, "lane": 4},
{"spawn_time": 51.550, "lane": 4},
{"spawn_time": 51.800, "lane": 3},
{"spawn_time": 52.200, "lane": 3},
{"spawn_time": 52.600, "lane": 1},
{"spawn_time": 52.600, "lane": 2},
{"spawn_time": 52.900, "lane": 2},
{"spawn_time": 53.300, "lane": 2},
{"spawn_time": 53.550, "lane": 3},
{"spawn_time": 53.950, "lane": 2},
{"spawn_time": 54.200, "lane": 1},
{"spawn_time": 54.550, "lane": 1},
{"spawn_time": 54.550, "lane": 3},
{"spawn_time": 54.900, "lane": 1},
{"spawn_time": 55.250, "lane": 2},
{"spawn_time": 55.500, "lane": 2},
{"spawn_time": 55.500, "lane": 3},
{"spawn_time": 55.800, "lane": 3},
{"spawn_time": 56.050, "lane": 3},
{"spawn_time": 56.350, "lane": 4},
{"spawn_time": 56.700, "lane": 4},
{"spawn_time": 56.950, "lane": 4},
{"spawn_time": 57.350, "lane": 4},
{"spawn_time": 57.700, "lane": 4},
{"spawn_time": 58.100, "lane": 4},
{"spawn_time": 58.400, "lane": 4},
{"spawn_time": 58.800, "lane": 4},
{"spawn_time": 59.150, "lane": 4},
{"spawn_time": 59.500, "lane": 4},
{"spawn_time": 59.800, "lane": 3},
{"spawn_time": 60.100, "lane": 2},
{"spawn_time": 60.450, "lane": 2},
{"spawn_time": 60.750, "lane": 1},
{"spawn_time": 60.750, "lane": 2},
{"spawn_time": 61.050, "lane": 2},
{"spawn_time": 61.450, "lane": 3},
{"spawn_time": 61.700, "lane": 4},
{"spawn_time": 62.000, "lane": 3},
{"spawn_time": 62.300, "lane": 2},
{"spawn_time": 62.550, "lane": 1},
{"spawn_time": 62.850, "lane": 1},
{"spawn_time": 63.250, "lane": 2},
{"spawn_time": 63.430, "lane": 3},
{"spawn_time": 63.730, "lane": 4},
{"spawn_time": 63.980, "lane": 4},
{"spawn_time": 64.280, "lane": 4},
{"spawn_time": 64.500, "lane": 4},
{"spawn_time": 64.720, "lane": 3},
{"spawn_time": 65.020, "lane": 3},
{"spawn_time": 65.200, "lane": 3},
{"spawn_time": 65.450, "lane": 2},
{"spawn_time": 65.630, "lane": 1},
{"spawn_time": 65.930, "lane": 2},
{"spawn_time": 66.110, "lane": 2},
{"spawn_time": 66.110, "lane": 3},
{"spawn_time": 66.410, "lane": 4},
{"spawn_time": 66.710, "lane": 4},
{"spawn_time": 66.890, "lane": 4},
{"spawn_time": 67.070, "lane": 4},
{"spawn_time": 67.370, "lane": 4},
{"spawn_time": 67.590, "lane": 2},
{"spawn_time": 67.590, "lane": 4},
{"spawn_time": 67.890, "lane": 3},
{"spawn_time": 68.190, "lane": 4},
{"spawn_time": 68.410, "lane": 4},
{"spawn_time": 68.710, "lane": 3},
{"spawn_time": 68.890, "lane": 4},
{"spawn_time": 69.110, "lane": 4},
{"spawn_time": 69.360, "lane": 4},
{"spawn_time": 69.660, "lane": 4},
{"spawn_time": 69.960, "lane": 4},
{"spawn_time": 70.260, "lane": 3},
{"spawn_time": 70.560, "lane": 3},
{"spawn_time": 70.740, "lane": 2},
{"spawn_time": 70.920, "lane": 1},
{"spawn_time": 71.140, "lane": 1},
{"spawn_time": 71.360, "lane": 2},
{"spawn_time": 71.540, "lane": 2},
{"spawn_time": 71.840, "lane": 3},
{"spawn_time": 72.060, "lane": 2},
{"spawn_time": 72.240, "lane": 2},
{"spawn_time": 72.240, "lane": 3},
{"spawn_time": 72.420, "lane": 4},
{"spawn_time": 72.720, "lane": 3},
{"spawn_time": 72.940, "lane": 2},
{"spawn_time": 73.160, "lane": 3},
{"spawn_time": 73.410, "lane": 3},
{"spawn_time": 73.590, "lane": 2},
{"spawn_time": 73.840, "lane": 1},
{"spawn_time": 74.090, "lane": 1},
{"spawn_time": 74.390, "lane": 2},
{"spawn_time": 74.640, "lane": 1},
{"spawn_time": 74.940, "lane": 2},
{"spawn_time": 75.190, "lane": 3},
{"spawn_time": 75.490, "lane": 3},
{"spawn_time": 75.740, "lane": 3},
{"spawn_time": 75.920, "lane": 4},
{"spawn_time": 76.140, "lane": 2},
{"spawn_time": 76.140, "lane": 4},
{"spawn_time": 76.440, "lane": 4},
{"spawn_time": 76.660, "lane": 4},
{"spawn_time": 76.910, "lane": 1},
{"spawn_time": 76.910, "lane": 4},
{"spawn_time": 77.160, "lane": 3},
{"spawn_time": 77.340, "lane": 4},
{"spawn_time": 77.640, "lane": 4},
{"spawn_time": 77.940, "lane": 3},
{"spawn_time": 78.120, "lane": 2},
{"spawn_time": 78.420, "lane": 3},
{"spawn_time": 78.670, "lane": 4},
{"spawn_time": 78.920, "lane": 4},
{"spawn_time": 79.170, "lane": 4},
{"spawn_time": 79.420, "lane": 3},
{"spawn_time": 79.600, "lane": 2},
{"spawn_time": 79.820, "lane": 2},
{"spawn_time": 80.120, "lane": 1},
{"spawn_time": 80.370, "lane": 1},
{"spawn_time": 80.620, "lane": 1},
{"spawn_time": 80.870, "lane": 1},
{"spawn_time": 80.870, "lane": 2},
{"spawn_time": 81.090, "lane": 1},
{"spawn_time": 81.340, "lane": 1},
{"spawn_time": 81.640, "lane": 2},
{"spawn_time": 81.890, "lane": 1},
{"spawn_time": 82.140, "lane": 1},
{"spawn_time": 82.140, "lane": 2},
{"spawn_time": 82.390, "lane": 3},
{"spawn_time": 82.390, "lane": 4},
{"spawn_time": 82.690, "lane": 2},
{"spawn_time": 82.870, "lane": 1},
{"spawn_time": 83.120, "lane": 2},
{"spawn_time": 83.300, "lane": 3},
{"spawn_time": 83.520, "lane": 3},
{"spawn_time": 83.820, "lane": 3},
{"spawn_time": 84.120, "lane": 4},
{"spawn_time": 84.300, "lane": 3},
{"spawn_time": 84.480, "lane": 2},
{"spawn_time": 84.730, "lane": 1},
{"spawn_time": 84.730, "lane": 3},
{"spawn_time": 84.950, "lane": 4},
{"spawn_time": 85.250, "lane": 2},
{"spawn_time": 85.250, "lane": 4},
{"spawn_time": 85.550, "lane": 1},
{"spawn_time": 85.550, "lane": 4},
{"spawn_time": 85.800, "lane": 4},
{"spawn_time": 86.050, "lane": 1},
{"spawn_time": 86.050, "lane": 4},
{"spawn_time": 86.270, "lane": 4},
{"spawn_time": 86.490, "lane": 3},
{"spawn_time": 86.670, "lane": 4},
{"spawn_time": 86.920, "lane": 4},
{"spawn_time": 87.170, "lane": 4},
{"spawn_time": 87.420, "lane": 1},
{"spawn_time": 87.420, "lane": 4},
{"spawn_time": 87.720, "lane": 4},
{"spawn_time": 88.020, "lane": 3},
{"spawn_time": 88.200, "lane": 3},
{"spawn_time": 88.380, "lane": 4},
{"spawn_time": 88.600, "lane": 4},
{"spawn_time": 88.900, "lane": 4},
{"spawn_time": 89.200, "lane": 4},
{"spawn_time": 89.500, "lane": 3},
{"spawn_time": 89.750, "lane": 4},
{"spawn_time": 90.000, "lane": 4},
{"spawn_time": 90.250, "lane": 2},
{"spawn_time": 90.250, "lane": 4},
{"spawn_time": 90.430, "lane": 3},
{"spawn_time": 90.680, "lane": 4},
{"spawn_time": 90.980, "lane": 4},
{"spawn_time": 91.160, "lane": 3},
{"spawn_time": 91.340, "lane": 4},
{"spawn_time": 91.640, "lane": 4},
{"spawn_time": 91.860, "lane": 4},
{"spawn_time": 92.110, "lane": 3},
{"spawn_time": 92.110, "lane": 4},
{"spawn_time": 92.410, "lane": 2},
{"spawn_time": 92.630, "lane": 3},
{"spawn_time": 92.810, "lane": 2},
{"spawn_time": 93.030, "lane": 1},
{"spawn_time": 93.430, "lane": 1},
{"spawn_time": 94.030, "lane": 2},
{"spawn_time": 94.530, "lane": 1},
{"spawn_time": 95.030, "lane": 2},
{"spawn_time": 95.430, "lane": 3},
{"spawn_time": 96.030, "lane": 2},
{"spawn_time": 96.430, "lane": 2},
{"spawn_time": 96.930, "lane": 2},
{"spawn_time": 97.530, "lane": 2},
{"spawn_time": 98.030, "lane": 3},
{"spawn_time": 98.630, "lane": 4},
{"spawn_time": 99.130, "lane": 4},
{"spawn_time": 99.630, "lane": 4},
{"spawn_time": 100.130, "lane": 3},
{"spawn_time": 100.530, "lane": 3},
{"spawn_time": 100.530, "lane": 4},
{"spawn_time": 100.930, "lane": 4},
{"spawn_time": 101.430, "lane": 3},
{"spawn_time": 102.030, "lane": 2},
{"spawn_time": 102.430, "lane": 2},
{"spawn_time": 103.030, "lane": 1},
{"spawn_time": 103.530, "lane": 1},
{"spawn_time": 104.030, "lane": 1},
{"spawn_time": 104.030, "lane": 3},
{"spawn_time": 104.530, "lane": 2},
{"spawn_time": 105.030, "lane": 1},
{"spawn_time": 105.630, "lane": 2},
{"spawn_time": 106.230, "lane": 3},
{"spawn_time": 106.730, "lane": 3},
{"spawn_time": 106.730, "lane": 4},
{"spawn_time": 107.130, "lane": 4},
{"spawn_time": 107.730, "lane": 3},
{"spawn_time": 108.330, "lane": 2},
{"spawn_time": 108.730, "lane": 2},
{"spawn_time": 109.330, "lane": 2},
{"spawn_time": 109.730, "lane": 2},
{"spawn_time": 110.230, "lane": 1},
{"spawn_time": 110.630, "lane": 1},
{"spawn_time": 111.230, "lane": 2},
{"spawn_time": 111.630, "lane": 1},
{"spawn_time": 112.230, "lane": 1},
{"spawn_time": 112.830, "lane": 1},
{"spawn_time": 113.430, "lane": 1},
{"spawn_time": 114.030, "lane": 1},
{"spawn_time": 114.530, "lane": 1},
{"spawn_time": 114.930, "lane": 2},
{"spawn_time": 115.430, "lane": 2},
{"spawn_time": 115.930, "lane": 1},
{"spawn_time": 116.430, "lane": 1},
{"spawn_time": 116.930, "lane": 1},
{"spawn_time": 117.530, "lane": 1},
{"spawn_time": 117.530, "lane": 4},
{"spawn_time": 118.130, "lane": 1},
{"spawn_time": 118.130, "lane": 4},
{"spawn_time": 118.630, "lane": 1},
{"spawn_time": 119.230, "lane": 2},
{"spawn_time": 119.830, "lane": 1},
{"spawn_time": 120.330, "lane": 1},
{"spawn_time": 120.830, "lane": 1},
{"spawn_time": 121.430, "lane": 1},
{"spawn_time": 122.030, "lane": 1},
{"spawn_time": 122.630, "lane": 1},
{"spawn_time": 123.130, "lane": 2},
{"spawn_time": 123.630, "lane": 3},
{"spawn_time": 124.230, "lane": 4},
{"spawn_time": 124.730, "lane": 3},
{"spawn_time": 125.330, "lane": 3},
{"spawn_time": 125.930, "lane": 3},
{"spawn_time": 126.630, "lane": 2},
{"spawn_time": 127.230, "lane": 1},
{"spawn_time": 127.680, "lane": 2},
{"spawn_time": 128.180, "lane": 1},
{"spawn_time": 128.780, "lane": 1},
{"spawn_time": 129.230, "lane": 1},
{"spawn_time": 129.930, "lane": 2},
{"spawn_time": 130.530, "lane": 1},
{"spawn_time": 131.130, "lane": 1},
{"spawn_time": 131.830, "lane": 2},
{"spawn_time": 132.430, "lane": 3},
{"spawn_time": 132.880, "lane": 4},
{"spawn_time": 133.480, "lane": 3},
{"spawn_time": 133.930, "lane": 2},
{"spawn_time": 134.630, "lane": 3},
{"spawn_time": 135.130, "lane": 4},
{"spawn_time": 135.830, "lane": 4},
{"spawn_time": 136.330, "lane": 4},
{"spawn_time": 137.030, "lane": 3},
{"spawn_time": 137.630, "lane": 4},
{"spawn_time": 138.130, "lane": 4},
{"spawn_time": 138.630, "lane": 4},
{"spawn_time": 139.230, "lane": 3},
{"spawn_time": 139.830, "lane": 2},
{"spawn_time": 140.330, "lane": 1},
{"spawn_time": 141.030, "lane": 1},
{"spawn_time": 141.480, "lane": 1},
{"spawn_time": 141.980, "lane": 1},
{"spawn_time": 142.480, "lane": 2},
{"spawn_time": 142.980, "lane": 2},
{"spawn_time": 143.480, "lane": 2},
{"spawn_time": 143.930, "lane": 1},
{"spawn_time": 144.430, "lane": 1},
{"spawn_time": 144.930, "lane": 1},
{"spawn_time": 144.930, "lane": 2},
{"spawn_time": 145.380, "lane": 1},
{"spawn_time": 145.980, "lane": 1},
{"spawn_time": 146.430, "lane": 1},
{"spawn_time": 146.880, "lane": 2},
{"spawn_time": 147.480, "lane": 3},
{"spawn_time": 148.180, "lane": 4},
{"spawn_time": 148.630, "lane": 3},
{"spawn_time": 149.080, "lane": 4},
{"spawn_time": 149.780, "lane": 4},
{"spawn_time": 150.480, "lane": 4},
{"spawn_time": 150.930, "lane": 3},
{"spawn_time": 151.380, "lane": 4},
{"spawn_time": 151.980, "lane": 4},
{"spawn_time": 152.580, "lane": 3},
{"spawn_time": 153.280, "lane": 4},
{"spawn_time": 153.530, "lane": 4},
{"spawn_time": 153.830, "lane": 4},
{"spawn_time": 154.130, "lane": 4},
{"spawn_time": 154.530, "lane": 4},
{"spawn_time": 154.780, "lane": 4},
{"spawn_time": 155.130, "lane": 1},
{"spawn_time": 155.130, "lane": 3},
{"spawn_time": 155.530, "lane": 3},
{"spawn_time": 155.530, "lane": 4},
{"spawn_time": 155.780, "lane": 3},
{"spawn_time": 156.130, "lane": 2},
{"spawn_time": 156.480, "lane": 1},
{"spawn_time": 156.880, "lane": 1},
{"spawn_time": 156.880, "lane": 4},
{"spawn_time": 157.230, "lane": 1},
{"spawn_time": 157.530, "lane": 1},
{"spawn_time": 157.830, "lane": 1},
{"spawn_time": 158.180, "lane": 2},
{"spawn_time": 158.480, "lane": 3},
{"spawn_time": 158.730, "lane": 2},
{"spawn_time": 159.080, "lane": 2},
{"spawn_time": 159.430, "lane": 1},
{"spawn_time": 159.730, "lane": 1},
{"spawn_time": 160.130, "lane": 1},
{"spawn_time": 160.380, "lane": 2},
{"spawn_time": 160.680, "lane": 1},
{"spawn_time": 161.030, "lane": 2},
{"spawn_time": 161.380, "lane": 1},
{"spawn_time": 161.630, "lane": 1},
{"spawn_time": 161.880, "lane": 2},
{"spawn_time": 162.280, "lane": 2},
{"spawn_time": 162.680, "lane": 2},
{"spawn_time": 162.930, "lane": 3},
{"spawn_time": 163.280, "lane": 2},
{"spawn_time": 163.630, "lane": 1},
{"spawn_time": 163.880, "lane": 1},
{"spawn_time": 164.180, "lane": 1},
{"spawn_time": 164.180, "lane": 3},
{"spawn_time": 164.530, "lane": 1},
{"spawn_time": 164.930, "lane": 2},
{"spawn_time": 165.230, "lane": 1},
{"spawn_time": 165.580, "lane": 1},
{"spawn_time": 165.580, "lane": 2},
{"spawn_time": 165.830, "lane": 3},
{"spawn_time": 166.180, "lane": 4},
{"spawn_time": 166.580, "lane": 3},
{"spawn_time": 166.980, "lane": 4},
{"spawn_time": 167.280, "lane": 3},
{"spawn_time": 167.630, "lane": 2},
{"spawn_time": 167.880, "lane": 2},
{"spawn_time": 167.880, "lane": 3},
{"spawn_time": 168.280, "lane": 2},
{"spawn_time": 168.630, "lane": 1},
{"spawn_time": 168.930, "lane": 2},
{"spawn_time": 169.180, "lane": 2},
{"spawn_time": 169.530, "lane": 1},
{"spawn_time": 169.530, "lane": 3},
{"spawn_time": 169.830, "lane": 1},
{"spawn_time": 170.130, "lane": 1},
{"spawn_time": 170.380, "lane": 2},
{"spawn_time": 170.780, "lane": 3},
{"spawn_time": 171.180, "lane": 3},
{"spawn_time": 171.530, "lane": 4},
{"spawn_time": 171.780, "lane": 4},
{"spawn_time": 172.130, "lane": 2},
{"spawn_time": 172.130, "lane": 4},
{"spawn_time": 172.480, "lane": 2},
{"spawn_time": 172.480, "lane": 3},
{"spawn_time": 172.880, "lane": 2},
{"spawn_time": 173.130, "lane": 3},
{"spawn_time": 173.530, "lane": 4},
{"spawn_time": 173.780, "lane": 4},
{"spawn_time": 174.080, "lane": 3},
{"spawn_time": 174.380, "lane": 2},
{"spawn_time": 174.730, "lane": 1},
{"spawn_time": 175.030, "lane": 2},
{"spawn_time": 175.430, "lane": 2},
{"spawn_time": 175.730, "lane": 3},
{"spawn_time": 176.080, "lane": 3},
{"spawn_time": 176.080, "lane": 4},
{"spawn_time": 176.430, "lane": 3},
{"spawn_time": 176.780, "lane": 3},
{"spawn_time": 177.180, "lane": 3},
{"spawn_time": 177.180, "lane": 4},
{"spawn_time": 177.480, "lane": 3},
{"spawn_time": 177.780, "lane": 2},
{"spawn_time": 178.180, "lane": 2},
{"spawn_time": 178.430, "lane": 1},
{"spawn_time": 178.780, "lane": 2},
{"spawn_time": 179.030, "lane": 2},
{"spawn_time": 179.280, "lane": 2},
{"spawn_time": 179.580, "lane": 1},
{"spawn_time": 179.980, "lane": 1},
{"spawn_time": 179.980, "lane": 2},
{"spawn_time": 180.280, "lane": 1},
{"spawn_time": 180.530, "lane": 2},
{"spawn_time": 180.830, "lane": 1},
{"spawn_time": 181.130, "lane": 2},
{"spawn_time": 181.130, "lane": 3},
{"spawn_time": 181.430, "lane": 3},
{"spawn_time": 181.730, "lane": 2},
{"spawn_time": 182.130, "lane": 3},
{"spawn_time": 182.480, "lane": 3},
{"spawn_time": 182.780, "lane": 4},
{"spawn_time": 183.180, "lane": 4},
{"spawn_time": 183.480, "lane": 3},
{"spawn_time": 183.700, "lane": 2},
{"spawn_time": 183.700, "lane": 3},
{"spawn_time": 183.920, "lane": 4},
{"spawn_time": 184.170, "lane": 1},
{"spawn_time": 184.170, "lane": 4},
{"spawn_time": 184.350, "lane": 4},
{"spawn_time": 184.600, "lane": 1},
{"spawn_time": 184.600, "lane": 4},
{"spawn_time": 184.820, "lane": 4},
{"spawn_time": 185.120, "lane": 3},
{"spawn_time": 185.420, "lane": 2},
{"spawn_time": 185.670, "lane": 2},
{"spawn_time": 185.850, "lane": 1},
{"spawn_time": 186.100, "lane": 1},
{"spawn_time": 186.350, "lane": 2},
{"spawn_time": 186.600, "lane": 3},
{"spawn_time": 186.820, "lane": 1},
{"spawn_time": 186.820, "lane": 2},
{"spawn_time": 187.000, "lane": 3},
{"spawn_time": 187.220, "lane": 2},
{"spawn_time": 187.520, "lane": 2},
{"spawn_time": 187.740, "lane": 3},
{"spawn_time": 187.960, "lane": 2},
{"spawn_time": 187.960, "lane": 3},
{"spawn_time": 188.260, "lane": 3},
{"spawn_time": 188.440, "lane": 3},
{"spawn_time": 188.660, "lane": 2},
{"spawn_time": 188.910, "lane": 1},
{"spawn_time": 189.130, "lane": 1},
{"spawn_time": 189.380, "lane": 2},
{"spawn_time": 189.560, "lane": 3},
{"spawn_time": 189.740, "lane": 2},
{"spawn_time": 189.990, "lane": 2},
{"spawn_time": 190.170, "lane": 3},
{"spawn_time": 190.350, "lane": 2},
{"spawn_time": 190.350, "lane": 4},
{"spawn_time": 190.600, "lane": 1},
{"spawn_time": 190.850, "lane": 2},
{"spawn_time": 191.150, "lane": 1},
{"spawn_time": 191.370, "lane": 1},
{"spawn_time": 191.670, "lane": 1},
{"spawn_time": 191.850, "lane": 1},
{"spawn_time": 192.100, "lane": 1},
{"spawn_time": 192.100, "lane": 4},
{"spawn_time": 192.400, "lane": 1},
{"spawn_time": 192.620, "lane": 1},
{"spawn_time": 192.800, "lane": 2},
{"spawn_time": 193.050, "lane": 3},
{"spawn_time": 193.350, "lane": 4},
{"spawn_time": 193.570, "lane": 4},
{"spawn_time": 193.820, "lane": 3},
{"spawn_time": 193.820, "lane": 4},
{"spawn_time": 194.000, "lane": 4},
{"spawn_time": 194.220, "lane": 3},
{"spawn_time": 194.400, "lane": 3},
{"spawn_time": 194.650, "lane": 2},
{"spawn_time": 194.950, "lane": 2},
{"spawn_time": 194.950, "lane": 3},
{"spawn_time": 195.200, "lane": 3},
{"spawn_time": 195.500, "lane": 2},
{"spawn_time": 195.680, "lane": 2},
{"spawn_time": 195.980, "lane": 1},
{"spawn_time": 196.200, "lane": 1},
{"spawn_time": 196.500, "lane": 1},
{"spawn_time": 196.720, "lane": 2},
{"spawn_time": 196.900, "lane": 2},
{"spawn_time": 197.200, "lane": 3},
{"spawn_time": 197.380, "lane": 4},
{"spawn_time": 197.630, "lane": 3},
{"spawn_time": 197.880, "lane": 2},
{"spawn_time": 198.060, "lane": 2},
{"spawn_time": 198.060, "lane": 3},
{"spawn_time": 198.360, "lane": 2},
{"spawn_time": 198.660, "lane": 3},
{"spawn_time": 198.910, "lane": 2},
{"spawn_time": 199.130, "lane": 1},
{"spawn_time": 199.430, "lane": 1},
{"spawn_time": 199.680, "lane": 1},
{"spawn_time": 199.930, "lane": 1},
{"spawn_time": 200.150, "lane": 1},
{"spawn_time": 200.330, "lane": 2},
{"spawn_time": 200.330, "lane": 4},
{"spawn_time": 200.550, "lane": 3},
{"spawn_time": 200.800, "lane": 4},
{"spawn_time": 201.020, "lane": 4},
{"spawn_time": 201.200, "lane": 4},
{"spawn_time": 201.500, "lane": 2},
{"spawn_time": 201.500, "lane": 4},
{"spawn_time": 201.800, "lane": 4},
{"spawn_time": 201.980, "lane": 3},
{"spawn_time": 202.230, "lane": 2},
{"spawn_time": 202.450, "lane": 1},
{"spawn_time": 202.630, "lane": 1},
{"spawn_time": 202.880, "lane": 1},
{"spawn_time": 203.100, "lane": 1},
{"spawn_time": 203.350, "lane": 1},
{"spawn_time": 203.600, "lane": 2},
{"spawn_time": 203.780, "lane": 1},
{"spawn_time": 204.000, "lane": 1},
{"spawn_time": 204.000, "lane": 2},
{"spawn_time": 204.250, "lane": 1},
{"spawn_time": 204.430, "lane": 1},
{"spawn_time": 204.680, "lane": 2},
{"spawn_time": 204.980, "lane": 3},
{"spawn_time": 205.280, "lane": 4},
{"spawn_time": 205.530, "lane": 4},
{"spawn_time": 205.830, "lane": 3},
{"spawn_time": 206.010, "lane": 4},
{"spawn_time": 206.310, "lane": 4},
{"spawn_time": 206.530, "lane": 4},
{"spawn_time": 206.780, "lane": 4},
{"spawn_time": 207.000, "lane": 4},
{"spawn_time": 207.180, "lane": 4},
{"spawn_time": 207.360, "lane": 2},
{"spawn_time": 207.360, "lane": 3},
{"spawn_time": 207.580, "lane": 2},
{"spawn_time": 207.880, "lane": 2},
{"spawn_time": 208.100, "lane": 1},
{"spawn_time": 208.350, "lane": 2},
{"spawn_time": 208.650, "lane": 2},
{"spawn_time": 208.650, "lane": 3},
{"spawn_time": 208.900, "lane": 2},
{"spawn_time": 209.200, "lane": 1},
{"spawn_time": 209.200, "lane": 3},
{"spawn_time": 209.450, "lane": 1},
{"spawn_time": 209.750, "lane": 2},
{"spawn_time": 209.930, "lane": 2},
{"spawn_time": 210.180, "lane": 1},
{"spawn_time": 210.430, "lane": 1},
{"spawn_time": 210.650, "lane": 2},
{"spawn_time": 210.830, "lane": 3},
{"spawn_time": 211.080, "lane": 2},
{"spawn_time": 211.260, "lane": 2},
{"spawn_time": 211.560, "lane": 3},
{"spawn_time": 211.810, "lane": 2},
{"spawn_time": 212.030, "lane": 1},
{"spawn_time": 212.030, "lane": 3},
{"spawn_time": 212.330, "lane": 3},
{"spawn_time": 212.550, "lane": 2},
{"spawn_time": 212.850, "lane": 2},
{"spawn_time": 213.070, "lane": 1},
{"spawn_time": 213.570, "lane": 1},
{"spawn_time": 214.170, "lane": 2},
{"spawn_time": 214.770, "lane": 3},
{"spawn_time": 215.370, "lane": 3},
{"spawn_time": 215.770, "lane": 4},
{"spawn_time": 216.170, "lane": 3},
{"spawn_time": 216.770, "lane": 4},
{"spawn_time": 217.270, "lane": 3},
{"spawn_time": 217.870, "lane": 4},
{"spawn_time": 218.270, "lane": 4},
{"spawn_time": 218.870, "lane": 3},
{"spawn_time": 218.870, "lane": 4},
{"spawn_time": 219.470, "lane": 2},
{"spawn_time": 219.470, "lane": 3},
{"spawn_time": 219.870, "lane": 1},
{"spawn_time": 220.370, "lane": 2},
{"spawn_time": 220.770, "lane": 3},
{"spawn_time": 221.370, "lane": 2},
{"spawn_time": 221.970, "lane": 1},
{"spawn_time": 222.570, "lane": 2},
{"spawn_time": 223.170, "lane": 1},
{"spawn_time": 223.670, "lane": 1},
{"spawn_time": 224.270, "lane": 1},
{"spawn_time": 224.870, "lane": 1},
{"spawn_time": 225.270, "lane": 1},
{"spawn_time": 225.770, "lane": 1},
{"spawn_time": 226.270, "lane": 2},
{"spawn_time": 226.870, "lane": 3},
{"spawn_time": 227.370, "lane": 3},
{"spawn_time": 227.970, "lane": 4},
{"spawn_time": 228.570, "lane": 4},
{"spawn_time": 229.070, "lane": 3},
{"spawn_time": 229.070, "lane": 4},
{"spawn_time": 229.470, "lane": 4},
{"spawn_time": 229.870, "lane": 4},
{"spawn_time": 230.470, "lane": 3},
{"spawn_time": 230.870, "lane": 4},
{"spawn_time": 231.370, "lane": 3},
{"spawn_time": 231.770, "lane": 2},
{"spawn_time": 232.370, "lane": 3},
{"spawn_time": 232.970, "lane": 2},
{"spawn_time": 232.970, "lane": 3},
{"spawn_time": 233.370, "lane": 1},
{"spawn_time": 233.370, "lane": 3},
{"spawn_time": 233.970, "lane": 4},
{"spawn_time": 234.370, "lane": 4},
{"spawn_time": 234.770, "lane": 4},
{"spawn_time": 235.270, "lane": 4},
{"spawn_time": 235.770, "lane": 3},
{"spawn_time": 236.170, "lane": 4},
{"spawn_time": 236.570, "lane": 3},
{"spawn_time": 236.970, "lane": 2},
{"spawn_time": 237.370, "lane": 3},
{"spawn_time": 237.870, "lane": 3},
{"spawn_time": 238.470, "lane": 3},
{"spawn_time": 238.870, "lane": 3},
{"spawn_time": 239.270, "lane": 4},
{"spawn_time": 239.870, "lane": 4},
{"spawn_time": 240.270, "lane": 3},
{"spawn_time": 240.670, "lane": 4},
{"spawn_time": 241.270, "lane": 2},
{"spawn_time": 241.270, "lane": 3},
{"spawn_time": 241.870, "lane": 4},
{"spawn_time": 242.370, "lane": 3},
{"spawn_time": 242.770, "lane": 4},
{"spawn_time": 243.370, "lane": 3},
{"spawn_time": 243.970, "lane": 2},
{"spawn_time": 244.420, "lane": 2},
{"spawn_time": 245.120, "lane": 2},
{"spawn_time": 245.570, "lane": 2},
{"spawn_time": 246.270, "lane": 3},
{"spawn_time": 246.870, "lane": 3},
{"spawn_time": 247.320, "lane": 2},
{"spawn_time": 247.820, "lane": 2},
{"spawn_time": 248.520, "lane": 1},
{"spawn_time": 249.120, "lane": 1},
{"spawn_time": 249.720, "lane": 1},
{"spawn_time": 250.220, "lane": 2},
{"spawn_time": 250.920, "lane": 3},
{"spawn_time": 251.620, "lane": 2},
{"spawn_time": 252.120, "lane": 3},
{"spawn_time": 252.570, "lane": 2},
{"spawn_time": 253.170, "lane": 1},
{"spawn_time": 253.620, "lane": 2},
{"spawn_time": 254.120, "lane": 2},
{"spawn_time": 254.620, "lane": 1},
]
#endregion


#these arrays track all notes spawned within their respective lanes.
#a pipeline of notes basically.
var lane_1_notes: Array[Node2D] = []
var lane_2_notes: Array[Node2D] = []
var lane_3_notes: Array[Node2D] = []
var lane_4_notes: Array[Node2D] = []


func _ready() -> void:
	selected_song = GlobalTrackManager.selected_song
	if selected_song != null:
		audio_stream.stream = selected_song
		audio_stream.play() 


func _process(_delta: float) -> void:
	score_text.text = "Score: " + str(score)
	if audio_stream.is_playing():
		current_time = audio_stream.get_playback_position()
		
		for i in range(shine_as_usual_chart.size() - 1, -1, -1):
			var note_data = shine_as_usual_chart[i]
			
			if current_time >= note_data["spawn_time"]:
				_spawn_note_in_lane(note_data["lane"], note_data["spawn_time"])
				shine_as_usual_chart.remove_at(i)
		_move_active_notes()
	if audio_stream.is_playing():
		current_time = audio_stream.get_playback_position()

		_remove_missed_notes(lane_1_notes)
		_remove_missed_notes(lane_2_notes)
		_remove_missed_notes(lane_3_notes)
		_remove_missed_notes(lane_4_notes)

		# existing spawn code...


func _spawn_note_in_lane(lane_num: int, spawn_time: float):
	var new_note = NOTE_TEMPLATE.instantiate()
	var color_rect = new_note.get_node("ColorRect")
	
	#color notes
	if lane_num == 1:
		color_rect.color = Color.from_string("#ff9ee8", Color.HOT_PINK) #2nd param is backup if  color loading fails
	elif lane_num == 2:
		color_rect.color = Color.from_string("#fff700", Color.YELLOW)
	elif lane_num == 3:
		color_rect.color = Color.from_string("#00318c", Color.NAVY_BLUE)
	elif lane_num == 4:
		color_rect.color = Color.from_string("#ff6159", Color.LIGHT_CORAL)
		
	var receiver = playfield.get_node("HitZone/Lane" + str(lane_num) + "_Receiver")
	new_note.global_position.x = receiver.global_position.x
	
	
	var time_passed_since_spawn = current_time - spawn_time
	var extra_distance = time_passed_since_spawn * note_speed
	
	new_note.global_position.y = SPAWN_Y + extra_distance
	
	new_note.hit_time = spawn_time + travel_time #When it's due at RECEPTOR_Y
	new_note.note_speed = note_speed
	new_note.receptor_y = RECEPTOR_Y 
	
	playfield.add_child(new_note)
	
	if lane_num == 1: lane_1_notes.append(new_note)
	elif lane_num == 2: lane_2_notes.append(new_note)
	elif lane_num == 3: lane_3_notes.append(new_note)
	elif lane_num == 4: lane_4_notes.append(new_note)


func _move_active_notes() -> void: #moves the notes... pretty explainitory.
	var all_live_notes = lane_1_notes + lane_2_notes + lane_3_notes + lane_4_notes
	
	for note in all_live_notes:
		if is_instance_valid(note):
			#NOTE so uh what this does is finds the time remaining and distance, then it just updates pos
			var time_remaining = note.hit_time - current_time
			var distance_from_receptor = time_remaining * note.note_speed
			note.global_position.y = note.receptor_y - distance_from_receptor
		else:
			lane_1_notes.erase(note)
			lane_2_notes.erase(note)
			lane_3_notes.erase(note)
			lane_4_notes.erase(note)
func _remove_missed_notes(lane_notes: Array):
	while lane_notes.size() > 0:
		var note = lane_notes[0]

		if !is_instance_valid(note):
			lane_notes.pop_front()
			continue

		if current_time > note.hit_time + 0.30:
			score-=5
			note.queue_free()
			lane_notes.pop_front()
		else:
			break

func _input(event: InputEvent) -> void:
	if audio_stream.is_playing() and event is InputEventKey and event.pressed and not event.echo:
		
		var active_lane_notes: Array[Node2D] = []
		var spawn_position: Vector2 = Vector2.ZERO
		var pressed_valid_lane: bool = false
		
		if event.physical_keycode == KEY_D: 
			active_lane_notes = lane_1_notes
			var node = get_node_or_null("Playfield/HitZone/Lane1_Receiver")
			if node:
				spawn_position = node.global_position
				pressed_valid_lane = true
		elif event.physical_keycode == KEY_F:
			active_lane_notes = lane_2_notes
			var node = get_node_or_null("Playfield/HitZone/Lane2_Receiver")
			if node:
				spawn_position = node.global_position
				pressed_valid_lane = true
		elif event.physical_keycode == KEY_J:
			active_lane_notes = lane_3_notes
			var node = get_node_or_null("Playfield/HitZone/Lane3_Receiver")
			if node:
				spawn_position = node.global_position
				pressed_valid_lane = true
		elif event.physical_keycode == KEY_K:
			active_lane_notes = lane_4_notes
			var node = get_node_or_null("Playfield/HitZone/Lane4_Receiver")
			if node:
				spawn_position = node.global_position
				pressed_valid_lane = true
		
		var current_fx: GPUParticles2D = null
		
		if pressed_valid_lane:
			current_fx = particle_scene.instantiate() as GPUParticles2D
			get_tree().current_scene.add_child(current_fx)
			current_fx.global_position = spawn_position
			current_fx.finished.connect(current_fx.queue_free)
			current_fx.emitting = true
		
		if active_lane_notes.size() > 0:
			var target_note = active_lane_notes[0] 
			
			if is_instance_valid(target_note) and current_fx != null:
				var user_hit_time = audio_stream.get_playback_position()
				var note_hit_time = target_note.hit_time 
				
				var timing_discrepancy = abs(user_hit_time - note_hit_time)
				
				if timing_discrepancy <= 0.03:
					score += 5
					current_fx.process_material.color = Color.GREEN
					print(score)
				elif timing_discrepancy <= 0.09:
					score += 3
					current_fx.process_material.color = Color.DEEP_SKY_BLUE
					print(score)
				elif timing_discrepancy <= 0.18:
					score += 1
					current_fx.process_material.color = Color.RED
					print(score)
				elif timing_discrepancy <= 0.30:
					current_fx.process_material.color = Color.GRAY
					print(score)
				else:
					score -= 1
					current_fx.process_material.color = Color.DARK_RED
					print(score)
				
				active_lane_notes.pop_front() #erases index 0, shifting upcoming notes up
				target_note.queue_free()      #deletes the visual node from the screen
	
