h = 100
w = 800

paintAt = (data, idx, ink) ->
        data.data[idx] = ink[0]
        data.data[idx+1] = ink[1]
        data.data[idx+2] = ink[2]
        data.data[idx+3] = ink[3]

class Timeline
        constructor: (t0 = 0) ->
                @t = t0
                @objs = []
        add: (obj) => @objs.push obj
        tick: =>
                _.each @objs, (o) => o.tick @t
                @t = @t + 1 % 10000
                @start()
        start: => setTimeout @tick, 20

f = (x, y, t) ->
        r = Math.sqrt Math.pow(x, 2) + Math.pow(y, 2)
        th = Math.atan(y/x)
        (1+Math.cos(r*t*Math.PI/10000*2)*Math.exp(Math.abs(th)))/2

class Flipper
        constructor: (ctx, x, y, w) ->
                @ctx = ctx
                @x = x
                @y = y
                @x0 = x - w
                @y0 = y - w
                @w  = w
                @idxs = _.flatten ([x, y, (x + y*@w)*4] for x in [0...@w] for y in [0...@w]), true
                @t = 0
                @on = false
                @data = @ctx.createImageData w, w
                @flipping = 1

        flipLength: 4
        write: => @ctx.putImageData(@data, @x0, @y0)
        tick: (t) =>
                ink = 255*(1-0.3*f(@x-w/2+150, Math.pow(Math.abs(@y-h/2+80),1.5), t))
                _.each @idxs, (val) =>
                        [x, y, idx] = val
                        paintAt(@data, idx, [ink, ink, ink, 255])
                @write()

canvas = $("#write")[0]
canvas.height = 70
canvas.width = 1200
ctx = canvas.getContext("2d")

x = (coord) -> canvas.width*coord/140
y = (coord) -> 2 + canvas.height*coord/20

window.tl = new Timeline
window.tl.add (new Flipper ctx, x(i), y(j), 1) for i in [0..140] for j in [0..20]
window.tl.start()