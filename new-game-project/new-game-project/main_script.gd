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
  {
	"spawn_time": 4.075,
	"lane": 1
  },
  {
	"spawn_time": 4.085,
	"lane": 2
  },
  {
	"spawn_time": 4.352,
	"lane": 3
  },
  {
	"spawn_time": 4.554,
	"lane": 4
  },
  {
	"spawn_time": 4.757,
	"lane": 1
  },
  {
	"spawn_time": 5.067,
	"lane": 2
  },
  {
	"spawn_time": 5.291,
	"lane": 3
  },
  {
	"spawn_time": 5.515,
	"lane": 4
  },
  {
	"spawn_time": 5.525,
	"lane": 1
  },
  {
	"spawn_time": 5.696,
	"lane": 2
  },
  {
	"spawn_time": 5.856,
	"lane": 3
  },
  {
	"spawn_time": 6.165,
	"lane": 4
  },
  {
	"spawn_time": 6.187,
	"lane": 1
  },
  {
	"spawn_time": 6.347,
	"lane": 2
  },
  {
	"spawn_time": 6.496,
	"lane": 3
  },
  {
	"spawn_time": 6.742,
	"lane": 4
  },
  {
	"spawn_time": 6.987,
	"lane": 1
  },
  {
	"spawn_time": 6.997,
	"lane": 2
  },
  {
	"spawn_time": 7.136,
	"lane": 3
  },
  {
	"spawn_time": 7.37,
	"lane": 4
  },
  {
	"spawn_time": 7.605,
	"lane": 1
  },
  {
	"spawn_time": 7.616,
	"lane": 2
  },
  {
	"spawn_time": 7.93,
	"lane": 3
  },
  {
	"spawn_time": 8.245,
	"lane": 4
  },
  {
	"spawn_time": 8.554,
	"lane": 1
  },
  {
	"spawn_time": 8.864,
	"lane": 2
  },
  {
	"spawn_time": 8.875,
	"lane": 3
  },
  {
	"spawn_time": 9.043,
	"lane": 4
  },
  {
	"spawn_time": 9.211,
	"lane": 1
  },
  {
	"spawn_time": 9.379,
	"lane": 2
  },
  {
	"spawn_time": 9.547,
	"lane": 3
  },
  {
	"spawn_time": 9.851,
	"lane": 4
  },
  {
	"spawn_time": 10.155,
	"lane": 1
  },
  {
	"spawn_time": 10.176,
	"lane": 2
  },
  {
	"spawn_time": 10.502,
	"lane": 3
  },
  {
	"spawn_time": 10.827,
	"lane": 4
  },
  {
	"spawn_time": 11.125,
	"lane": 1
  },
  {
	"spawn_time": 11.424,
	"lane": 2
  },
  {
	"spawn_time": 11.594,
	"lane": 3
  },
  {
	"spawn_time": 11.765,
	"lane": 4
  },
  {
	"spawn_time": 12.096,
	"lane": 1
  },
  {
	"spawn_time": 12.107,
	"lane": 2
  },
  {
	"spawn_time": 12.427,
	"lane": 3
  },
  {
	"spawn_time": 12.747,
	"lane": 4
  },
  {
	"spawn_time": 13.029,
	"lane": 1
  },
  {
	"spawn_time": 13.312,
	"lane": 2
  },
  {
	"spawn_time": 13.59,
	"lane": 3
  },
  {
	"spawn_time": 13.867,
	"lane": 4
  },
  {
	"spawn_time": 13.877,
	"lane": 1
  },
  {
	"spawn_time": 13.941,
	"lane": 2
  },
  {
	"spawn_time": 14.037,
	"lane": 3
  },
  {
	"spawn_time": 14.347,
	"lane": 4
  },
  {
	"spawn_time": 14.357,
	"lane": 1
  },
  {
	"spawn_time": 14.64,
	"lane": 2
  },
  {
	"spawn_time": 14.923,
	"lane": 3
  },
  {
	"spawn_time": 15.2,
	"lane": 4
  },
  {
	"spawn_time": 15.477,
	"lane": 1
  },
  {
	"spawn_time": 15.797,
	"lane": 2
  },
  {
	"spawn_time": 15.968,
	"lane": 3
  },
  {
	"spawn_time": 16.288,
	"lane": 4
  },
  {
	"spawn_time": 16.608,
	"lane": 1
  },
  {
	"spawn_time": 16.768,
	"lane": 2
  },
  {
	"spawn_time": 17.014,
	"lane": 3
  },
  {
	"spawn_time": 17.259,
	"lane": 4
  },
  {
	"spawn_time": 17.494,
	"lane": 1
  },
  {
	"spawn_time": 17.728,
	"lane": 2
  },
  {
	"spawn_time": 17.877,
	"lane": 3
  },
  {
	"spawn_time": 17.888,
	"lane": 4
  },
  {
	"spawn_time": 18.048,
	"lane": 1
  },
  {
	"spawn_time": 18.294,
	"lane": 2
  },
  {
	"spawn_time": 18.539,
	"lane": 3
  },
  {
	"spawn_time": 18.854,
	"lane": 4
  },
  {
	"spawn_time": 19.168,
	"lane": 1
  },
  {
	"spawn_time": 19.488,
	"lane": 2
  },
  {
	"spawn_time": 19.819,
	"lane": 3
  },
  {
	"spawn_time": 20.048,
	"lane": 4
  },
  {
	"spawn_time": 20.277,
	"lane": 1
  },
  {
	"spawn_time": 20.448,
	"lane": 2
  },
  {
	"spawn_time": 20.619,
	"lane": 3
  },
  {
	"spawn_time": 20.859,
	"lane": 4
  },
  {
	"spawn_time": 21.099,
	"lane": 1
  },
  {
	"spawn_time": 21.269,
	"lane": 2
  },
  {
	"spawn_time": 21.504,
	"lane": 3
  },
  {
	"spawn_time": 21.739,
	"lane": 4
  },
  {
	"spawn_time": 22.059,
	"lane": 1
  },
  {
	"spawn_time": 22.368,
	"lane": 2
  },
  {
	"spawn_time": 22.688,
	"lane": 3
  },
  {
	"spawn_time": 22.699,
	"lane": 4
  },
  {
	"spawn_time": 22.848,
	"lane": 1
  },
  {
	"spawn_time": 23.094,
	"lane": 2
  },
  {
	"spawn_time": 23.339,
	"lane": 3
  },
  {
	"spawn_time": 23.659,
	"lane": 4
  },
  {
	"spawn_time": 23.989,
	"lane": 1
  },
  {
	"spawn_time": 24.309,
	"lane": 2
  },
  {
	"spawn_time": 24.64,
	"lane": 3
  },
  {
	"spawn_time": 24.95,
	"lane": 4
  },
  {
	"spawn_time": 25.259,
	"lane": 1
  },
  {
	"spawn_time": 25.269,
	"lane": 2
  },
  {
	"spawn_time": 25.6,
	"lane": 3
  },
  {
	"spawn_time": 25.909,
	"lane": 4
  },
  {
	"spawn_time": 26.08,
	"lane": 1
  },
  {
	"spawn_time": 26.251,
	"lane": 2
  },
  {
	"spawn_time": 26.528,
	"lane": 3
  },
  {
	"spawn_time": 26.539,
	"lane": 4
  },
  {
	"spawn_time": 26.71,
	"lane": 1
  },
  {
	"spawn_time": 26.88,
	"lane": 2
  },
  {
	"spawn_time": 27.179,
	"lane": 3
  },
  {
	"spawn_time": 27.189,
	"lane": 4
  },
  {
	"spawn_time": 27.509,
	"lane": 1
  },
  {
	"spawn_time": 27.669,
	"lane": 2
  },
  {
	"spawn_time": 27.84,
	"lane": 3
  },
  {
	"spawn_time": 28.16,
	"lane": 4
  },
  {
	"spawn_time": 28.48,
	"lane": 1
  },
  {
	"spawn_time": 28.491,
	"lane": 2
  },
  {
	"spawn_time": 28.8,
	"lane": 3
  },
  {
	"spawn_time": 29.12,
	"lane": 4
  },
  {
	"spawn_time": 29.451,
	"lane": 1
  },
  {
	"spawn_time": 29.771,
	"lane": 2
  },
  {
	"spawn_time": 30.08,
	"lane": 3
  },
  {
	"spawn_time": 30.4,
	"lane": 4
  },
  {
	"spawn_time": 30.709,
	"lane": 1
  },
  {
	"spawn_time": 31.04,
	"lane": 2
  },
  {
	"spawn_time": 31.051,
	"lane": 3
  },
  {
	"spawn_time": 31.371,
	"lane": 4
  },
  {
	"spawn_time": 31.691,
	"lane": 1
  },
  {
	"spawn_time": 32.011,
	"lane": 2
  },
  {
	"spawn_time": 32.288,
	"lane": 3
  },
  {
	"spawn_time": 32.309,
	"lane": 4
  },
  {
	"spawn_time": 32.48,
	"lane": 1
  },
  {
	"spawn_time": 32.651,
	"lane": 2
  },
  {
	"spawn_time": 32.971,
	"lane": 3
  },
  {
	"spawn_time": 32.981,
	"lane": 4
  },
  {
	"spawn_time": 33.269,
	"lane": 1
  },
  {
	"spawn_time": 33.44,
	"lane": 2
  },
  {
	"spawn_time": 33.611,
	"lane": 3
  },
  {
	"spawn_time": 33.941,
	"lane": 4
  },
  {
	"spawn_time": 34.251,
	"lane": 1
  },
  {
	"spawn_time": 34.576,
	"lane": 2
  },
  {
	"spawn_time": 34.901,
	"lane": 3
  },
  {
	"spawn_time": 35.221,
	"lane": 4
  },
  {
	"spawn_time": 35.541,
	"lane": 1
  },
  {
	"spawn_time": 35.861,
	"lane": 2
  },
  {
	"spawn_time": 36.181,
	"lane": 3
  },
  {
	"spawn_time": 36.496,
	"lane": 4
  },
  {
	"spawn_time": 36.811,
	"lane": 1
  },
  {
	"spawn_time": 36.982,
	"lane": 2
  },
  {
	"spawn_time": 37.152,
	"lane": 3
  },
  {
	"spawn_time": 37.451,
	"lane": 4
  },
  {
	"spawn_time": 37.461,
	"lane": 1
  },
  {
	"spawn_time": 37.792,
	"lane": 2
  },
  {
	"spawn_time": 37.952,
	"lane": 3
  },
  {
	"spawn_time": 38.112,
	"lane": 4
  },
  {
	"spawn_time": 38.427,
	"lane": 1
  },
  {
	"spawn_time": 38.741,
	"lane": 2
  },
  {
	"spawn_time": 38.752,
	"lane": 3
  },
  {
	"spawn_time": 39.072,
	"lane": 4
  },
  {
	"spawn_time": 39.381,
	"lane": 1
  },
  {
	"spawn_time": 39.392,
	"lane": 2
  },
  {
	"spawn_time": 39.723,
	"lane": 3
  },
  {
	"spawn_time": 40.053,
	"lane": 4
  },
  {
	"spawn_time": 40.362,
	"lane": 1
  },
  {
	"spawn_time": 40.672,
	"lane": 2
  },
  {
	"spawn_time": 40.992,
	"lane": 3
  },
  {
	"spawn_time": 41.312,
	"lane": 4
  },
  {
	"spawn_time": 41.626,
	"lane": 1
  },
  {
	"spawn_time": 41.941,
	"lane": 2
  },
  {
	"spawn_time": 42.229,
	"lane": 3
  },
  {
	"spawn_time": 42.56,
	"lane": 4
  },
  {
	"spawn_time": 42.571,
	"lane": 1
  },
  {
	"spawn_time": 42.739,
	"lane": 2
  },
  {
	"spawn_time": 42.907,
	"lane": 3
  },
  {
	"spawn_time": 43.075,
	"lane": 4
  },
  {
	"spawn_time": 43.243,
	"lane": 1
  },
  {
	"spawn_time": 43.552,
	"lane": 2
  },
  {
	"spawn_time": 43.883,
	"lane": 3
  },
  {
	"spawn_time": 44.059,
	"lane": 4
  },
  {
	"spawn_time": 44.235,
	"lane": 1
  },
  {
	"spawn_time": 44.512,
	"lane": 2
  },
  {
	"spawn_time": 44.523,
	"lane": 3
  },
  {
	"spawn_time": 44.694,
	"lane": 4
  },
  {
	"spawn_time": 44.864,
	"lane": 1
  },
  {
	"spawn_time": 45.152,
	"lane": 2
  },
  {
	"spawn_time": 45.44,
	"lane": 3
  },
  {
	"spawn_time": 45.728,
	"lane": 4
  },
  {
	"spawn_time": 45.994,
	"lane": 1
  },
  {
	"spawn_time": 46.261,
	"lane": 2
  },
  {
	"spawn_time": 46.517,
	"lane": 3
  },
  {
	"spawn_time": 46.773,
	"lane": 4
  },
  {
	"spawn_time": 46.784,
	"lane": 1
  },
  {
	"spawn_time": 47.094,
	"lane": 2
  },
  {
	"spawn_time": 47.403,
	"lane": 3
  },
  {
	"spawn_time": 47.413,
	"lane": 4
  },
  {
	"spawn_time": 47.733,
	"lane": 1
  },
  {
	"spawn_time": 48.053,
	"lane": 2
  },
  {
	"spawn_time": 48.368,
	"lane": 3
  },
  {
	"spawn_time": 48.683,
	"lane": 4
  },
  {
	"spawn_time": 49.008,
	"lane": 1
  },
  {
	"spawn_time": 49.333,
	"lane": 2
  },
  {
	"spawn_time": 49.648,
	"lane": 3
  },
  {
	"spawn_time": 49.963,
	"lane": 4
  },
  {
	"spawn_time": 50.288,
	"lane": 1
  },
  {
	"spawn_time": 50.613,
	"lane": 2
  },
  {
	"spawn_time": 50.933,
	"lane": 3
  },
  {
	"spawn_time": 51.253,
	"lane": 4
  },
  {
	"spawn_time": 51.264,
	"lane": 1
  },
  {
	"spawn_time": 51.424,
	"lane": 2
  },
  {
	"spawn_time": 51.664,
	"lane": 3
  },
  {
	"spawn_time": 51.904,
	"lane": 4
  },
  {
	"spawn_time": 52.224,
	"lane": 1
  },
  {
	"spawn_time": 52.544,
	"lane": 2
  },
  {
	"spawn_time": 52.555,
	"lane": 3
  },
  {
	"spawn_time": 52.875,
	"lane": 4
  },
  {
	"spawn_time": 53.195,
	"lane": 1
  },
  {
	"spawn_time": 53.494,
	"lane": 2
  },
  {
	"spawn_time": 53.792,
	"lane": 3
  },
  {
	"spawn_time": 53.963,
	"lane": 4
  },
  {
	"spawn_time": 54.134,
	"lane": 1
  },
  {
	"spawn_time": 54.305,
	"lane": 2
  },
  {
	"spawn_time": 54.475,
	"lane": 3
  },
  {
	"spawn_time": 54.784,
	"lane": 4
  },
  {
	"spawn_time": 55.093,
	"lane": 1
  },
  {
	"spawn_time": 55.104,
	"lane": 2
  },
  {
	"spawn_time": 55.283,
	"lane": 3
  },
  {
	"spawn_time": 55.462,
	"lane": 4
  },
  {
	"spawn_time": 55.64,
	"lane": 1
  },
  {
	"spawn_time": 55.819,
	"lane": 2
  },
  {
	"spawn_time": 56.011,
	"lane": 3
  },
  {
	"spawn_time": 56.203,
	"lane": 4
  },
  {
	"spawn_time": 56.395,
	"lane": 1
  },
  {
	"spawn_time": 56.587,
	"lane": 2
  },
  {
	"spawn_time": 56.782,
	"lane": 3
  },
  {
	"spawn_time": 56.976,
	"lane": 4
  },
  {
	"spawn_time": 57.171,
	"lane": 1
  },
  {
	"spawn_time": 57.365,
	"lane": 2
  },
  {
	"spawn_time": 57.376,
	"lane": 3
  },
  {
	"spawn_time": 57.686,
	"lane": 4
  },
  {
	"spawn_time": 57.995,
	"lane": 1
  },
  {
	"spawn_time": 58.326,
	"lane": 2
  },
  {
	"spawn_time": 58.656,
	"lane": 3
  },
  {
	"spawn_time": 58.976,
	"lane": 4
  },
  {
	"spawn_time": 59.296,
	"lane": 1
  },
  {
	"spawn_time": 59.606,
	"lane": 2
  },
  {
	"spawn_time": 59.915,
	"lane": 3
  },
  {
	"spawn_time": 60.235,
	"lane": 4
  },
  {
	"spawn_time": 60.555,
	"lane": 1
  },
  {
	"spawn_time": 60.875,
	"lane": 2
  },
  {
	"spawn_time": 61.195,
	"lane": 3
  },
  {
	"spawn_time": 61.205,
	"lane": 4
  },
  {
	"spawn_time": 61.525,
	"lane": 1
  },
  {
	"spawn_time": 61.845,
	"lane": 2
  },
  {
	"spawn_time": 62.165,
	"lane": 3
  },
  {
	"spawn_time": 62.485,
	"lane": 4
  },
  {
	"spawn_time": 62.746,
	"lane": 1
  },
  {
	"spawn_time": 63.008,
	"lane": 2
  },
  {
	"spawn_time": 63.238,
	"lane": 3
  },
  {
	"spawn_time": 63.467,
	"lane": 4
  },
  {
	"spawn_time": 63.765,
	"lane": 1
  },
  {
	"spawn_time": 64.064,
	"lane": 2
  },
  {
	"spawn_time": 64.085,
	"lane": 3
  },
  {
	"spawn_time": 64.096,
	"lane": 4
  },
  {
	"spawn_time": 64.416,
	"lane": 1
  },
  {
	"spawn_time": 64.715,
	"lane": 2
  },
  {
	"spawn_time": 64.725,
	"lane": 3
  },
  {
	"spawn_time": 65.05,
	"lane": 4
  },
  {
	"spawn_time": 65.376,
	"lane": 1
  },
  {
	"spawn_time": 65.69,
	"lane": 2
  },
  {
	"spawn_time": 66.005,
	"lane": 3
  },
  {
	"spawn_time": 66.016,
	"lane": 4
  },
  {
	"spawn_time": 66.33,
	"lane": 1
  },
  {
	"spawn_time": 66.645,
	"lane": 2
  },
  {
	"spawn_time": 66.656,
	"lane": 3
  },
  {
	"spawn_time": 66.982,
	"lane": 4
  },
  {
	"spawn_time": 67.307,
	"lane": 1
  },
  {
	"spawn_time": 67.616,
	"lane": 2
  },
  {
	"spawn_time": 67.947,
	"lane": 3
  },
  {
	"spawn_time": 68.187,
	"lane": 4
  },
  {
	"spawn_time": 68.427,
	"lane": 1
  },
  {
	"spawn_time": 68.576,
	"lane": 2
  },
  {
	"spawn_time": 68.587,
	"lane": 3
  },
  {
	"spawn_time": 68.747,
	"lane": 4
  },
  {
	"spawn_time": 68.987,
	"lane": 1
  },
  {
	"spawn_time": 69.227,
	"lane": 2
  },
  {
	"spawn_time": 69.557,
	"lane": 3
  },
  {
	"spawn_time": 69.877,
	"lane": 4
  },
  {
	"spawn_time": 70.197,
	"lane": 1
  },
  {
	"spawn_time": 70.517,
	"lane": 2
  },
  {
	"spawn_time": 70.837,
	"lane": 3
  },
  {
	"spawn_time": 71.157,
	"lane": 4
  },
  {
	"spawn_time": 71.472,
	"lane": 1
  },
  {
	"spawn_time": 71.787,
	"lane": 2
  },
  {
	"spawn_time": 72.118,
	"lane": 3
  },
  {
	"spawn_time": 72.448,
	"lane": 4
  },
  {
	"spawn_time": 72.757,
	"lane": 1
  },
  {
	"spawn_time": 73.077,
	"lane": 2
  },
  {
	"spawn_time": 73.408,
	"lane": 3
  },
  {
	"spawn_time": 73.739,
	"lane": 4
  },
  {
	"spawn_time": 74.059,
	"lane": 1
  },
  {
	"spawn_time": 74.336,
	"lane": 2
  },
  {
	"spawn_time": 74.368,
	"lane": 3
  },
  {
	"spawn_time": 74.698,
	"lane": 4
  },
  {
	"spawn_time": 75.029,
	"lane": 1
  },
  {
	"spawn_time": 75.349,
	"lane": 2
  },
  {
	"spawn_time": 75.669,
	"lane": 3
  },
  {
	"spawn_time": 75.984,
	"lane": 4
  },
  {
	"spawn_time": 76.299,
	"lane": 1
  },
  {
	"spawn_time": 76.619,
	"lane": 2
  },
  {
	"spawn_time": 76.907,
	"lane": 3
  },
  {
	"spawn_time": 77.088,
	"lane": 4
  },
  {
	"spawn_time": 77.333,
	"lane": 1
  },
  {
	"spawn_time": 77.579,
	"lane": 2
  },
  {
	"spawn_time": 77.904,
	"lane": 3
  },
  {
	"spawn_time": 78.229,
	"lane": 4
  },
  {
	"spawn_time": 78.554,
	"lane": 1
  },
  {
	"spawn_time": 78.88,
	"lane": 2
  },
  {
	"spawn_time": 79.194,
	"lane": 3
  },
  {
	"spawn_time": 79.509,
	"lane": 4
  },
  {
	"spawn_time": 79.824,
	"lane": 1
  },
  {
	"spawn_time": 80.139,
	"lane": 2
  },
  {
	"spawn_time": 80.149,
	"lane": 3
  },
  {
	"spawn_time": 80.464,
	"lane": 4
  },
  {
	"spawn_time": 80.779,
	"lane": 1
  },
  {
	"spawn_time": 81.099,
	"lane": 2
  },
  {
	"spawn_time": 81.419,
	"lane": 3
  },
  {
	"spawn_time": 81.744,
	"lane": 4
  },
  {
	"spawn_time": 82.069,
	"lane": 1
  },
  {
	"spawn_time": 82.394,
	"lane": 2
  },
  {
	"spawn_time": 82.72,
	"lane": 3
  },
  {
	"spawn_time": 83.035,
	"lane": 4
  },
  {
	"spawn_time": 83.349,
	"lane": 1
  },
  {
	"spawn_time": 83.632,
	"lane": 2
  },
  {
	"spawn_time": 83.915,
	"lane": 3
  },
  {
	"spawn_time": 84.192,
	"lane": 4
  },
  {
	"spawn_time": 84.469,
	"lane": 1
  },
  {
	"spawn_time": 84.48,
	"lane": 2
  },
  {
	"spawn_time": 84.789,
	"lane": 3
  },
  {
	"spawn_time": 85.12,
	"lane": 4
  },
  {
	"spawn_time": 85.354,
	"lane": 1
  },
  {
	"spawn_time": 85.589,
	"lane": 2
  },
  {
	"spawn_time": 85.76,
	"lane": 3
  },
  {
	"spawn_time": 86.0,
	"lane": 4
  },
  {
	"spawn_time": 86.24,
	"lane": 1
  },
  {
	"spawn_time": 86.4,
	"lane": 2
  },
  {
	"spawn_time": 86.64,
	"lane": 3
  },
  {
	"spawn_time": 86.88,
	"lane": 4
  },
  {
	"spawn_time": 87.04,
	"lane": 1
  },
  {
	"spawn_time": 87.36,
	"lane": 2
  },
  {
	"spawn_time": 87.68,
	"lane": 3
  },
  {
	"spawn_time": 87.84,
	"lane": 4
  },
  {
	"spawn_time": 88.074,
	"lane": 1
  },
  {
	"spawn_time": 88.309,
	"lane": 2
  },
  {
	"spawn_time": 88.32,
	"lane": 3
  },
  {
	"spawn_time": 88.566,
	"lane": 4
  },
  {
	"spawn_time": 88.811,
	"lane": 1
  },
  {
	"spawn_time": 89.099,
	"lane": 2
  },
  {
	"spawn_time": 89.387,
	"lane": 3
  },
  {
	"spawn_time": 89.67,
	"lane": 4
  },
  {
	"spawn_time": 89.952,
	"lane": 1
  },
  {
	"spawn_time": 90.262,
	"lane": 2
  },
  {
	"spawn_time": 90.571,
	"lane": 3
  },
  {
	"spawn_time": 90.891,
	"lane": 4
  },
  {
	"spawn_time": 91.211,
	"lane": 1
  },
  {
	"spawn_time": 91.536,
	"lane": 2
  },
  {
	"spawn_time": 91.861,
	"lane": 3
  },
  {
	"spawn_time": 92.176,
	"lane": 4
  },
  {
	"spawn_time": 92.491,
	"lane": 1
  },
  {
	"spawn_time": 92.501,
	"lane": 2
  },
  {
	"spawn_time": 92.81,
	"lane": 3
  },
  {
	"spawn_time": 93.12,
	"lane": 4
  },
  {
	"spawn_time": 93.37,
	"lane": 1
  },
  {
	"spawn_time": 93.621,
	"lane": 2
  },
  {
	"spawn_time": 93.92,
	"lane": 3
  },
  {
	"spawn_time": 94.09,
	"lane": 4
  },
  {
	"spawn_time": 94.261,
	"lane": 1
  },
  {
	"spawn_time": 94.581,
	"lane": 2
  },
  {
	"spawn_time": 94.901,
	"lane": 3
  },
  {
	"spawn_time": 95.13,
	"lane": 4
  },
  {
	"spawn_time": 95.36,
	"lane": 1
  },
  {
	"spawn_time": 95.541,
	"lane": 2
  },
  {
	"spawn_time": 95.701,
	"lane": 3
  },
  {
	"spawn_time": 96.0,
	"lane": 4
  },
  {
	"spawn_time": 96.16,
	"lane": 1
  },
  {
	"spawn_time": 96.171,
	"lane": 2
  },
  {
	"spawn_time": 96.309,
	"lane": 3
  },
  {
	"spawn_time": 96.501,
	"lane": 4
  },
  {
	"spawn_time": 96.811,
	"lane": 1
  },
  {
	"spawn_time": 97.126,
	"lane": 2
  },
  {
	"spawn_time": 97.44,
	"lane": 3
  },
  {
	"spawn_time": 97.451,
	"lane": 4
  },
  {
	"spawn_time": 97.781,
	"lane": 1
  },
  {
	"spawn_time": 98.112,
	"lane": 2
  },
  {
	"spawn_time": 98.432,
	"lane": 3
  },
  {
	"spawn_time": 98.709,
	"lane": 4
  },
  {
	"spawn_time": 98.901,
	"lane": 1
  },
  {
	"spawn_time": 99.221,
	"lane": 2
  },
  {
	"spawn_time": 99.541,
	"lane": 3
  },
  {
	"spawn_time": 99.552,
	"lane": 4
  },
  {
	"spawn_time": 99.776,
	"lane": 1
  },
  {
	"spawn_time": 100.0,
	"lane": 2
  },
  {
	"spawn_time": 100.16,
	"lane": 3
  },
  {
	"spawn_time": 100.171,
	"lane": 4
  },
  {
	"spawn_time": 100.363,
	"lane": 1
  },
  {
	"spawn_time": 100.592,
	"lane": 2
  },
  {
	"spawn_time": 100.821,
	"lane": 3
  },
  {
	"spawn_time": 100.997,
	"lane": 4
  },
  {
	"spawn_time": 101.173,
	"lane": 1
  },
  {
	"spawn_time": 101.483,
	"lane": 2
  },
  {
	"spawn_time": 101.643,
	"lane": 3
  },
  {
	"spawn_time": 101.84,
	"lane": 4
  },
  {
	"spawn_time": 102.037,
	"lane": 1
  },
  {
	"spawn_time": 102.234,
	"lane": 2
  },
  {
	"spawn_time": 102.432,
	"lane": 3
  },
  {
	"spawn_time": 102.592,
	"lane": 4
  },
  {
	"spawn_time": 102.603,
	"lane": 1
  },
  {
	"spawn_time": 102.843,
	"lane": 2
  },
  {
	"spawn_time": 103.083,
	"lane": 3
  },
  {
	"spawn_time": 103.243,
	"lane": 4
  },
  {
	"spawn_time": 103.483,
	"lane": 1
  },
  {
	"spawn_time": 103.723,
	"lane": 2
  },
  {
	"spawn_time": 103.883,
	"lane": 3
  },
  {
	"spawn_time": 104.203,
	"lane": 4
  },
  {
	"spawn_time": 104.523,
	"lane": 1
  },
  {
	"spawn_time": 104.843,
	"lane": 2
  },
  {
	"spawn_time": 105.163,
	"lane": 3
  },
  {
	"spawn_time": 105.392,
	"lane": 4
  },
  {
	"spawn_time": 105.621,
	"lane": 1
  },
  {
	"spawn_time": 105.803,
	"lane": 2
  },
  {
	"spawn_time": 105.813,
	"lane": 3
  },
  {
	"spawn_time": 106.133,
	"lane": 4
  },
  {
	"spawn_time": 106.453,
	"lane": 1
  },
  {
	"spawn_time": 106.613,
	"lane": 2
  },
  {
	"spawn_time": 106.848,
	"lane": 3
  },
  {
	"spawn_time": 107.083,
	"lane": 4
  },
  {
	"spawn_time": 107.403,
	"lane": 1
  },
  {
	"spawn_time": 107.723,
	"lane": 2
  },
  {
	"spawn_time": 107.733,
	"lane": 3
  },
  {
	"spawn_time": 108.064,
	"lane": 4
  },
  {
	"spawn_time": 108.373,
	"lane": 1
  },
  {
	"spawn_time": 108.693,
	"lane": 2
  },
  {
	"spawn_time": 109.013,
	"lane": 3
  },
  {
	"spawn_time": 109.173,
	"lane": 4
  },
  {
	"spawn_time": 109.333,
	"lane": 1
  },
  {
	"spawn_time": 109.653,
	"lane": 2
  },
  {
	"spawn_time": 109.984,
	"lane": 3
  },
  {
	"spawn_time": 110.144,
	"lane": 4
  },
  {
	"spawn_time": 110.304,
	"lane": 1
  },
  {
	"spawn_time": 110.581,
	"lane": 2
  },
  {
	"spawn_time": 110.757,
	"lane": 3
  },
  {
	"spawn_time": 110.933,
	"lane": 4
  },
  {
	"spawn_time": 111.179,
	"lane": 1
  },
  {
	"spawn_time": 111.424,
	"lane": 2
  },
  {
	"spawn_time": 111.658,
	"lane": 3
  },
  {
	"spawn_time": 111.893,
	"lane": 4
  },
  {
	"spawn_time": 111.904,
	"lane": 1
  },
  {
	"spawn_time": 112.203,
	"lane": 2
  },
  {
	"spawn_time": 112.533,
	"lane": 3
  },
  {
	"spawn_time": 112.864,
	"lane": 4
  },
  {
	"spawn_time": 113.184,
	"lane": 1
  },
  {
	"spawn_time": 113.504,
	"lane": 2
  },
  {
	"spawn_time": 113.813,
	"lane": 3
  },
  {
	"spawn_time": 113.984,
	"lane": 4
  },
  {
	"spawn_time": 114.155,
	"lane": 1
  },
  {
	"spawn_time": 114.464,
	"lane": 2
  },
  {
	"spawn_time": 114.79,
	"lane": 3
  },
  {
	"spawn_time": 115.115,
	"lane": 4
  },
  {
	"spawn_time": 115.435,
	"lane": 1
  },
  {
	"spawn_time": 115.755,
	"lane": 2
  },
  {
	"spawn_time": 116.064,
	"lane": 3
  },
  {
	"spawn_time": 116.373,
	"lane": 4
  },
  {
	"spawn_time": 116.384,
	"lane": 1
  },
  {
	"spawn_time": 116.554,
	"lane": 2
  },
  {
	"spawn_time": 116.725,
	"lane": 3
  },
  {
	"spawn_time": 117.035,
	"lane": 4
  },
  {
	"spawn_time": 117.355,
	"lane": 1
  },
  {
	"spawn_time": 117.525,
	"lane": 2
  },
  {
	"spawn_time": 117.685,
	"lane": 3
  },
  {
	"spawn_time": 118.011,
	"lane": 4
  },
  {
	"spawn_time": 118.336,
	"lane": 1
  },
  {
	"spawn_time": 118.485,
	"lane": 2
  },
  {
	"spawn_time": 118.72,
	"lane": 3
  },
  {
	"spawn_time": 118.955,
	"lane": 4
  },
  {
	"spawn_time": 118.965,
	"lane": 1
  },
  {
	"spawn_time": 119.275,
	"lane": 2
  },
  {
	"spawn_time": 119.605,
	"lane": 3
  },
  {
	"spawn_time": 119.851,
	"lane": 4
  },
  {
	"spawn_time": 120.096,
	"lane": 1
  },
  {
	"spawn_time": 120.245,
	"lane": 2
  },
  {
	"spawn_time": 120.533,
	"lane": 3
  },
  {
	"spawn_time": 120.72,
	"lane": 4
  },
  {
	"spawn_time": 120.907,
	"lane": 1
  },
  {
	"spawn_time": 121.216,
	"lane": 2
  },
  {
	"spawn_time": 121.525,
	"lane": 3
  },
  {
	"spawn_time": 121.845,
	"lane": 4
  },
  {
	"spawn_time": 122.165,
	"lane": 1
  },
  {
	"spawn_time": 122.485,
	"lane": 2
  },
  {
	"spawn_time": 122.805,
	"lane": 3
  },
  {
	"spawn_time": 123.115,
	"lane": 4
  },
  {
	"spawn_time": 123.286,
	"lane": 1
  },
  {
	"spawn_time": 123.456,
	"lane": 2
  },
  {
	"spawn_time": 123.76,
	"lane": 3
  },
  {
	"spawn_time": 124.064,
	"lane": 4
  },
  {
	"spawn_time": 124.085,
	"lane": 1
  },
  {
	"spawn_time": 124.253,
	"lane": 2
  },
  {
	"spawn_time": 124.421,
	"lane": 3
  },
  {
	"spawn_time": 124.589,
	"lane": 4
  },
  {
	"spawn_time": 124.757,
	"lane": 1
  },
  {
	"spawn_time": 125.066,
	"lane": 2
  },
  {
	"spawn_time": 125.376,
	"lane": 3
  },
  {
	"spawn_time": 125.544,
	"lane": 4
  },
  {
	"spawn_time": 125.712,
	"lane": 1
  },
  {
	"spawn_time": 125.88,
	"lane": 2
  },
  {
	"spawn_time": 126.048,
	"lane": 3
  },
  {
	"spawn_time": 126.358,
	"lane": 4
  },
  {
	"spawn_time": 126.667,
	"lane": 1
  },
  {
	"spawn_time": 126.982,
	"lane": 2
  },
  {
	"spawn_time": 127.296,
	"lane": 3
  },
  {
	"spawn_time": 127.307,
	"lane": 4
  },
  {
	"spawn_time": 127.616,
	"lane": 1
  },
  {
	"spawn_time": 127.947,
	"lane": 2
  },
  {
	"spawn_time": 128.256,
	"lane": 3
  },
  {
	"spawn_time": 128.426,
	"lane": 4
  },
  {
	"spawn_time": 128.597,
	"lane": 1
  },
  {
	"spawn_time": 128.912,
	"lane": 2
  },
  {
	"spawn_time": 129.227,
	"lane": 3
  },
  {
	"spawn_time": 129.237,
	"lane": 4
  },
  {
	"spawn_time": 129.557,
	"lane": 1
  },
  {
	"spawn_time": 129.888,
	"lane": 2
  },
  {
	"spawn_time": 130.202,
	"lane": 3
  },
  {
	"spawn_time": 130.517,
	"lane": 4
  },
  {
	"spawn_time": 130.832,
	"lane": 1
  },
  {
	"spawn_time": 131.147,
	"lane": 2
  },
  {
	"spawn_time": 131.435,
	"lane": 3
  },
  {
	"spawn_time": 131.723,
	"lane": 4
  },
  {
	"spawn_time": 131.915,
	"lane": 1
  },
  {
	"spawn_time": 132.107,
	"lane": 2
  },
  {
	"spawn_time": 132.437,
	"lane": 3
  },
  {
	"spawn_time": 132.757,
	"lane": 4
  },
  {
	"spawn_time": 133.077,
	"lane": 1
  },
  {
	"spawn_time": 133.386,
	"lane": 2
  },
  {
	"spawn_time": 133.696,
	"lane": 3
  },
  {
	"spawn_time": 134.026,
	"lane": 4
  },
  {
	"spawn_time": 134.357,
	"lane": 1
  },
  {
	"spawn_time": 134.666,
	"lane": 2
  },
  {
	"spawn_time": 134.976,
	"lane": 3
  },
  {
	"spawn_time": 134.987,
	"lane": 4
  },
  {
	"spawn_time": 135.232,
	"lane": 1
  },
  {
	"spawn_time": 135.477,
	"lane": 2
  },
  {
	"spawn_time": 135.722,
	"lane": 3
  },
  {
	"spawn_time": 135.968,
	"lane": 4
  },
  {
	"spawn_time": 135.979,
	"lane": 1
  },
  {
	"spawn_time": 136.267,
	"lane": 2
  },
  {
	"spawn_time": 136.597,
	"lane": 3
  },
  {
	"spawn_time": 136.608,
	"lane": 4
  },
  {
	"spawn_time": 136.922,
	"lane": 1
  },
  {
	"spawn_time": 137.237,
	"lane": 2
  },
  {
	"spawn_time": 137.557,
	"lane": 3
  },
  {
	"spawn_time": 137.877,
	"lane": 4
  },
  {
	"spawn_time": 137.888,
	"lane": 1
  },
  {
	"spawn_time": 138.202,
	"lane": 2
  },
  {
	"spawn_time": 138.517,
	"lane": 3
  },
  {
	"spawn_time": 138.528,
	"lane": 4
  },
  {
	"spawn_time": 138.854,
	"lane": 1
  },
  {
	"spawn_time": 139.179,
	"lane": 2
  },
  {
	"spawn_time": 139.499,
	"lane": 3
  },
  {
	"spawn_time": 139.819,
	"lane": 4
  },
  {
	"spawn_time": 140.128,
	"lane": 1
  },
  {
	"spawn_time": 140.459,
	"lane": 2
  },
  {
	"spawn_time": 140.774,
	"lane": 3
  },
  {
	"spawn_time": 141.088,
	"lane": 4
  },
  {
	"spawn_time": 141.099,
	"lane": 1
  },
  {
	"spawn_time": 141.419,
	"lane": 2
  },
  {
	"spawn_time": 141.739,
	"lane": 3
  },
  {
	"spawn_time": 142.059,
	"lane": 4
  },
  {
	"spawn_time": 142.389,
	"lane": 1
  },
  {
	"spawn_time": 142.709,
	"lane": 2
  },
  {
	"spawn_time": 143.029,
	"lane": 3
  },
  {
	"spawn_time": 143.2,
	"lane": 4
  },
  {
	"spawn_time": 143.43,
	"lane": 1
  },
  {
	"spawn_time": 143.659,
	"lane": 2
  },
  {
	"spawn_time": 143.808,
	"lane": 3
  },
  {
	"spawn_time": 143.989,
	"lane": 4
  },
  {
	"spawn_time": 144.309,
	"lane": 1
  },
  {
	"spawn_time": 144.629,
	"lane": 2
  },
  {
	"spawn_time": 144.853,
	"lane": 3
  },
  {
	"spawn_time": 144.949,
	"lane": 4
  },
  {
	"spawn_time": 145.168,
	"lane": 1
  },
  {
	"spawn_time": 145.387,
	"lane": 2
  },
  {
	"spawn_time": 145.654,
	"lane": 3
  },
  {
	"spawn_time": 145.92,
	"lane": 4
  },
  {
	"spawn_time": 146.24,
	"lane": 1
  },
  {
	"spawn_time": 146.56,
	"lane": 2
  },
  {
	"spawn_time": 146.88,
	"lane": 3
  },
  {
	"spawn_time": 147.2,
	"lane": 4
  },
  {
	"spawn_time": 147.514,
	"lane": 1
  },
  {
	"spawn_time": 147.829,
	"lane": 2
  },
  {
	"spawn_time": 147.84,
	"lane": 3
  },
  {
	"spawn_time": 148.16,
	"lane": 4
  },
  {
	"spawn_time": 148.48,
	"lane": 1
  },
  {
	"spawn_time": 148.72,
	"lane": 2
  },
  {
	"spawn_time": 148.96,
	"lane": 3
  },
  {
	"spawn_time": 149.131,
	"lane": 4
  },
  {
	"spawn_time": 149.44,
	"lane": 1
  },
  {
	"spawn_time": 149.749,
	"lane": 2
  },
  {
	"spawn_time": 150.08,
	"lane": 3
  },
  {
	"spawn_time": 150.411,
	"lane": 4
  },
  {
	"spawn_time": 150.736,
	"lane": 1
  },
  {
	"spawn_time": 151.061,
	"lane": 2
  },
  {
	"spawn_time": 151.381,
	"lane": 3
  },
  {
	"spawn_time": 151.701,
	"lane": 4
  },
  {
	"spawn_time": 152.021,
	"lane": 1
  },
  {
	"spawn_time": 152.341,
	"lane": 2
  },
  {
	"spawn_time": 152.651,
	"lane": 3
  },
  {
	"spawn_time": 152.971,
	"lane": 4
  },
  {
	"spawn_time": 153.296,
	"lane": 1
  },
  {
	"spawn_time": 153.621,
	"lane": 2
  },
  {
	"spawn_time": 153.941,
	"lane": 3
  },
  {
	"spawn_time": 154.261,
	"lane": 4
  },
  {
	"spawn_time": 154.581,
	"lane": 1
  },
  {
	"spawn_time": 154.901,
	"lane": 2
  },
  {
	"spawn_time": 155.211,
	"lane": 3
  },
  {
	"spawn_time": 155.531,
	"lane": 4
  },
  {
	"spawn_time": 155.856,
	"lane": 1
  },
  {
	"spawn_time": 156.181,
	"lane": 2
  },
  {
	"spawn_time": 156.507,
	"lane": 3
  },
  {
	"spawn_time": 156.832,
	"lane": 4
  },
  {
	"spawn_time": 157.152,
	"lane": 1
  },
  {
	"spawn_time": 157.472,
	"lane": 2
  },
  {
	"spawn_time": 157.792,
	"lane": 3
  },
  {
	"spawn_time": 158.112,
	"lane": 4
  },
  {
	"spawn_time": 158.432,
	"lane": 1
  },
  {
	"spawn_time": 158.752,
	"lane": 2
  },
  {
	"spawn_time": 159.078,
	"lane": 3
  },
  {
	"spawn_time": 159.403,
	"lane": 4
  },
  {
	"spawn_time": 159.723,
	"lane": 1
  },
  {
	"spawn_time": 160.043,
	"lane": 2
  },
  {
	"spawn_time": 160.363,
	"lane": 3
  },
  {
	"spawn_time": 160.683,
	"lane": 4
  },
  {
	"spawn_time": 161.014,
	"lane": 1
  },
  {
	"spawn_time": 161.344,
	"lane": 2
  },
  {
	"spawn_time": 161.664,
	"lane": 3
  },
  {
	"spawn_time": 161.984,
	"lane": 4
  },
  {
	"spawn_time": 162.224,
	"lane": 1
  },
  {
	"spawn_time": 162.464,
	"lane": 2
  },
  {
	"spawn_time": 162.624,
	"lane": 3
  },
  {
	"spawn_time": 162.923,
	"lane": 4
  },
  {
	"spawn_time": 163.243,
	"lane": 1
  },
  {
	"spawn_time": 163.552,
	"lane": 2
  },
  {
	"spawn_time": 163.723,
	"lane": 3
  },
  {
	"spawn_time": 163.893,
	"lane": 4
  },
  {
	"spawn_time": 164.053,
	"lane": 1
  },
  {
	"spawn_time": 164.235,
	"lane": 2
  },
  {
	"spawn_time": 164.533,
	"lane": 3
  },
  {
	"spawn_time": 164.853,
	"lane": 4
  },
  {
	"spawn_time": 165.163,
	"lane": 1
  },
  {
	"spawn_time": 165.173,
	"lane": 2
  },
  {
	"spawn_time": 165.333,
	"lane": 3
  },
  {
	"spawn_time": 165.483,
	"lane": 4
  },
  {
	"spawn_time": 165.653,
	"lane": 1
  },
  {
	"spawn_time": 165.813,
	"lane": 2
  },
  {
	"spawn_time": 166.123,
	"lane": 3
  },
  {
	"spawn_time": 166.443,
	"lane": 4
  },
  {
	"spawn_time": 166.688,
	"lane": 1
  },
  {
	"spawn_time": 166.933,
	"lane": 2
  },
  {
	"spawn_time": 167.072,
	"lane": 3
  },
  {
	"spawn_time": 167.253,
	"lane": 4
  },
  {
	"spawn_time": 167.413,
	"lane": 1
  },
  {
	"spawn_time": 167.723,
	"lane": 2
  },
  {
	"spawn_time": 168.048,
	"lane": 3
  },
  {
	"spawn_time": 168.373,
	"lane": 4
  },
  {
	"spawn_time": 168.693,
	"lane": 1
  },
  {
	"spawn_time": 168.864,
	"lane": 2
  },
  {
	"spawn_time": 169.035,
	"lane": 3
  },
  {
	"spawn_time": 169.349,
	"lane": 4
  },
  {
	"spawn_time": 169.664,
	"lane": 1
  },
  {
	"spawn_time": 169.99,
	"lane": 2
  },
  {
	"spawn_time": 170.315,
	"lane": 3
  },
  {
	"spawn_time": 170.635,
	"lane": 4
  },
  {
	"spawn_time": 170.955,
	"lane": 1
  },
  {
	"spawn_time": 171.27,
	"lane": 2
  },
  {
	"spawn_time": 171.584,
	"lane": 3
  },
  {
	"spawn_time": 171.914,
	"lane": 4
  },
  {
	"spawn_time": 172.245,
	"lane": 1
  },
  {
	"spawn_time": 172.57,
	"lane": 2
  },
  {
	"spawn_time": 172.896,
	"lane": 3
  },
  {
	"spawn_time": 173.205,
	"lane": 4
  },
  {
	"spawn_time": 173.515,
	"lane": 1
  },
  {
	"spawn_time": 173.83,
	"lane": 2
  },
  {
	"spawn_time": 174.144,
	"lane": 3
  },
  {
	"spawn_time": 174.474,
	"lane": 4
  },
  {
	"spawn_time": 174.805,
	"lane": 1
  },
  {
	"spawn_time": 175.12,
	"lane": 2
  },
  {
	"spawn_time": 175.435,
	"lane": 3
  },
  {
	"spawn_time": 175.755,
	"lane": 4
  },
  {
	"spawn_time": 176.075,
	"lane": 1
  },
  {
	"spawn_time": 176.4,
	"lane": 2
  },
  {
	"spawn_time": 176.725,
	"lane": 3
  },
  {
	"spawn_time": 177.045,
	"lane": 4
  },
  {
	"spawn_time": 177.365,
	"lane": 1
  },
  {
	"spawn_time": 177.685,
	"lane": 2
  },
  {
	"spawn_time": 178.005,
	"lane": 3
  },
  {
	"spawn_time": 178.336,
	"lane": 4
  },
  {
	"spawn_time": 178.667,
	"lane": 1
  },
  {
	"spawn_time": 178.981,
	"lane": 2
  },
  {
	"spawn_time": 179.296,
	"lane": 3
  },
  {
	"spawn_time": 179.616,
	"lane": 4
  },
  {
	"spawn_time": 179.936,
	"lane": 1
  },
  {
	"spawn_time": 180.256,
	"lane": 2
  },
  {
	"spawn_time": 180.576,
	"lane": 3
  },
  {
	"spawn_time": 180.896,
	"lane": 4
  },
  {
	"spawn_time": 181.216,
	"lane": 1
  },
  {
	"spawn_time": 181.536,
	"lane": 2
  },
  {
	"spawn_time": 181.856,
	"lane": 3
  },
  {
	"spawn_time": 182.176,
	"lane": 4
  },
  {
	"spawn_time": 182.496,
	"lane": 1
  },
  {
	"spawn_time": 182.822,
	"lane": 2
  },
  {
	"spawn_time": 183.147,
	"lane": 3
  },
  {
	"spawn_time": 183.467,
	"lane": 4
  },
  {
	"spawn_time": 183.787,
	"lane": 1
  },
  {
	"spawn_time": 184.102,
	"lane": 2
  },
  {
	"spawn_time": 184.416,
	"lane": 3
  },
  {
	"spawn_time": 184.736,
	"lane": 4
  },
  {
	"spawn_time": 185.056,
	"lane": 1
  },
  {
	"spawn_time": 185.382,
	"lane": 2
  },
  {
	"spawn_time": 185.707,
	"lane": 3
  },
  {
	"spawn_time": 186.032,
	"lane": 4
  },
  {
	"spawn_time": 186.357,
	"lane": 1
  },
  {
	"spawn_time": 186.672,
	"lane": 2
  },
  {
	"spawn_time": 186.987,
	"lane": 3
  },
  {
	"spawn_time": 187.302,
	"lane": 4
  },
  {
	"spawn_time": 187.616,
	"lane": 1
  },
  {
	"spawn_time": 187.914,
	"lane": 2
  },
  {
	"spawn_time": 188.213,
	"lane": 3
  },
  {
	"spawn_time": 188.517,
	"lane": 4
  },
  {
	"spawn_time": 188.821,
	"lane": 1
  },
  {
	"spawn_time": 189.125,
	"lane": 2
  },
  {
	"spawn_time": 189.429,
	"lane": 3
  },
  {
	"spawn_time": 189.733,
	"lane": 4
  },
  {
	"spawn_time": 190.037,
	"lane": 1
  },
  {
	"spawn_time": 190.229,
	"lane": 2
  },
  {
	"spawn_time": 190.421,
	"lane": 3
  },
  {
	"spawn_time": 190.528,
	"lane": 4
  },
  {
	"spawn_time": 190.859,
	"lane": 1
  },
  {
	"spawn_time": 191.168,
	"lane": 2
  },
  {
	"spawn_time": 191.483,
	"lane": 3
  },
  {
	"spawn_time": 191.797,
	"lane": 4
  },
  {
	"spawn_time": 192.011,
	"lane": 1
  },
  {
	"spawn_time": 192.219,
	"lane": 2
  },
  {
	"spawn_time": 192.427,
	"lane": 3
  },
  {
	"spawn_time": 192.757,
	"lane": 4
  },
  {
	"spawn_time": 193.077,
	"lane": 1
  },
  {
	"spawn_time": 193.088,
	"lane": 2
  },
  {
	"spawn_time": 193.387,
	"lane": 3
  },
  {
	"spawn_time": 193.574,
	"lane": 4
  },
  {
	"spawn_time": 193.76,
	"lane": 1
  },
  {
	"spawn_time": 193.909,
	"lane": 2
  },
  {
	"spawn_time": 194.144,
	"lane": 3
  },
  {
	"spawn_time": 194.379,
	"lane": 4
  },
  {
	"spawn_time": 194.656,
	"lane": 1
  },
  {
	"spawn_time": 194.826,
	"lane": 2
  },
  {
	"spawn_time": 194.997,
	"lane": 3
  },
  {
	"spawn_time": 195.008,
	"lane": 4
  },
  {
	"spawn_time": 195.307,
	"lane": 1
  },
  {
	"spawn_time": 195.637,
	"lane": 2
  },
  {
	"spawn_time": 195.968,
	"lane": 3
  },
  {
	"spawn_time": 196.288,
	"lane": 4
  },
  {
	"spawn_time": 196.608,
	"lane": 1
  },
  {
	"spawn_time": 196.736,
	"lane": 2
  },
  {
	"spawn_time": 196.939,
	"lane": 3
  },
  {
	"spawn_time": 197.248,
	"lane": 4
  },
  {
	"spawn_time": 197.557,
	"lane": 1
  },
  {
	"spawn_time": 197.568,
	"lane": 2
  },
  {
	"spawn_time": 197.888,
	"lane": 3
  },
  {
	"spawn_time": 198.069,
	"lane": 4
  },
  {
	"spawn_time": 198.187,
	"lane": 1
  },
  {
	"spawn_time": 198.197,
	"lane": 2
  },
  {
	"spawn_time": 198.528,
	"lane": 3
  },
  {
	"spawn_time": 198.859,
	"lane": 4
  },
  {
	"spawn_time": 199.184,
	"lane": 1
  },
  {
	"spawn_time": 199.509,
	"lane": 2
  },
  {
	"spawn_time": 199.824,
	"lane": 3
  },
  {
	"spawn_time": 200.139,
	"lane": 4
  },
  {
	"spawn_time": 200.448,
	"lane": 1
  },
  {
	"spawn_time": 200.63,
	"lane": 2
  },
  {
	"spawn_time": 200.811,
	"lane": 3
  },
  {
	"spawn_time": 201.147,
	"lane": 4
  },
  {
	"spawn_time": 201.315,
	"lane": 1
  },
  {
	"spawn_time": 201.483,
	"lane": 2
  },
  {
	"spawn_time": 201.782,
	"lane": 3
  },
  {
	"spawn_time": 202.08,
	"lane": 4
  },
  {
	"spawn_time": 202.229,
	"lane": 1
  },
  {
	"spawn_time": 202.549,
	"lane": 2
  },
  {
	"spawn_time": 202.709,
	"lane": 3
  },
  {
	"spawn_time": 203.019,
	"lane": 4
  },
  {
	"spawn_time": 203.328,
	"lane": 1
  },
  {
	"spawn_time": 203.339,
	"lane": 2
  },
  {
	"spawn_time": 203.664,
	"lane": 3
  },
  {
	"spawn_time": 203.989,
	"lane": 4
  },
  {
	"spawn_time": 204.309,
	"lane": 1
  },
  {
	"spawn_time": 204.629,
	"lane": 2
  },
  {
	"spawn_time": 204.928,
	"lane": 3
  },
  {
	"spawn_time": 205.227,
	"lane": 4
  },
  {
	"spawn_time": 205.563,
	"lane": 1
  },
  {
	"spawn_time": 205.731,
	"lane": 2
  },
  {
	"spawn_time": 205.899,
	"lane": 3
  },
  {
	"spawn_time": 205.909,
	"lane": 4
  },
  {
	"spawn_time": 206.224,
	"lane": 1
  },
  {
	"spawn_time": 206.539,
	"lane": 2
  },
  {
	"spawn_time": 206.811,
	"lane": 3
  },
  {
	"spawn_time": 207.083,
	"lane": 4
  },
  {
	"spawn_time": 207.344,
	"lane": 1
  },
  {
	"spawn_time": 207.605,
	"lane": 2
  },
  {
	"spawn_time": 207.888,
	"lane": 3
  },
  {
	"spawn_time": 208.171,
	"lane": 4
  },
  {
	"spawn_time": 208.48,
	"lane": 1
  },
  {
	"spawn_time": 208.789,
	"lane": 2
  },
  {
	"spawn_time": 209.098,
	"lane": 3
  },
  {
	"spawn_time": 209.408,
	"lane": 4
  },
  {
	"spawn_time": 209.738,
	"lane": 1
  },
  {
	"spawn_time": 210.069,
	"lane": 2
  },
  {
	"spawn_time": 210.08,
	"lane": 3
  },
  {
	"spawn_time": 210.4,
	"lane": 4
  },
  {
	"spawn_time": 210.72,
	"lane": 1
  },
  {
	"spawn_time": 211.046,
	"lane": 2
  },
  {
	"spawn_time": 211.371,
	"lane": 3
  },
  {
	"spawn_time": 211.691,
	"lane": 4
  },
  {
	"spawn_time": 212.011,
	"lane": 1
  },
  {
	"spawn_time": 212.331,
	"lane": 2
  },
  {
	"spawn_time": 212.651,
	"lane": 3
  },
  {
	"spawn_time": 212.971,
	"lane": 4
  },
  {
	"spawn_time": 213.291,
	"lane": 1
  },
  {
	"spawn_time": 213.606,
	"lane": 2
  },
  {
	"spawn_time": 213.92,
	"lane": 3
  },
  {
	"spawn_time": 214.24,
	"lane": 4
  },
  {
	"spawn_time": 214.56,
	"lane": 1
  },
  {
	"spawn_time": 214.89,
	"lane": 2
  },
  {
	"spawn_time": 215.221,
	"lane": 3
  },
  {
	"spawn_time": 215.546,
	"lane": 4
  },
  {
	"spawn_time": 215.872,
	"lane": 1
  },
  {
	"spawn_time": 216.198,
	"lane": 2
  },
  {
	"spawn_time": 216.523,
	"lane": 3
  },
  {
	"spawn_time": 216.718,
	"lane": 4
  },
  {
	"spawn_time": 216.912,
	"lane": 1
  },
  {
	"spawn_time": 217.106,
	"lane": 2
  },
  {
	"spawn_time": 217.301,
	"lane": 3
  },
  {
	"spawn_time": 217.501,
	"lane": 4
  },
  {
	"spawn_time": 217.701,
	"lane": 1
  },
  {
	"spawn_time": 217.901,
	"lane": 2
  },
  {
	"spawn_time": 218.101,
	"lane": 3
  },
  {
	"spawn_time": 218.112,
	"lane": 4
  },
  {
	"spawn_time": 218.336,
	"lane": 1
  },
  {
	"spawn_time": 218.544,
	"lane": 2
  },
  {
	"spawn_time": 218.752,
	"lane": 3
  },
  {
	"spawn_time": 219.078,
	"lane": 4
  },
  {
	"spawn_time": 219.403,
	"lane": 1
  },
  {
	"spawn_time": 219.718,
	"lane": 2
  },
  {
	"spawn_time": 220.032,
	"lane": 3
  },
  {
	"spawn_time": 220.358,
	"lane": 4
  },
  {
	"spawn_time": 220.683,
	"lane": 1
  },
  {
	"spawn_time": 221.003,
	"lane": 2
  },
  {
	"spawn_time": 221.323,
	"lane": 3
  },
  {
	"spawn_time": 221.643,
	"lane": 4
  },
  {
	"spawn_time": 221.963,
	"lane": 1
  },
  {
	"spawn_time": 222.198,
	"lane": 2
  },
  {
	"spawn_time": 222.432,
	"lane": 3
  },
  {
	"spawn_time": 222.592,
	"lane": 4
  },
  {
	"spawn_time": 222.918,
	"lane": 1
  },
  {
	"spawn_time": 223.243,
	"lane": 2
  },
  {
	"spawn_time": 223.563,
	"lane": 3
  },
  {
	"spawn_time": 223.883,
	"lane": 4
  },
  {
	"spawn_time": 224.208,
	"lane": 1
  },
  {
	"spawn_time": 224.533,
	"lane": 2
  },
  {
	"spawn_time": 224.843,
	"lane": 3
  },
  {
	"spawn_time": 225.173,
	"lane": 4
  },
  {
	"spawn_time": 225.493,
	"lane": 1
  },
  {
	"spawn_time": 225.813,
	"lane": 2
  },
  {
	"spawn_time": 226.133,
	"lane": 3
  },
  {
	"spawn_time": 226.453,
	"lane": 4
  },
  {
	"spawn_time": 226.773,
	"lane": 1
  },
  {
	"spawn_time": 227.093,
	"lane": 2
  },
  {
	"spawn_time": 227.424,
	"lane": 3
  },
  {
	"spawn_time": 227.744,
	"lane": 4
  },
  {
	"spawn_time": 228.064,
	"lane": 1
  },
  {
	"spawn_time": 228.373,
	"lane": 2
  },
  {
	"spawn_time": 228.533,
	"lane": 3
  },
  {
	"spawn_time": 228.704,
	"lane": 4
  },
  {
	"spawn_time": 229.003,
	"lane": 1
  },
  {
	"spawn_time": 229.334,
	"lane": 2
  },
  {
	"spawn_time": 229.664,
	"lane": 3
  },
  {
	"spawn_time": 229.984,
	"lane": 4
  },
  {
	"spawn_time": 230.304,
	"lane": 1
  },
  {
	"spawn_time": 230.618,
	"lane": 2
  },
  {
	"spawn_time": 230.933,
	"lane": 3
  },
  {
	"spawn_time": 230.944,
	"lane": 4
  },
  {
	"spawn_time": 231.264,
	"lane": 1
  },
  {
	"spawn_time": 231.584,
	"lane": 2
  },
  {
	"spawn_time": 231.91,
	"lane": 3
  },
  {
	"spawn_time": 232.235,
	"lane": 4
  },
  {
	"spawn_time": 232.555,
	"lane": 1
  },
  {
	"spawn_time": 232.875,
	"lane": 2
  },
  {
	"spawn_time": 233.195,
	"lane": 3
  },
  {
	"spawn_time": 233.515,
	"lane": 4
  },
  {
	"spawn_time": 233.83,
	"lane": 1
  },
  {
	"spawn_time": 234.144,
	"lane": 2
  },
  {
	"spawn_time": 234.469,
	"lane": 3
  },
  {
	"spawn_time": 234.795,
	"lane": 4
  },
  {
	"spawn_time": 235.115,
	"lane": 1
  },
  {
	"spawn_time": 235.435,
	"lane": 2
  },
  {
	"spawn_time": 235.76,
	"lane": 3
  },
  {
	"spawn_time": 236.085,
	"lane": 4
  },
  {
	"spawn_time": 236.256,
	"lane": 1
  },
  {
	"spawn_time": 236.405,
	"lane": 2
  },
  {
	"spawn_time": 236.576,
	"lane": 3
  },
  {
	"spawn_time": 236.725,
	"lane": 4
  },
  {
	"spawn_time": 237.045,
	"lane": 1
  },
  {
	"spawn_time": 237.365,
	"lane": 2
  },
  {
	"spawn_time": 237.68,
	"lane": 3
  },
  {
	"spawn_time": 237.995,
	"lane": 4
  },
  {
	"spawn_time": 238.32,
	"lane": 1
  },
  {
	"spawn_time": 238.645,
	"lane": 2
  },
  {
	"spawn_time": 238.965,
	"lane": 3
  },
  {
	"spawn_time": 239.285,
	"lane": 4
  },
  {
	"spawn_time": 239.6,
	"lane": 1
  },
  {
	"spawn_time": 239.915,
	"lane": 2
  },
  {
	"spawn_time": 239.925,
	"lane": 3
  },
  {
	"spawn_time": 240.17,
	"lane": 4
  },
  {
	"spawn_time": 240.416,
	"lane": 1
  },
  {
	"spawn_time": 240.662,
	"lane": 2
  },
  {
	"spawn_time": 240.907,
	"lane": 3
  },
  {
	"spawn_time": 241.216,
	"lane": 4
  },
  {
	"spawn_time": 241.525,
	"lane": 1
  },
  {
	"spawn_time": 241.536,
	"lane": 2
  },
  {
	"spawn_time": 241.835,
	"lane": 3
  },
  {
	"spawn_time": 242.011,
	"lane": 4
  },
  {
	"spawn_time": 242.187,
	"lane": 1
  },
  {
	"spawn_time": 242.502,
	"lane": 2
  },
  {
	"spawn_time": 242.816,
	"lane": 3
  },
  {
	"spawn_time": 242.827,
	"lane": 4
  },
  {
	"spawn_time": 243.04,
	"lane": 1
  },
  {
	"spawn_time": 243.253,
	"lane": 2
  },
  {
	"spawn_time": 243.445,
	"lane": 3
  },
  {
	"spawn_time": 243.456,
	"lane": 4
  },
  {
	"spawn_time": 243.605,
	"lane": 1
  },
  {
	"spawn_time": 243.883,
	"lane": 2
  },
  {
	"spawn_time": 244.096,
	"lane": 3
  },
  {
	"spawn_time": 244.41,
	"lane": 4
  },
  {
	"spawn_time": 244.725,
	"lane": 1
  },
  {
	"spawn_time": 244.736,
	"lane": 2
  },
  {
	"spawn_time": 244.896,
	"lane": 3
  },
  {
	"spawn_time": 245.13,
	"lane": 4
  },
  {
	"spawn_time": 245.365,
	"lane": 1
  },
  {
	"spawn_time": 245.376,
	"lane": 2
  }
]
#endregion
var shiawase_chart: Array[Dictionary] = [
{"spawn_time": 2.709, "lane": 1},
{"spawn_time": 2.933, "lane": 3},
{"spawn_time": 3.157, "lane": 2},
{"spawn_time": 3.163, "lane": 4},
{"spawn_time": 3.168, "lane": 3},
{"spawn_time": 3.312, "lane": 1},
{"spawn_time": 3.456, "lane": 4},
{"spawn_time": 3.541, "lane": 2},
{"spawn_time": 3.627, "lane": 1},
{"spawn_time": 3.749, "lane": 3},
{"spawn_time": 3.872, "lane": 2},
{"spawn_time": 3.973, "lane": 4},
{"spawn_time": 4.075, "lane": 3},
{"spawn_time": 4.085, "lane": 1},
{"spawn_time": 4.096, "lane": 4},
{"spawn_time": 4.101, "lane": 2},
{"spawn_time": 4.107, "lane": 1},
{"spawn_time": 4.208, "lane": 3},
{"spawn_time": 4.309, "lane": 2},
{"spawn_time": 4.411, "lane": 4},
{"spawn_time": 4.512, "lane": 3},
{"spawn_time": 4.517, "lane": 1},
{"spawn_time": 4.523, "lane": 4},
{"spawn_time": 4.635, "lane": 2},
{"spawn_time": 4.747, "lane": 1},
{"spawn_time": 4.864, "lane": 3},
{"spawn_time": 4.981, "lane": 2},
{"spawn_time": 5.205, "lane": 4},
{"spawn_time": 5.429, "lane": 3},
{"spawn_time": 5.536, "lane": 1},
{"spawn_time": 5.643, "lane": 4},
{"spawn_time": 5.760, "lane": 2},
{"spawn_time": 5.877, "lane": 1},
{"spawn_time": 5.989, "lane": 3},
{"spawn_time": 6.101, "lane": 2},
{"spawn_time": 6.144, "lane": 4},
{"spawn_time": 6.187, "lane": 3},
{"spawn_time": 6.256, "lane": 1},
{"spawn_time": 6.325, "lane": 4},
{"spawn_time": 6.331, "lane": 2},
{"spawn_time": 6.336, "lane": 1},
{"spawn_time": 6.549, "lane": 3},
{"spawn_time": 6.763, "lane": 2},
{"spawn_time": 6.768, "lane": 4},
{"spawn_time": 6.773, "lane": 3},
{"spawn_time": 6.789, "lane": 1},
{"spawn_time": 6.805, "lane": 4},
{"spawn_time": 7.008, "lane": 2},
{"spawn_time": 7.211, "lane": 1},
{"spawn_time": 7.216, "lane": 3},
{"spawn_time": 7.221, "lane": 2},
{"spawn_time": 7.461, "lane": 4},
{"spawn_time": 7.701, "lane": 3},
{"spawn_time": 7.707, "lane": 1},
{"spawn_time": 7.712, "lane": 4},
{"spawn_time": 7.925, "lane": 2},
{"spawn_time": 8.139, "lane": 1},
{"spawn_time": 8.245, "lane": 3},
{"spawn_time": 8.352, "lane": 2},
{"spawn_time": 8.464, "lane": 4},
{"spawn_time": 8.576, "lane": 3},
{"spawn_time": 8.677, "lane": 1},
{"spawn_time": 8.779, "lane": 4},
{"spawn_time": 8.800, "lane": 2},
{"spawn_time": 8.821, "lane": 1},
{"spawn_time": 8.917, "lane": 3},
{"spawn_time": 9.013, "lane": 2},
{"spawn_time": 9.019, "lane": 4},
{"spawn_time": 9.024, "lane": 3},
{"spawn_time": 9.056, "lane": 1},
{"spawn_time": 9.088, "lane": 4},
{"spawn_time": 9.285, "lane": 2},
{"spawn_time": 9.483, "lane": 1},
{"spawn_time": 9.589, "lane": 3},
{"spawn_time": 9.696, "lane": 2},
{"spawn_time": 9.792, "lane": 4},
{"spawn_time": 9.888, "lane": 3},
{"spawn_time": 9.899, "lane": 1},
{"spawn_time": 9.909, "lane": 4},
{"spawn_time": 10.027, "lane": 2},
{"spawn_time": 10.144, "lane": 1},
{"spawn_time": 10.261, "lane": 3},
{"spawn_time": 10.379, "lane": 2},
{"spawn_time": 10.523, "lane": 4},
{"spawn_time": 10.667, "lane": 3},
{"spawn_time": 10.768, "lane": 1},
{"spawn_time": 10.869, "lane": 4},
{"spawn_time": 10.949, "lane": 2},
{"spawn_time": 11.029, "lane": 1},
{"spawn_time": 11.157, "lane": 3},
{"spawn_time": 11.285, "lane": 2},
{"spawn_time": 11.504, "lane": 4},
{"spawn_time": 11.723, "lane": 3},
{"spawn_time": 11.728, "lane": 1},
{"spawn_time": 11.733, "lane": 4},
{"spawn_time": 11.851, "lane": 2},
{"spawn_time": 11.968, "lane": 1},
{"spawn_time": 12.080, "lane": 3},
{"spawn_time": 12.192, "lane": 2},
{"spawn_time": 12.416, "lane": 4},
{"spawn_time": 12.640, "lane": 3},
{"spawn_time": 12.752, "lane": 1},
{"spawn_time": 12.864, "lane": 4},
{"spawn_time": 12.971, "lane": 2},
{"spawn_time": 13.077, "lane": 1},
{"spawn_time": 13.083, "lane": 3},
{"spawn_time": 13.088, "lane": 2},
{"spawn_time": 13.200, "lane": 4},
{"spawn_time": 13.312, "lane": 3},
{"spawn_time": 13.419, "lane": 1},
{"spawn_time": 13.525, "lane": 4},
{"spawn_time": 13.531, "lane": 2},
{"spawn_time": 13.536, "lane": 1},
{"spawn_time": 13.637, "lane": 3},
{"spawn_time": 13.739, "lane": 2},
{"spawn_time": 13.856, "lane": 4},
{"spawn_time": 13.973, "lane": 3},
{"spawn_time": 13.979, "lane": 1},
{"spawn_time": 13.984, "lane": 4},
{"spawn_time": 14.213, "lane": 2},
{"spawn_time": 14.443, "lane": 1},
{"spawn_time": 14.555, "lane": 3},
{"spawn_time": 14.667, "lane": 2},
{"spawn_time": 14.773, "lane": 4},
{"spawn_time": 14.880, "lane": 3},
{"spawn_time": 14.997, "lane": 1},
{"spawn_time": 15.115, "lane": 4},
{"spawn_time": 15.221, "lane": 2},
{"spawn_time": 15.328, "lane": 1},
{"spawn_time": 15.445, "lane": 3},
{"spawn_time": 15.563, "lane": 2},
{"spawn_time": 15.680, "lane": 4},
{"spawn_time": 15.797, "lane": 3},
{"spawn_time": 16.016, "lane": 1},
{"spawn_time": 16.235, "lane": 4},
{"spawn_time": 16.453, "lane": 2},
{"spawn_time": 16.672, "lane": 1},
{"spawn_time": 16.677, "lane": 3},
{"spawn_time": 16.683, "lane": 2},
{"spawn_time": 16.853, "lane": 4},
{"spawn_time": 17.024, "lane": 3},
{"spawn_time": 17.072, "lane": 1},
{"spawn_time": 17.120, "lane": 4},
{"spawn_time": 17.344, "lane": 2},
{"spawn_time": 17.568, "lane": 1},
{"spawn_time": 17.803, "lane": 3},
{"spawn_time": 18.037, "lane": 2},
{"spawn_time": 18.155, "lane": 4},
{"spawn_time": 18.272, "lane": 3},
{"spawn_time": 18.384, "lane": 1},
{"spawn_time": 18.496, "lane": 4},
{"spawn_time": 18.720, "lane": 2},
{"spawn_time": 18.944, "lane": 1},
{"spawn_time": 18.949, "lane": 3},
{"spawn_time": 18.955, "lane": 2},
{"spawn_time": 19.067, "lane": 4},
{"spawn_time": 19.179, "lane": 3},
{"spawn_time": 19.285, "lane": 1},
{"spawn_time": 19.392, "lane": 4},
{"spawn_time": 19.397, "lane": 2},
{"spawn_time": 19.403, "lane": 1},
{"spawn_time": 19.621, "lane": 3},
{"spawn_time": 19.840, "lane": 2},
{"spawn_time": 19.851, "lane": 3},
{"spawn_time": 20.075, "lane": 4},
{"spawn_time": 20.299, "lane": 1},
{"spawn_time": 20.309, "lane": 2},
{"spawn_time": 20.523, "lane": 3},
{"spawn_time": 20.704, "lane": 4},
{"spawn_time": 20.715, "lane": 1},
{"spawn_time": 20.747, "lane": 2},
{"spawn_time": 20.992, "lane": 3},
{"spawn_time": 21.024, "lane": 4},
{"spawn_time": 21.195, "lane": 1},
{"spawn_time": 21.205, "lane": 2},
{"spawn_time": 21.643, "lane": 3},
{"spawn_time": 21.653, "lane": 4},
{"spawn_time": 21.888, "lane": 1},
{"spawn_time": 22.091, "lane": 2},
{"spawn_time": 22.101, "lane": 3},
{"spawn_time": 22.347, "lane": 4},
{"spawn_time": 22.453, "lane": 1},
{"spawn_time": 22.549, "lane": 2},
{"spawn_time": 22.560, "lane": 3},
{"spawn_time": 22.795, "lane": 4},
{"spawn_time": 22.837, "lane": 1},
{"spawn_time": 23.008, "lane": 2},
{"spawn_time": 23.019, "lane": 3},
{"spawn_time": 23.232, "lane": 4},
{"spawn_time": 23.456, "lane": 1},
{"spawn_time": 23.467, "lane": 2},
{"spawn_time": 23.904, "lane": 3},
{"spawn_time": 24.139, "lane": 4},
{"spawn_time": 24.320, "lane": 1},
{"spawn_time": 24.352, "lane": 2},
{"spawn_time": 24.800, "lane": 3},
{"spawn_time": 24.811, "lane": 4},
{"spawn_time": 25.259, "lane": 1},
{"spawn_time": 25.269, "lane": 2},
{"spawn_time": 25.504, "lane": 3},
{"spawn_time": 25.717, "lane": 4},
{"spawn_time": 26.123, "lane": 1},
{"spawn_time": 26.165, "lane": 2},
{"spawn_time": 26.400, "lane": 3},
{"spawn_time": 26.613, "lane": 4},
{"spawn_time": 26.624, "lane": 1},
{"spawn_time": 26.848, "lane": 2},
{"spawn_time": 27.061, "lane": 3},
{"spawn_time": 27.072, "lane": 4},
{"spawn_time": 27.296, "lane": 1},
{"spawn_time": 27.509, "lane": 2},
{"spawn_time": 27.520, "lane": 3},
{"spawn_time": 27.744, "lane": 4},
{"spawn_time": 27.957, "lane": 1},
{"spawn_time": 27.968, "lane": 2},
{"spawn_time": 28.171, "lane": 3},
{"spawn_time": 28.395, "lane": 4},
{"spawn_time": 28.405, "lane": 1},
{"spawn_time": 28.853, "lane": 2},
{"spawn_time": 29.088, "lane": 3},
{"spawn_time": 29.312, "lane": 4},
{"spawn_time": 29.536, "lane": 1},
{"spawn_time": 29.749, "lane": 2},
{"spawn_time": 29.963, "lane": 3},
{"spawn_time": 30.197, "lane": 4},
{"spawn_time": 30.667, "lane": 1},
{"spawn_time": 31.104, "lane": 2},
{"spawn_time": 31.136, "lane": 3},
{"spawn_time": 31.456, "lane": 4},
{"spawn_time": 31.573, "lane": 1},
{"spawn_time": 31.669, "lane": 2},
{"spawn_time": 31.776, "lane": 3},
{"spawn_time": 31.883, "lane": 4},
{"spawn_time": 32.011, "lane": 1},
{"spawn_time": 32.245, "lane": 2},
{"spawn_time": 32.459, "lane": 3},
{"spawn_time": 32.907, "lane": 4},
{"spawn_time": 33.248, "lane": 1},
{"spawn_time": 33.365, "lane": 2},
{"spawn_time": 33.376, "lane": 3},
{"spawn_time": 33.835, "lane": 4},
{"spawn_time": 34.059, "lane": 1},
{"spawn_time": 34.272, "lane": 2},
{"spawn_time": 34.283, "lane": 3},
{"spawn_time": 34.731, "lane": 4},
{"spawn_time": 34.955, "lane": 1},
{"spawn_time": 35.179, "lane": 2},
{"spawn_time": 35.637, "lane": 3},
{"spawn_time": 35.872, "lane": 4},
{"spawn_time": 36.096, "lane": 1},
{"spawn_time": 36.512, "lane": 2},
{"spawn_time": 36.523, "lane": 3},
{"spawn_time": 36.981, "lane": 4},
{"spawn_time": 36.992, "lane": 1},
{"spawn_time": 37.205, "lane": 2},
{"spawn_time": 37.237, "lane": 3},
{"spawn_time": 37.429, "lane": 4},
{"spawn_time": 37.440, "lane": 1},
{"spawn_time": 37.664, "lane": 2},
{"spawn_time": 37.899, "lane": 3},
{"spawn_time": 38.336, "lane": 4},
{"spawn_time": 38.347, "lane": 1},
{"spawn_time": 38.581, "lane": 2},
{"spawn_time": 38.784, "lane": 3},
{"spawn_time": 38.795, "lane": 4},
{"spawn_time": 39.029, "lane": 1},
{"spawn_time": 39.243, "lane": 2},
{"spawn_time": 39.467, "lane": 3},
{"spawn_time": 39.627, "lane": 4},
{"spawn_time": 39.701, "lane": 1},
{"spawn_time": 40.149, "lane": 2},
{"spawn_time": 40.587, "lane": 3},
{"spawn_time": 40.597, "lane": 4},
{"spawn_time": 41.024, "lane": 1},
{"spawn_time": 41.259, "lane": 2},
{"spawn_time": 41.493, "lane": 3},
{"spawn_time": 41.931, "lane": 4},
{"spawn_time": 42.155, "lane": 1},
{"spawn_time": 42.379, "lane": 2},
{"spawn_time": 42.613, "lane": 3},
{"spawn_time": 42.827, "lane": 4},
{"spawn_time": 43.104, "lane": 1},
{"spawn_time": 43.296, "lane": 2},
{"spawn_time": 43.744, "lane": 3},
{"spawn_time": 43.968, "lane": 4},
{"spawn_time": 44.192, "lane": 1},
{"spawn_time": 44.203, "lane": 2},
{"spawn_time": 44.405, "lane": 3},
{"spawn_time": 44.651, "lane": 4},
{"spawn_time": 45.131, "lane": 1},
{"spawn_time": 45.355, "lane": 2},
{"spawn_time": 45.568, "lane": 3},
{"spawn_time": 45.813, "lane": 4},
{"spawn_time": 46.016, "lane": 1},
{"spawn_time": 46.187, "lane": 2},
{"spawn_time": 46.464, "lane": 3},
{"spawn_time": 46.923, "lane": 4},
{"spawn_time": 47.125, "lane": 1},
{"spawn_time": 47.371, "lane": 2},
{"spawn_time": 47.797, "lane": 3},
{"spawn_time": 48.256, "lane": 4},
{"spawn_time": 48.715, "lane": 1},
{"spawn_time": 48.939, "lane": 2},
{"spawn_time": 49.173, "lane": 3},
{"spawn_time": 49.621, "lane": 4},
{"spawn_time": 50.069, "lane": 1},
{"spawn_time": 50.528, "lane": 2},
{"spawn_time": 50.539, "lane": 3},
{"spawn_time": 50.752, "lane": 4},
{"spawn_time": 50.976, "lane": 1},
{"spawn_time": 51.424, "lane": 2},
{"spawn_time": 51.883, "lane": 3},
{"spawn_time": 52.331, "lane": 4},
{"spawn_time": 52.779, "lane": 1},
{"spawn_time": 53.227, "lane": 2},
{"spawn_time": 53.675, "lane": 3},
{"spawn_time": 53.685, "lane": 4},
{"spawn_time": 54.133, "lane": 1},
{"spawn_time": 54.347, "lane": 2},
{"spawn_time": 54.581, "lane": 3},
{"spawn_time": 55.040, "lane": 4},
{"spawn_time": 55.488, "lane": 1},
{"spawn_time": 55.947, "lane": 2},
{"spawn_time": 56.149, "lane": 3},
{"spawn_time": 56.384, "lane": 4},
{"spawn_time": 56.832, "lane": 1},
{"spawn_time": 57.291, "lane": 2},
{"spawn_time": 57.739, "lane": 3},
{"spawn_time": 58.187, "lane": 4},
{"spawn_time": 58.645, "lane": 1},
{"spawn_time": 59.083, "lane": 2},
{"spawn_time": 59.093, "lane": 3},
{"spawn_time": 59.541, "lane": 4},
{"spawn_time": 59.776, "lane": 1},
{"spawn_time": 59.989, "lane": 2},
{"spawn_time": 60.427, "lane": 3},
{"spawn_time": 60.885, "lane": 4},
{"spawn_time": 61.344, "lane": 1},
{"spawn_time": 61.557, "lane": 2},
{"spawn_time": 61.792, "lane": 3},
{"spawn_time": 62.240, "lane": 4},
{"spawn_time": 62.688, "lane": 1},
{"spawn_time": 62.699, "lane": 2},
{"spawn_time": 63.168, "lane": 3},
{"spawn_time": 63.381, "lane": 4},
{"spawn_time": 63.605, "lane": 1},
{"spawn_time": 64.043, "lane": 2},
{"spawn_time": 64.053, "lane": 3},
{"spawn_time": 64.501, "lane": 4},
{"spawn_time": 64.512, "lane": 1},
{"spawn_time": 64.971, "lane": 2},
{"spawn_time": 65.184, "lane": 3},
{"spawn_time": 65.419, "lane": 4},
{"spawn_time": 65.867, "lane": 1},
{"spawn_time": 66.325, "lane": 2},
{"spawn_time": 66.741, "lane": 3},
{"spawn_time": 66.997, "lane": 4},
{"spawn_time": 67.211, "lane": 1},
{"spawn_time": 67.659, "lane": 2},
{"spawn_time": 68.107, "lane": 3},
{"spawn_time": 68.565, "lane": 4},
{"spawn_time": 68.800, "lane": 1},
{"spawn_time": 69.013, "lane": 2},
{"spawn_time": 69.472, "lane": 3},
{"spawn_time": 69.931, "lane": 4},
{"spawn_time": 70.379, "lane": 1},
{"spawn_time": 70.592, "lane": 2},
{"spawn_time": 70.827, "lane": 3},
{"spawn_time": 71.285, "lane": 4},
{"spawn_time": 71.723, "lane": 1},
{"spawn_time": 71.733, "lane": 2},
{"spawn_time": 72.192, "lane": 3},
{"spawn_time": 72.416, "lane": 4},
{"spawn_time": 72.640, "lane": 1},
{"spawn_time": 73.088, "lane": 2},
{"spawn_time": 73.525, "lane": 3},
{"spawn_time": 73.973, "lane": 4},
{"spawn_time": 73.984, "lane": 1},
{"spawn_time": 74.219, "lane": 2},
{"spawn_time": 74.432, "lane": 3},
{"spawn_time": 74.667, "lane": 4},
{"spawn_time": 74.901, "lane": 1},
{"spawn_time": 75.125, "lane": 2},
{"spawn_time": 75.339, "lane": 3},
{"spawn_time": 75.573, "lane": 4},
{"spawn_time": 75.797, "lane": 1},
{"spawn_time": 76.245, "lane": 2},
{"spawn_time": 76.256, "lane": 3},
{"spawn_time": 76.693, "lane": 4},
{"spawn_time": 76.928, "lane": 1},
{"spawn_time": 77.120, "lane": 2},
{"spawn_time": 77.131, "lane": 3},
{"spawn_time": 77.376, "lane": 4},
{"spawn_time": 77.600, "lane": 1},
{"spawn_time": 78.027, "lane": 2},
{"spawn_time": 78.037, "lane": 3},
{"spawn_time": 78.496, "lane": 4},
{"spawn_time": 78.923, "lane": 1},
{"spawn_time": 79.189, "lane": 2},
{"spawn_time": 79.392, "lane": 3},
{"spawn_time": 79.403, "lane": 4},
{"spawn_time": 79.637, "lane": 1},
{"spawn_time": 79.851, "lane": 2},
{"spawn_time": 80.299, "lane": 3},
{"spawn_time": 80.309, "lane": 4},
{"spawn_time": 80.533, "lane": 1},
{"spawn_time": 80.747, "lane": 2},
{"spawn_time": 80.981, "lane": 3},
{"spawn_time": 81.205, "lane": 4},
{"spawn_time": 81.653, "lane": 1},
{"spawn_time": 82.112, "lane": 2},
{"spawn_time": 82.549, "lane": 3},
{"spawn_time": 82.784, "lane": 4},
{"spawn_time": 83.008, "lane": 1},
{"spawn_time": 83.019, "lane": 2},
{"spawn_time": 83.232, "lane": 3},
{"spawn_time": 83.467, "lane": 4},
{"spawn_time": 83.904, "lane": 1},
{"spawn_time": 83.915, "lane": 2},
{"spawn_time": 84.139, "lane": 3},
{"spawn_time": 84.352, "lane": 4},
{"spawn_time": 84.597, "lane": 1},
{"spawn_time": 84.811, "lane": 2},
{"spawn_time": 85.259, "lane": 3},
{"spawn_time": 85.269, "lane": 4},
{"spawn_time": 85.717, "lane": 1},
{"spawn_time": 86.165, "lane": 2},
{"spawn_time": 86.400, "lane": 3},
{"spawn_time": 86.613, "lane": 4},
{"spawn_time": 86.624, "lane": 1},
{"spawn_time": 86.859, "lane": 2},
{"spawn_time": 87.072, "lane": 3},
{"spawn_time": 87.509, "lane": 4},
{"spawn_time": 87.520, "lane": 1},
{"spawn_time": 87.968, "lane": 2},
{"spawn_time": 88.203, "lane": 3},
{"spawn_time": 88.427, "lane": 4},
{"spawn_time": 88.875, "lane": 1},
{"spawn_time": 89.109, "lane": 2},
{"spawn_time": 89.333, "lane": 3},
{"spawn_time": 89.792, "lane": 4},
{"spawn_time": 90.240, "lane": 1},
{"spawn_time": 90.688, "lane": 2},
{"spawn_time": 90.912, "lane": 3},
{"spawn_time": 91.136, "lane": 4},
{"spawn_time": 91.360, "lane": 1},
{"spawn_time": 91.467, "lane": 2},
{"spawn_time": 91.584, "lane": 3},
{"spawn_time": 91.595, "lane": 4},
{"spawn_time": 91.701, "lane": 1},
{"spawn_time": 91.808, "lane": 2},
{"spawn_time": 92.032, "lane": 3},
{"spawn_time": 92.043, "lane": 4},
{"spawn_time": 92.256, "lane": 1},
{"spawn_time": 92.363, "lane": 2},
{"spawn_time": 92.469, "lane": 3},
{"spawn_time": 92.480, "lane": 4},
{"spawn_time": 92.693, "lane": 1},
{"spawn_time": 92.896, "lane": 2},
{"spawn_time": 92.928, "lane": 3},
{"spawn_time": 93.141, "lane": 4},
{"spawn_time": 93.376, "lane": 1},
{"spawn_time": 93.835, "lane": 2},
{"spawn_time": 93.845, "lane": 3},
{"spawn_time": 94.069, "lane": 4},
{"spawn_time": 94.283, "lane": 1},
{"spawn_time": 94.293, "lane": 2},
{"spawn_time": 94.517, "lane": 3},
{"spawn_time": 94.741, "lane": 4},
{"spawn_time": 94.965, "lane": 1},
{"spawn_time": 95.189, "lane": 2},
{"spawn_time": 95.200, "lane": 3},
{"spawn_time": 95.424, "lane": 4},
{"spawn_time": 95.637, "lane": 1},
{"spawn_time": 95.872, "lane": 2},
{"spawn_time": 96.085, "lane": 3},
{"spawn_time": 96.309, "lane": 4},
{"spawn_time": 96.533, "lane": 1},
{"spawn_time": 96.544, "lane": 2},
{"spawn_time": 96.768, "lane": 3},
{"spawn_time": 96.992, "lane": 4},
{"spawn_time": 97.003, "lane": 1},
{"spawn_time": 97.227, "lane": 2},
{"spawn_time": 97.429, "lane": 3},
{"spawn_time": 97.440, "lane": 4},
{"spawn_time": 97.675, "lane": 1},
{"spawn_time": 97.877, "lane": 2},
{"spawn_time": 97.888, "lane": 3},
{"spawn_time": 98.123, "lane": 4},
{"spawn_time": 98.336, "lane": 1},
{"spawn_time": 98.347, "lane": 2},
{"spawn_time": 98.571, "lane": 3},
{"spawn_time": 98.773, "lane": 4},
{"spawn_time": 98.784, "lane": 1},
{"spawn_time": 99.008, "lane": 2},
{"spawn_time": 99.232, "lane": 3},
{"spawn_time": 99.477, "lane": 4},
{"spawn_time": 99.680, "lane": 1},
{"spawn_time": 99.851, "lane": 2},
{"spawn_time": 99.915, "lane": 3},
{"spawn_time": 100.021, "lane": 4},
{"spawn_time": 100.128, "lane": 1},
{"spawn_time": 100.139, "lane": 2},
{"spawn_time": 100.384, "lane": 3},
{"spawn_time": 100.576, "lane": 4},
{"spawn_time": 100.587, "lane": 1},
{"spawn_time": 100.821, "lane": 2},
{"spawn_time": 101.045, "lane": 3},
{"spawn_time": 101.056, "lane": 4},
{"spawn_time": 101.280, "lane": 1},
{"spawn_time": 101.483, "lane": 2},
{"spawn_time": 101.493, "lane": 3},
{"spawn_time": 101.824, "lane": 4},
{"spawn_time": 101.941, "lane": 1},
{"spawn_time": 101.952, "lane": 2},
{"spawn_time": 102.176, "lane": 3},
{"spawn_time": 102.400, "lane": 4},
{"spawn_time": 102.411, "lane": 1},
{"spawn_time": 102.624, "lane": 2},
{"spawn_time": 102.859, "lane": 3},
{"spawn_time": 103.083, "lane": 4},
{"spawn_time": 103.189, "lane": 1},
{"spawn_time": 103.307, "lane": 2},
{"spawn_time": 103.531, "lane": 3},
{"spawn_time": 103.755, "lane": 4},
{"spawn_time": 103.765, "lane": 1},
{"spawn_time": 103.968, "lane": 2},
{"spawn_time": 104.203, "lane": 3},
{"spawn_time": 104.661, "lane": 4},
{"spawn_time": 104.885, "lane": 1},
{"spawn_time": 105.109, "lane": 2},
{"spawn_time": 105.333, "lane": 3},
{"spawn_time": 105.568, "lane": 4},
{"spawn_time": 105.781, "lane": 1},
{"spawn_time": 106.016, "lane": 2},
{"spawn_time": 106.464, "lane": 3},
{"spawn_time": 106.912, "lane": 4},
{"spawn_time": 106.923, "lane": 1},
{"spawn_time": 107.371, "lane": 2},
{"spawn_time": 107.605, "lane": 3},
{"spawn_time": 107.701, "lane": 4},
{"spawn_time": 107.808, "lane": 1},
{"spawn_time": 107.819, "lane": 2},
{"spawn_time": 108.267, "lane": 3},
{"spawn_time": 108.491, "lane": 4},
{"spawn_time": 108.704, "lane": 1},
{"spawn_time": 108.939, "lane": 2},
{"spawn_time": 109.152, "lane": 3},
{"spawn_time": 109.163, "lane": 4},
{"spawn_time": 109.387, "lane": 1},
{"spawn_time": 109.611, "lane": 2},
{"spawn_time": 109.845, "lane": 3},
{"spawn_time": 110.059, "lane": 4},
{"spawn_time": 110.080, "lane": 1},
{"spawn_time": 110.304, "lane": 2},
{"spawn_time": 110.496, "lane": 3},
{"spawn_time": 110.517, "lane": 4},
{"spawn_time": 110.752, "lane": 1},
{"spawn_time": 110.891, "lane": 2},
{"spawn_time": 110.923, "lane": 3},
{"spawn_time": 110.976, "lane": 4},
{"spawn_time": 111.200, "lane": 1},
{"spawn_time": 111.413, "lane": 2},
{"spawn_time": 111.637, "lane": 3},
{"spawn_time": 111.851, "lane": 4},
{"spawn_time": 111.861, "lane": 1},
{"spawn_time": 112.309, "lane": 2},
{"spawn_time": 112.320, "lane": 3},
{"spawn_time": 112.640, "lane": 4},
{"spawn_time": 112.779, "lane": 1},
{"spawn_time": 113.013, "lane": 2},
{"spawn_time": 113.227, "lane": 3},
{"spawn_time": 113.440, "lane": 4},
{"spawn_time": 113.685, "lane": 1},
{"spawn_time": 113.696, "lane": 2},
{"spawn_time": 113.920, "lane": 3},
{"spawn_time": 114.027, "lane": 4},
{"spawn_time": 114.123, "lane": 1},
{"spawn_time": 114.133, "lane": 2},
{"spawn_time": 114.347, "lane": 3},
{"spawn_time": 114.571, "lane": 4},
{"spawn_time": 114.581, "lane": 1},
{"spawn_time": 114.805, "lane": 2},
{"spawn_time": 115.040, "lane": 3},
{"spawn_time": 115.264, "lane": 4},
{"spawn_time": 115.488, "lane": 1},
{"spawn_time": 115.499, "lane": 2},
{"spawn_time": 115.723, "lane": 3},
{"spawn_time": 115.936, "lane": 4},
{"spawn_time": 116.160, "lane": 1},
{"spawn_time": 116.384, "lane": 2},
{"spawn_time": 116.395, "lane": 3},
{"spawn_time": 116.619, "lane": 4},
{"spawn_time": 116.843, "lane": 1},
{"spawn_time": 117.067, "lane": 2},
{"spawn_time": 117.291, "lane": 3},
{"spawn_time": 117.301, "lane": 4},
{"spawn_time": 117.525, "lane": 1},
{"spawn_time": 117.717, "lane": 2},
{"spawn_time": 117.739, "lane": 3},
{"spawn_time": 117.963, "lane": 4},
{"spawn_time": 118.176, "lane": 1},
{"spawn_time": 118.187, "lane": 2},
{"spawn_time": 118.421, "lane": 3},
{"spawn_time": 118.645, "lane": 4},
{"spawn_time": 119.104, "lane": 1},
{"spawn_time": 119.115, "lane": 2},
{"spawn_time": 119.328, "lane": 3},
{"spawn_time": 119.552, "lane": 4},
{"spawn_time": 119.787, "lane": 1},
{"spawn_time": 119.989, "lane": 2},
{"spawn_time": 120.000, "lane": 3},
{"spawn_time": 120.224, "lane": 4},
{"spawn_time": 120.459, "lane": 1},
{"spawn_time": 120.917, "lane": 2},
{"spawn_time": 121.131, "lane": 3},
{"spawn_time": 121.365, "lane": 4},
{"spawn_time": 121.813, "lane": 1},
{"spawn_time": 122.123, "lane": 2},
{"spawn_time": 122.251, "lane": 3},
{"spawn_time": 122.475, "lane": 4},
{"spawn_time": 122.688, "lane": 1},
{"spawn_time": 122.923, "lane": 2},
{"spawn_time": 123.136, "lane": 3},
{"spawn_time": 123.147, "lane": 4},
{"spawn_time": 123.595, "lane": 1},
{"spawn_time": 124.043, "lane": 2},
{"spawn_time": 124.267, "lane": 3},
{"spawn_time": 124.501, "lane": 4},
{"spawn_time": 124.949, "lane": 1},
{"spawn_time": 125.387, "lane": 2},
{"spawn_time": 125.397, "lane": 3},
{"spawn_time": 125.856, "lane": 4},
{"spawn_time": 125.973, "lane": 1},
{"spawn_time": 126.101, "lane": 2},
{"spawn_time": 126.315, "lane": 3},
{"spawn_time": 126.325, "lane": 4},
{"spawn_time": 126.763, "lane": 1},
{"spawn_time": 126.773, "lane": 2},
{"spawn_time": 127.221, "lane": 3},
{"spawn_time": 127.435, "lane": 4},
{"spawn_time": 127.467, "lane": 1},
{"spawn_time": 127.659, "lane": 2},
{"spawn_time": 127.669, "lane": 3},
{"spawn_time": 127.904, "lane": 4},
{"spawn_time": 128.117, "lane": 1},
{"spawn_time": 128.565, "lane": 2},
{"spawn_time": 128.576, "lane": 3},
{"spawn_time": 128.800, "lane": 4},
{"spawn_time": 128.992, "lane": 1},
{"spawn_time": 129.013, "lane": 2},
{"spawn_time": 129.024, "lane": 3},
{"spawn_time": 129.237, "lane": 4},
{"spawn_time": 129.451, "lane": 1},
{"spawn_time": 129.707, "lane": 2},
{"spawn_time": 129.920, "lane": 3},
{"spawn_time": 130.368, "lane": 4},
{"spawn_time": 130.816, "lane": 1},
{"spawn_time": 131.264, "lane": 2},
{"spawn_time": 131.275, "lane": 3},
{"spawn_time": 131.435, "lane": 4},
{"spawn_time": 131.520, "lane": 1},
{"spawn_time": 131.712, "lane": 2},
{"spawn_time": 131.723, "lane": 3},
{"spawn_time": 131.936, "lane": 4},
{"spawn_time": 132.160, "lane": 1},
{"spawn_time": 132.608, "lane": 2},
{"spawn_time": 132.619, "lane": 3},
{"spawn_time": 132.832, "lane": 4},
{"spawn_time": 133.067, "lane": 1},
{"spawn_time": 133.301, "lane": 2},
{"spawn_time": 133.525, "lane": 3},
{"spawn_time": 133.536, "lane": 4},
{"spawn_time": 133.984, "lane": 1},
{"spawn_time": 134.411, "lane": 2},
{"spawn_time": 134.869, "lane": 3},
{"spawn_time": 135.296, "lane": 4},
{"spawn_time": 135.307, "lane": 1},
{"spawn_time": 135.755, "lane": 2},
{"spawn_time": 135.840, "lane": 3},
{"spawn_time": 135.989, "lane": 4},
{"spawn_time": 136.213, "lane": 1},
{"spawn_time": 136.448, "lane": 2},
{"spawn_time": 136.629, "lane": 3},
{"spawn_time": 136.672, "lane": 4},
{"spawn_time": 137.141, "lane": 1},
{"spawn_time": 137.344, "lane": 2},
{"spawn_time": 137.589, "lane": 3},
{"spawn_time": 138.016, "lane": 4},
{"spawn_time": 138.048, "lane": 1},
{"spawn_time": 138.496, "lane": 2},
{"spawn_time": 138.944, "lane": 3},
{"spawn_time": 139.168, "lane": 4},
{"spawn_time": 139.392, "lane": 1},
{"spawn_time": 139.840, "lane": 2},
{"spawn_time": 140.288, "lane": 3},
{"spawn_time": 140.299, "lane": 4},
{"spawn_time": 140.757, "lane": 1},
{"spawn_time": 140.981, "lane": 2},
{"spawn_time": 141.205, "lane": 3},
{"spawn_time": 141.643, "lane": 4},
{"spawn_time": 142.101, "lane": 1},
{"spawn_time": 142.560, "lane": 2},
{"spawn_time": 143.008, "lane": 3},
{"spawn_time": 143.456, "lane": 4},
{"spawn_time": 143.904, "lane": 1},
{"spawn_time": 144.363, "lane": 2},
{"spawn_time": 144.576, "lane": 3},
{"spawn_time": 144.811, "lane": 4},
{"spawn_time": 145.269, "lane": 1},
{"spawn_time": 145.717, "lane": 2},
{"spawn_time": 145.728, "lane": 3},
{"spawn_time": 146.176, "lane": 4},
{"spawn_time": 146.389, "lane": 1},
{"spawn_time": 146.624, "lane": 2},
{"spawn_time": 147.072, "lane": 3},
{"spawn_time": 147.307, "lane": 4},
{"spawn_time": 147.531, "lane": 1},
{"spawn_time": 147.979, "lane": 2},
{"spawn_time": 148.203, "lane": 3},
{"spawn_time": 148.437, "lane": 4},
{"spawn_time": 148.875, "lane": 1},
{"spawn_time": 149.323, "lane": 2},
{"spawn_time": 149.557, "lane": 3},
{"spawn_time": 149.781, "lane": 4},
{"spawn_time": 150.005, "lane": 1},
{"spawn_time": 150.229, "lane": 2},
{"spawn_time": 150.667, "lane": 3},
{"spawn_time": 150.677, "lane": 4},
{"spawn_time": 151.136, "lane": 1},
{"spawn_time": 151.584, "lane": 2},
{"spawn_time": 151.808, "lane": 3},
{"spawn_time": 152.032, "lane": 4},
{"spawn_time": 152.480, "lane": 1},
{"spawn_time": 152.928, "lane": 2},
{"spawn_time": 153.163, "lane": 3},
{"spawn_time": 153.376, "lane": 4},
{"spawn_time": 153.611, "lane": 1},
{"spawn_time": 153.824, "lane": 2},
{"spawn_time": 154.272, "lane": 3},
{"spawn_time": 154.731, "lane": 4},
{"spawn_time": 155.189, "lane": 1},
{"spawn_time": 155.413, "lane": 2},
{"spawn_time": 155.637, "lane": 3},
{"spawn_time": 156.096, "lane": 4},
{"spawn_time": 156.544, "lane": 1},
{"spawn_time": 156.971, "lane": 2},
{"spawn_time": 157.451, "lane": 3},
{"spawn_time": 157.899, "lane": 4},
{"spawn_time": 158.347, "lane": 1},
{"spawn_time": 158.795, "lane": 2},
{"spawn_time": 159.019, "lane": 3},
{"spawn_time": 159.243, "lane": 4},
{"spawn_time": 159.691, "lane": 1},
{"spawn_time": 160.149, "lane": 2},
{"spawn_time": 160.608, "lane": 3},
{"spawn_time": 161.067, "lane": 4},
{"spawn_time": 161.525, "lane": 1},
{"spawn_time": 161.963, "lane": 2},
{"spawn_time": 162.400, "lane": 3},
{"spawn_time": 162.859, "lane": 4},
{"spawn_time": 163.307, "lane": 1},
{"spawn_time": 163.733, "lane": 2},
{"spawn_time": 163.744, "lane": 3},
{"spawn_time": 164.203, "lane": 4},
{"spawn_time": 164.416, "lane": 1},
{"spawn_time": 164.448, "lane": 2},
{"spawn_time": 164.672, "lane": 3},
{"spawn_time": 165.120, "lane": 4},
{"spawn_time": 165.333, "lane": 1},
{"spawn_time": 165.568, "lane": 2},
{"spawn_time": 166.027, "lane": 3},
{"spawn_time": 166.240, "lane": 4},
{"spawn_time": 166.475, "lane": 1},
{"spawn_time": 166.677, "lane": 2},
{"spawn_time": 166.912, "lane": 3},
{"spawn_time": 166.923, "lane": 4},
{"spawn_time": 167.360, "lane": 1},
{"spawn_time": 167.371, "lane": 2},
{"spawn_time": 167.595, "lane": 3},
{"spawn_time": 167.819, "lane": 4},
{"spawn_time": 167.829, "lane": 1},
{"spawn_time": 168.053, "lane": 2},
{"spawn_time": 168.277, "lane": 3},
{"spawn_time": 168.288, "lane": 4},
{"spawn_time": 168.715, "lane": 1},
{"spawn_time": 168.725, "lane": 2},
{"spawn_time": 168.949, "lane": 3},
{"spawn_time": 169.173, "lane": 4},
{"spawn_time": 169.184, "lane": 1},
{"spawn_time": 169.408, "lane": 2},
{"spawn_time": 169.621, "lane": 3},
{"spawn_time": 169.632, "lane": 4},
{"spawn_time": 169.856, "lane": 1},
{"spawn_time": 170.069, "lane": 2},
{"spawn_time": 170.080, "lane": 3},
{"spawn_time": 170.293, "lane": 4},
{"spawn_time": 170.528, "lane": 1},
{"spawn_time": 170.763, "lane": 2},
{"spawn_time": 170.805, "lane": 3},
{"spawn_time": 170.976, "lane": 4},
{"spawn_time": 170.987, "lane": 1},
{"spawn_time": 171.200, "lane": 2},
{"spawn_time": 171.435, "lane": 3},
{"spawn_time": 171.659, "lane": 4},
{"spawn_time": 171.883, "lane": 1},
{"spawn_time": 171.893, "lane": 2},
{"spawn_time": 172.117, "lane": 3},
{"spawn_time": 172.331, "lane": 4},
{"spawn_time": 172.341, "lane": 1},
{"spawn_time": 172.555, "lane": 2},
{"spawn_time": 172.779, "lane": 3},
{"spawn_time": 172.789, "lane": 4},
{"spawn_time": 173.013, "lane": 1},
{"spawn_time": 173.227, "lane": 2},
{"spawn_time": 173.237, "lane": 3},
{"spawn_time": 173.461, "lane": 4},
{"spawn_time": 173.685, "lane": 1},
{"spawn_time": 173.696, "lane": 2},
{"spawn_time": 173.909, "lane": 3},
{"spawn_time": 174.133, "lane": 4},
{"spawn_time": 174.368, "lane": 1},
{"spawn_time": 174.581, "lane": 2},
{"spawn_time": 174.592, "lane": 3},
{"spawn_time": 174.816, "lane": 4},
{"spawn_time": 175.040, "lane": 1},
{"spawn_time": 175.264, "lane": 2},
{"spawn_time": 175.488, "lane": 3},
{"spawn_time": 175.499, "lane": 4},
{"spawn_time": 175.733, "lane": 1},
{"spawn_time": 175.947, "lane": 2},
{"spawn_time": 176.160, "lane": 3},
{"spawn_time": 176.395, "lane": 4},
{"spawn_time": 176.405, "lane": 1},
{"spawn_time": 176.619, "lane": 2},
{"spawn_time": 176.843, "lane": 3},
{"spawn_time": 176.853, "lane": 4},
{"spawn_time": 177.067, "lane": 1},
{"spawn_time": 177.301, "lane": 2},
{"spawn_time": 177.525, "lane": 3},
{"spawn_time": 177.749, "lane": 4},
{"spawn_time": 177.984, "lane": 1},
{"spawn_time": 178.091, "lane": 2},
{"spawn_time": 178.197, "lane": 3},
{"spawn_time": 178.208, "lane": 4},
{"spawn_time": 178.421, "lane": 1},
{"spawn_time": 178.667, "lane": 2},
{"spawn_time": 178.677, "lane": 3},
{"spawn_time": 178.869, "lane": 4},
{"spawn_time": 179.093, "lane": 1},
{"spawn_time": 179.552, "lane": 2},
{"spawn_time": 179.776, "lane": 3},
{"spawn_time": 180.000, "lane": 4},
{"spawn_time": 180.459, "lane": 1},
{"spawn_time": 180.907, "lane": 2},
{"spawn_time": 181.365, "lane": 3},
{"spawn_time": 181.813, "lane": 4},
{"spawn_time": 182.261, "lane": 1},
{"spawn_time": 182.709, "lane": 2},
{"spawn_time": 183.157, "lane": 3},
{"spawn_time": 183.168, "lane": 4},
{"spawn_time": 183.296, "lane": 1},
{"spawn_time": 183.616, "lane": 2},
{"spawn_time": 183.627, "lane": 3},
{"spawn_time": 184.075, "lane": 4},
{"spawn_time": 184.288, "lane": 1},
{"spawn_time": 184.512, "lane": 2},
{"spawn_time": 184.523, "lane": 3},
{"spawn_time": 184.971, "lane": 4},
{"spawn_time": 185.419, "lane": 1},
{"spawn_time": 185.632, "lane": 2},
{"spawn_time": 185.867, "lane": 3},
{"spawn_time": 186.315, "lane": 4},
{"spawn_time": 186.325, "lane": 1},
{"spawn_time": 186.773, "lane": 2},
{"spawn_time": 187.221, "lane": 3},
{"spawn_time": 187.680, "lane": 4},
{"spawn_time": 188.117, "lane": 1},
{"spawn_time": 188.128, "lane": 2},
{"spawn_time": 188.352, "lane": 3},
{"spawn_time": 188.576, "lane": 4},
{"spawn_time": 188.800, "lane": 1},
{"spawn_time": 189.024, "lane": 2},
{"spawn_time": 189.472, "lane": 3},
{"spawn_time": 189.920, "lane": 4},
{"spawn_time": 189.931, "lane": 1},
{"spawn_time": 190.368, "lane": 2},
{"spawn_time": 190.816, "lane": 3},
{"spawn_time": 191.051, "lane": 4},
{"spawn_time": 191.243, "lane": 1},
{"spawn_time": 191.253, "lane": 2},
{"spawn_time": 191.275, "lane": 3},
{"spawn_time": 191.509, "lane": 4},
{"spawn_time": 191.691, "lane": 1},
{"spawn_time": 191.840, "lane": 2},
{"spawn_time": 192.128, "lane": 3},
{"spawn_time": 192.181, "lane": 4},
{"spawn_time": 192.533, "lane": 1},
{"spawn_time": 192.939, "lane": 2},
{"spawn_time": 193.397, "lane": 3},
{"spawn_time": 193.856, "lane": 4},
{"spawn_time": 194.325, "lane": 1},
{"spawn_time": 194.795, "lane": 2},
{"spawn_time": 195.264, "lane": 3},
{"spawn_time": 195.723, "lane": 4},
{"spawn_time": 196.181, "lane": 1},
{"spawn_time": 196.629, "lane": 2},
{"spawn_time": 197.077, "lane": 3},
{"spawn_time": 197.536, "lane": 4},
{"spawn_time": 198.005, "lane": 1},
{"spawn_time": 198.475, "lane": 2},
{"spawn_time": 198.485, "lane": 3},
{"spawn_time": 198.933, "lane": 4},
{"spawn_time": 199.392, "lane": 1},
{"spawn_time": 199.691, "lane": 2},
{"spawn_time": 199.840, "lane": 3},
{"spawn_time": 200.309, "lane": 4},
{"spawn_time": 200.501, "lane": 1},
{"spawn_time": 200.533, "lane": 2},
{"spawn_time": 200.779, "lane": 3},
{"spawn_time": 201.205, "lane": 4},
{"spawn_time": 201.227, "lane": 1},
{"spawn_time": 201.440, "lane": 2},
{"spawn_time": 201.472, "lane": 3},
{"spawn_time": 201.707, "lane": 4},
{"spawn_time": 202.123, "lane": 1},
{"spawn_time": 202.336, "lane": 2},
{"spawn_time": 202.571, "lane": 3},
{"spawn_time": 203.008, "lane": 4},
{"spawn_time": 203.104, "lane": 1},
{"spawn_time": 203.435, "lane": 2},
{"spawn_time": 203.456, "lane": 3},
{"spawn_time": 203.883, "lane": 4},
{"spawn_time": 203.893, "lane": 1},
{"spawn_time": 204.160, "lane": 2},
{"spawn_time": 204.352, "lane": 3},
{"spawn_time": 204.800, "lane": 4},
{"spawn_time": 205.216, "lane": 1},
{"spawn_time": 205.248, "lane": 2},
{"spawn_time": 205.717, "lane": 3},
{"spawn_time": 205.941, "lane": 4},
{"spawn_time": 206.165, "lane": 1},
{"spawn_time": 206.603, "lane": 2},
{"spawn_time": 207.051, "lane": 3},
{"spawn_time": 207.509, "lane": 4},
{"spawn_time": 207.957, "lane": 1},
{"spawn_time": 208.405, "lane": 2},
{"spawn_time": 208.853, "lane": 3},
{"spawn_time": 209.312, "lane": 4},
{"spawn_time": 209.547, "lane": 1},
{"spawn_time": 209.771, "lane": 2},
{"spawn_time": 210.229, "lane": 3},
{"spawn_time": 210.677, "lane": 4},
{"spawn_time": 211.115, "lane": 1},
{"spawn_time": 211.563, "lane": 2},
{"spawn_time": 212.011, "lane": 3},
{"spawn_time": 212.469, "lane": 4},
{"spawn_time": 212.928, "lane": 1},
{"spawn_time": 213.152, "lane": 2},
{"spawn_time": 213.376, "lane": 3},
{"spawn_time": 213.835, "lane": 4},
{"spawn_time": 214.293, "lane": 1},
{"spawn_time": 214.741, "lane": 2},
{"spawn_time": 214.965, "lane": 3},
{"spawn_time": 215.189, "lane": 4},
{"spawn_time": 215.637, "lane": 1},
{"spawn_time": 216.096, "lane": 2},
{"spawn_time": 216.544, "lane": 3},
{"spawn_time": 216.757, "lane": 4},
{"spawn_time": 216.992, "lane": 1},
{"spawn_time": 217.451, "lane": 2},
{"spawn_time": 217.899, "lane": 3},
{"spawn_time": 218.368, "lane": 4},
{"spawn_time": 218.581, "lane": 1},
{"spawn_time": 218.816, "lane": 2},
{"spawn_time": 219.264, "lane": 3},
{"spawn_time": 219.701, "lane": 4},
{"spawn_time": 220.160, "lane": 1},
{"spawn_time": 220.395, "lane": 2},
{"spawn_time": 220.619, "lane": 3},
{"spawn_time": 220.843, "lane": 4},
{"spawn_time": 221.067, "lane": 1},
{"spawn_time": 221.525, "lane": 2},
{"spawn_time": 221.984, "lane": 3},
{"spawn_time": 222.187, "lane": 4},
{"spawn_time": 222.421, "lane": 1},
{"spawn_time": 222.869, "lane": 2},
{"spawn_time": 223.328, "lane": 3},
{"spawn_time": 223.776, "lane": 4},
{"spawn_time": 223.989, "lane": 1},
{"spawn_time": 224.235, "lane": 2},
{"spawn_time": 224.672, "lane": 3},
{"spawn_time": 225.120, "lane": 4},
{"spawn_time": 225.557, "lane": 1},
{"spawn_time": 226.016, "lane": 2},
{"spawn_time": 226.453, "lane": 3},
{"spawn_time": 226.912, "lane": 4},
{"spawn_time": 227.157, "lane": 1},
{"spawn_time": 227.360, "lane": 2},
{"spawn_time": 227.371, "lane": 3},
{"spawn_time": 227.808, "lane": 4},
{"spawn_time": 228.256, "lane": 1},
{"spawn_time": 228.267, "lane": 2},
{"spawn_time": 228.501, "lane": 3},
{"spawn_time": 228.704, "lane": 4},
{"spawn_time": 228.747, "lane": 1},
{"spawn_time": 229.173, "lane": 2},
{"spawn_time": 229.621, "lane": 3},
{"spawn_time": 230.069, "lane": 4},
{"spawn_time": 230.507, "lane": 1},
{"spawn_time": 230.539, "lane": 2},
{"spawn_time": 230.763, "lane": 3},
{"spawn_time": 230.955, "lane": 4},
{"spawn_time": 230.965, "lane": 1},
{"spawn_time": 231.413, "lane": 2},
{"spawn_time": 231.861, "lane": 3},
{"spawn_time": 231.872, "lane": 4},
{"spawn_time": 232.117, "lane": 1},
{"spawn_time": 232.309, "lane": 2},
{"spawn_time": 232.565, "lane": 3},
{"spawn_time": 232.768, "lane": 4},
{"spawn_time": 233.216, "lane": 1},
{"spawn_time": 233.653, "lane": 2},
{"spawn_time": 233.664, "lane": 3},
{"spawn_time": 233.877, "lane": 4},
{"spawn_time": 234.144, "lane": 1},
{"spawn_time": 234.592, "lane": 2},
{"spawn_time": 234.816, "lane": 3},
{"spawn_time": 235.040, "lane": 4},
{"spawn_time": 235.477, "lane": 1},
{"spawn_time": 235.488, "lane": 2},
{"spawn_time": 235.925, "lane": 3},
{"spawn_time": 236.149, "lane": 4},
{"spawn_time": 236.384, "lane": 1},
{"spawn_time": 236.832, "lane": 2},
{"spawn_time": 237.280, "lane": 3},
{"spawn_time": 237.291, "lane": 4},
{"spawn_time": 237.728, "lane": 1},
{"spawn_time": 238.187, "lane": 2},
{"spawn_time": 238.645, "lane": 3},
{"spawn_time": 239.093, "lane": 4},
{"spawn_time": 239.307, "lane": 1},
{"spawn_time": 239.541, "lane": 2},
{"spawn_time": 239.765, "lane": 3},
{"spawn_time": 240.000, "lane": 4},
{"spawn_time": 240.437, "lane": 1},
{"spawn_time": 240.885, "lane": 2},
{"spawn_time": 241.344, "lane": 3},
{"spawn_time": 241.803, "lane": 4},
{"spawn_time": 242.037, "lane": 1},
{"spawn_time": 242.261, "lane": 2},
{"spawn_time": 242.699, "lane": 3},
{"spawn_time": 242.709, "lane": 4},
{"spawn_time": 242.944, "lane": 1},
{"spawn_time": 243.136, "lane": 2},
{"spawn_time": 243.147, "lane": 3},
{"spawn_time": 243.392, "lane": 4},
{"spawn_time": 243.605, "lane": 1},
{"spawn_time": 244.053, "lane": 2},
{"spawn_time": 244.064, "lane": 3},
{"spawn_time": 244.277, "lane": 4},
{"spawn_time": 244.501, "lane": 1},
{"spawn_time": 244.512, "lane": 2},
{"spawn_time": 244.960, "lane": 3},
{"spawn_time": 245.195, "lane": 4},
{"spawn_time": 245.408, "lane": 1},
{"spawn_time": 245.419, "lane": 2},
{"spawn_time": 245.653, "lane": 3},
{"spawn_time": 245.867, "lane": 4},
{"spawn_time": 246.304, "lane": 1},
{"spawn_time": 246.315, "lane": 2},
{"spawn_time": 246.539, "lane": 3},
{"spawn_time": 246.752, "lane": 4},
{"spawn_time": 247.211, "lane": 1},
{"spawn_time": 247.221, "lane": 2},
{"spawn_time": 247.669, "lane": 3},
{"spawn_time": 248.117, "lane": 4},
{"spawn_time": 248.555, "lane": 1},
{"spawn_time": 248.800, "lane": 2},
{"spawn_time": 249.024, "lane": 3},
{"spawn_time": 249.472, "lane": 4},
{"spawn_time": 249.909, "lane": 1},
{"spawn_time": 249.920, "lane": 2},
{"spawn_time": 250.368, "lane": 3},
{"spawn_time": 250.592, "lane": 4},
{"spawn_time": 250.805, "lane": 1},
{"spawn_time": 251.264, "lane": 2},
{"spawn_time": 251.712, "lane": 3},
{"spawn_time": 251.723, "lane": 4},
{"spawn_time": 252.171, "lane": 1},
{"spawn_time": 252.619, "lane": 2},
{"spawn_time": 253.077, "lane": 3},
{"spawn_time": 253.323, "lane": 4},
{"spawn_time": 253.515, "lane": 1},
{"spawn_time": 253.771, "lane": 2},
{"spawn_time": 253.973, "lane": 3},
{"spawn_time": 254.219, "lane": 4},
{"spawn_time": 254.421, "lane": 1},
{"spawn_time": 254.869, "lane": 2},
{"spawn_time": 255.328, "lane": 3},
]

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
		
		if audio_stream.stream.resource_path == "res://songs_mp3/Shiawase.mp3": 
			selected_chart = shiawase_chart
		elif audio_stream.stream.resource_path == "res://songs_mp3/Shine as usual.mp3":
			selected_chart = shine_as_usual_chart
		audio_stream.play() 
	


func _process(_delta: float) -> void:
	score_text.text = "Score: " + str(score)
	if audio_stream.is_playing():
		current_time = audio_stream.get_playback_position()
		
		for i in range(selected_chart.size() - 1, -1, -1):
			var note_data = selected_chart[i]
			
			if current_time >= note_data["spawn_time"]:
				_spawn_note_in_lane(note_data["lane"], note_data["spawn_time"])
				selected_chart.remove_at(i)
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
				
				if timing_discrepancy <= 0.1:
					score += 5
					current_fx.process_material.color = Color.GREEN
					print(score)
				elif timing_discrepancy <= 0.15:
					score += 3
					current_fx.process_material.color = Color.DEEP_SKY_BLUE
					print(score)
				elif timing_discrepancy <= 0.3:
					score += 1
					current_fx.process_material.color = Color.RED
					print(score)
				elif timing_discrepancy <= 0.5:
					current_fx.process_material.color = Color.GRAY
					print(score)
				else:
					score -= 1
					current_fx.process_material.color = Color.DARK_RED
					print(score)
				
				active_lane_notes.pop_front() #erases index 0, shifting upcoming notes up
				target_note.queue_free()      #deletes the visual node from the screen
	
