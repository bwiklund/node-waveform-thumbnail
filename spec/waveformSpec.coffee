# a pretty janky testing setup. used to generate test images to be confirmed by human eyeballs.

Waveform = require '../lib/waveform'

waveform1 = new Waveform './song.raw',
  w: 500
  h: 100

waveform2 = new Waveform './song.raw',
  w: 500
  h: 100
  backgroundColor: '#eeeeee'
  waveColor: '#333333'

waveform3 = new Waveform './song.raw',
  w: 500
  h: 100
  backgroundColor: '#eeeeee'
  waveColor: [
    {stop: 0, color: 'red'}
    {stop: 1, color: 'blue'}
  ]

waveform1.render ->
  waveform1.save './outputDefault.png'

waveform2.render ->
  waveform2.save './outputSolid.png'

waveform3.render ->
  waveform3.save './outputGradient.png'
