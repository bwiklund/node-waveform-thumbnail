_ = require 'lodash'
fs = require 'fs'
Canvas = require 'canvas'



# turn a dense array of numbers into a 
# shorter one with windowed average values
reduceDensity = (arr,density) ->
  reducedPoints = []
  for p,i in arr
    j = ~~( i / arr.length * density )
    reducedPoints[j] ?= 0
    reducedPoints[j] += Math.abs arr[i] * density / arr.length
  reducedPoints



# simple audio loader helper
loadAudio = (path, density, done) ->
  fs.readFile path, (err,raw) =>
    points = for i in [0...raw.length/4]
      raw.readInt32LE(i*4) / 0xffffffff * 8
    points = reduceDensity points, density
    done null, points



class Waveform
  constructor: (@path,options) ->
    defaults =
      w: 500
      h: 100
      backgroundColor: '#eeeeee'
      waveColor: '#333333'

    @options = _.extend defaults, options



  render: (done) ->
    loadAudio @path, @options.w, (err, points) =>

      # canvas setup
      {w,h} = @options
      @canvas = new Canvas w,h
      @ctx = @canvas.getContext '2d'

      # background
      grd = @ctx.createLinearGradient 0,0,0,h
      grd.addColorStop 0, "#333"
      grd.addColorStop 1, "#444"
      @ctx.fillStyle = @options.backgroundColor
      @ctx.fillRect 0,0,w,h

      # wave path
      @ctx.beginPath()

      @ctx.moveTo 0, h/2

      for p,i in points
        x = i / points.length * w
        y = h/2 - p * h/2
        @ctx.lineTo x, y

      @ctx.lineTo w, h

      for p,i in points by -1
        x = i / points.length * w
        y = h/2 + p * h/2
        @ctx.lineTo x, y

      @ctx.lineTo 0, h/2

      grd = @ctx.createLinearGradient 0,0,0,h
      grd.addColorStop 0, "#333"
      grd.addColorStop 0.5, "#333"
      grd.addColorStop 0.5, "#444"
      grd.addColorStop 1, "#eee"
      @ctx.fillStyle = grd# @options.backgroundColor
      @ctx.fill()

      done()


  save: (path,done) ->
    out = fs.createWriteStream path
    stream = @canvas.pngStream()
    stream.on 'data', out.write.bind out
    stream.on 'end', -> done && done()


  
module.exports = Waveform