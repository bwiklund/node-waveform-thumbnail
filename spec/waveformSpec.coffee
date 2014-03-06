Waveform = require '../lib/waveform'


waveform = new Waveform './song.raw'


waveform.render ->
  waveform.save()