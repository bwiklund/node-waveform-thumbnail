fs = require 'fs'
Canvas = require 'canvas'



class AudioLoader
  constructor: ->
    @points = ( Math.random() * 2 - 1 for i in [0..10000] )

  # to make cheaper, less fuzzy waveforms
  reduceDensity: (total) ->
    reducedPoints = []
    for p,i in @points
      j = ~~( i / @points.length * total )
      reducedPoints[j] ?= 0
      reducedPoints[j] += Math.abs @points[j] * total / @points.length
    @points = reducedPoints



class Waveform
  constructor: ->
    @options =
      w: 500
      h: 100
      backgroundColor: '#eeeeee'
      waveColor: '#333333'


  # mocked for now
  loadAudio: ->
    audioLoader = new AudioLoader()
    audioLoader.reduceDensity @options.w
    @points = audioLoader.points


  render: ->
    @loadAudio()

    # canvas setup
    {w,h} = @options
    @canvas = new Canvas w,h
    @ctx = @canvas.getContext '2d'

    # background
    @ctx.fillStyle = @options.backgroundColor
    @ctx.fillRect 0,0,w,h

    # wave path
    @ctx.beginPath()

    @ctx.moveTo 0, h/2

    for p,i in @points
      x = i / @points.length * w
      y = p * h
      @ctx.lineTo x, y

    @ctx.lineTo w, h

    for p,i in @points by -1
      x = i / @points.length * w
      y = h - p * h
      @ctx.lineTo x, y

    @ctx.lineTo 0, h/2

    @ctx.fillStyle = @options.waveColor
    @ctx.fill()


  save: ->
    out = fs.createWriteStream 'output.png'
    stream = @canvas.pngStream()
    stream.on 'data', out.write.bind out
    stream.on 'end', -> console.log 'done'


  
module.exports = Waveform