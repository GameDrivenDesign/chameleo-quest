extends Resource

static func lerp_angle(a, b, t):
	if abs(a - b) >= PI:
		if a > b:
			a = a - 2.0 * PI
		else:
			b = b - 2.0 * PI
	return lerp(a, b, t)

static func normalize_angle(x):
	return fposmod(x + PI, 2.0 * PI) - PI