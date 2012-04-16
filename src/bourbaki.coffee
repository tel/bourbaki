h = 100
w = 800
stroke = 5000

d3.selection.prototype.attrs = (obj) ->
        this.attr(key, val) for key, val of obj
        this

d3.selection.prototype.styles = (obj) ->
        this.style(key, val) for key, val of obj
        this

f = (x, y, t) ->
        x = x-w/2+150
        y = Math.pow(Math.abs(y-h/2+80),1.5)
        r = Math.sqrt Math.pow(x, 2) + Math.pow(y, 2)
        th = Math.atan(y/x)
        scaled = (1+Math.cos(r*(t+100)*Math.PI/10000*15)*Math.exp(-Math.abs(th)))/2
        Math.pow(3*scaled, 5)

svg = d3.select('#frame').append("svg")

width = 440
height = 70 # svg.style('height').slice(0,-2)

x = (coord) -> 15 + width*coord/30
y = (coord) -> 9 + height*coord/4

dat = _.flatten (x: i, y: j for i in [0..30] for j in [0..4]), true

svg.selectAll('circle').data(dat)
        .enter().append('circle')
        .attrs
                r: (d) -> f(x(d.x), y(d.y), Math.random()*stroke)
                cx: (d) -> x(d.x)
                cy: (d) -> y(d.y)
                stroke: 'rgba(0,0,0,0)'
                fill: (d) ->
                        if (d.x + d.y) % 4 == 1
                        then 'rgba(0,186,251,0.6)'
                        else 'rgba(0, 0, 0, 0.6)'

tick = (t) ->
        svg.selectAll('circle')
        .transition()
        .ease("poly-in-out", 2)
        .duration(stroke)
        .attr 'r', (d) -> f(x(d.x), y(d.y), t)

        setTimeout (() -> tick (t+stroke)), stroke*6

setTimeout (() -> tick(Math.random()*stroke*2)), stroke

# overlay = d3.select('#overlay')
# overlay.styles
#         'z-index': 3
#         position: 'absolute'
#         top: 0
#         left: 0
#         height: '2000px'
#         width: '100%'
#         overflow: 'hidden'
# overlay.selectAll('bar').data([0..700])
#         .enter().append('div')
#         .styles(
#                 display: 'block'
#                 position: 'absolute'
#                 top: (d) -> 10*2*d + 'px'
#                 left: 0
#                 height: '10px'
#                 width: '100%'
#                 background: 'rgba(255,0,0,0.2)')