fs = require 'fs'
Canvas = require 'canvas'



class AudioLoader
  constructor: (@path) ->
    # @points = ( Math.random() * 2 - 1 for i in [0..10000] )

  load: (done) ->
    fs.readFile @path, (err,raw) =>
      @points = for i in [0...raw.length/4]
        raw.readInt32LE(i*4) / 0xffffffff * 8

      done()

  # to make cheaper, less fuzzy waveforms
  reduceDensity: (total) ->
    reducedPoints = []
    for p,i in @points
      j = ~~( i / @points.length * total )
      reducedPoints[j] ?= 0
      reducedPoints[j] += Math.abs @points[i] * total / @points.length
    @points = reducedPoints
    # console.log @points



class Waveform
  constructor: (@path) ->
    @options =
      w: 500
      h: 100
      backgroundColor: '#eeeeee'
      waveColor: '#333333'


  # mocked for now
  loadAudio: (done) ->
    audioLoader = new AudioLoader @path
    audioLoader.load =>
      audioLoader.reduceDensity @options.w
      @points = audioLoader.points
      done()


  render: (done) ->
    @loadAudio =>

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
        y = h/2 - p * h/2
        @ctx.lineTo x, y

      @ctx.lineTo w, h

      for p,i in @points by -1
        x = i / @points.length * w
        y = h/2 + p * h/2
        @ctx.lineTo x, y

      @ctx.lineTo 0, h/2

      @ctx.fillStyle = @options.waveColor
      @ctx.fill()

      console.log 'loaded'
      done()


  save: ->
    out = fs.createWriteStream 'output.png'
    stream = @canvas.pngStream()
    stream.on 'data', out.write.bind out
    stream.on 'end', -> console.log 'done'


  
module.exports = Waveform