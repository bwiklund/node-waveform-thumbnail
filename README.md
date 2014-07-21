# Waveform

![Node waveform image generator](/docs/example.png)

A simple audio waveform image generator with no hard dependencies outside npm.

Just convert your audio to 32 bit little endian raw before converting. How you accomplish this depends on your platform, but here's how to do it with `sox`:

```
sox foo.mp3 --bits 32 --encoding signed-integer --endian little foo.raw remix 1,2
```

Currently I can't find and modules in NPM that will do this conversion for us without installing / compiling tools outside npm first. So I built this to work well in conjunction with `sox`, which is pretty well supported everywhere.

# Basic usage

```javascript
var Waveform = require('waveform');
var waveform = new Waveform( './someAudio.raw' );
waveform.renderAndSave( './prettyImage.png', function(err){
  console.log( "neato!" )
});
```

If you want more control, you can set color options.

```javascript
//...
var waveform = new Waveform( './someAudio.raw', {
  w: 500,
  h: 100,
  backgroundColor: '#333',
  waveColor: '#fff'
});
//...
```

You can also define your own gradient. This is the default one:

```javascript
//...
var waveform = new Waveform( './someAudio.raw', {
  w: 500,
  h: 100,
  backgroundColor: '#333',
  waveColor: [
    {stop: 0,   color: "#333"},
    {stop: 0.5, color: "#333"},
    {stop: 0.5, color: "#444"},
    {stop: 1,   color: "#eee"}
  ]
});
//...
```

This tool is built on top of node canvas, and that canvas object is exposed if you want to do stuff with it before saving.

```javascript
//...
waveform.render( function(err, ctx){
  ctx.fillStyle = 'red';
  ctx.fillRect( 0,0,10,10 );
  // etc

  waveform.save( './myWaveformAndRedBox.png', function(err){
    console.log( "yay" );
  })
});

If you have trouble node-canvas running on OSX: [https://github.com/Automattic/node-canvas/wiki/Installation---OSX]

Pull requests and bug reports are very welcome. Thanks!
