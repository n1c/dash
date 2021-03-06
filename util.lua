
-- http://love2d.org/wiki/General_math
function math.dist(x1, y1, x2, y2)
  return ((x2-x1)^2 + (y2-y1)^2)^0.5
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end
