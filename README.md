# Waveform

![Node waveform image generator](/docs/example.png)

A simple audio waveform image generator with no dependencies outside npm.

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
