h = 100
w = 800
stroke = 5000

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
        start: => setTimeout @tick, stroke

f = (x, y, t) ->
        x = x-w/2+150
        y = Math.pow(Math.abs(y-h/2+80),1.5)
        r = Math.sqrt Math.pow(x, 2) + Math.pow(y, 2)
        th = Math.atan(y/x)
        (1+Math.cos(r*(t+100)*Math.PI/10000*15)*Math.exp(-Math.abs(th)))/2

class Flipper
        constructor: (svg, x, y) ->
                @x = x
                @y = y
                @el = svg.selectAll('circle').data([{x: @x, y: @y}]).enter().append('circle')
                @el.attr 'class', @class

        # tick: (t) =>
        #         t = @el.transition()
        #         t.duration stroke
        #         t.attr 'r', Math.pow(5*f(@x, @y, t), 3)

svg = d3.select('#frame').append "svg"

width = svg.style('width').slice(0,-2)
height = svg.style('height').slice(0,-2)
x = (coord) -> 15 + width*coord/30
y = (coord) -> 9 + height*coord/4

dat = _.flatten (x: x(i), y: y(j) for i in [0..30] for j in [0..4]), true

svg.selectAll('circle').data(dat)
        .enter().append('circle')
        .attr('r', 0.5)
        .attr('cx', (d) -> d.x)
        .attr('cy', (d) -> d.y)
        .attr('stroke', 'rgba(0,0,0,0)')
        .attr('fill', 'rgba(0, 0, 0, 0.6)')

tick = (t) ->
        svg.selectAll('circle')
        .transition()
        .ease("poly-in-out", 2)
        .duration(stroke)
        .attr('r', (d) -> Math.pow(3*f(d.x, d.y, t), 5))

        setTimeout (() -> tick (t+stroke)), stroke*6

tick(Math.random()*stroke*2)