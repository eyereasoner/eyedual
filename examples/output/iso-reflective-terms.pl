report(shape, shape(event, 2)).
report(payload, reading(temperature, 21)).
report(parts, [event, sensor_7, reading(temperature, 21)]).
report(rebuilt, alert(sensor_7, high)).
report(variable_count, 3).
report(copied_shape, same_but_fresh).
report(order, <).
