package main

import "core:math"
import "vendor:raylib"

CIRCLE_RADIUS :: 4

circle_upper_half :: proc "contextless" (x: f32) -> f32 {
	return math.sqrt(CIRCLE_RADIUS * CIRCLE_RADIUS - x * x)
}

circle_bottom_half :: proc "contextless" (x: f32) -> f32 {
	return -math.sqrt(CIRCLE_RADIUS * CIRCLE_RADIUS - x * x)
}

BACKGROUND :: raylib.Color{0x1a, 0x1b, 0x26, 0xff}
FOREGROUND :: raylib.Color{0x7a, 0xa2, 0xf7, 0xff}
THICKNESS :: 4

Function :: proc "contextless" (x: f32) -> f32

FUNCTIONS :: [?]Function{circle_upper_half, circle_bottom_half}

main :: proc() {
	raylib.SetConfigFlags({.WINDOW_RESIZABLE})

	raylib.InitWindow(800, 600, "Sword")

	raylib.SetTargetFPS(60)

	camera: raylib.Camera2D = {
		target = 0.0,
		zoom   = 10.0,
	}

	for !raylib.WindowShouldClose() {
		width, height := raylib.GetScreenWidth(), raylib.GetScreenHeight()

		camera.offset = {f32(width) / 2, f32(height) / 2}

		if raylib.IsKeyDown(.Z) && camera.zoom < 100 {
			camera.zoom += 1
		}

		if raylib.IsKeyDown(.X) && camera.zoom > 5 {
			camera.zoom -= 1
		}

		if raylib.IsKeyDown(.W) {
			camera.target.y -= 1
		}

		if raylib.IsKeyDown(.S) {
			camera.target.y += 1
		}

		if raylib.IsKeyDown(.A) {
			camera.target.x -= 1
		}

		if raylib.IsKeyDown(.D) {
			camera.target.x += 1
		}

		raylib.BeginDrawing()

		raylib.ClearBackground(BACKGROUND)

		for sx in 0 ..< raylib.GetScreenWidth() {
			for f in FUNCTIONS {
				w := raylib.GetScreenToWorld2D({f32(sx), 0}, camera)
				s := raylib.GetWorldToScreen2D({w.x, -f(w.x)}, camera)

				raylib.DrawLineEx(s - 1, s, THICKNESS, FOREGROUND)
			}
		}

		raylib.EndDrawing()
	}

	raylib.CloseWindow()
}

