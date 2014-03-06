Waveform = require '../lib/waveform'


waveform = new Waveform './song.raw',
  w: 500
  h: 100
  backgroundColor: '#eeeeee'
  waveColor: '#333333'


waveform.render ->
  waveform.save './output.png'