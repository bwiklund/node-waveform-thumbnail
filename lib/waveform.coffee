fs = require 'fs'
Canvas = require 'canvas'


module.exports = ->

  canvas = new Canvas 200,200
  ctx = canvas.getContext '2d'

  ctx.fillStyle = 'yellow'
  ctx.fillRect 0,0,200,200

  out = fs.createWriteStream 'output.png'
  stream = canvas.pngStream()
  stream.on 'data', out.write.bind out
  stream.on 'end', -> console.log 'done'