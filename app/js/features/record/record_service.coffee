angular.module('songaday')


.factory 'RecordService', ($rootScope,$window, $http) ->
  WORKER_PATH = 'js/recorderWorker.js'
  encoderWorker = new Worker('js/mp3Worker.js')
  Recorder : (source, cfg) ->
    config = cfg or {}
    bufferLen = config.bufferLen or 4096

    encode64 = (buffer) ->
      binary = ''
      bytes = new Uint8Array(buffer)
      len = bytes.byteLength
      i = 0
      while i < len
        binary += String.fromCharCode(bytes[i])
        i++
      window.btoa binary

    parseWav = (wav) ->

      readInt = (i, bytes) ->
        ret = 0
        shft = 0
        while bytes
          ret += wav[i] << shft
          shft += 8
          i++
          bytes--
        ret

      if readInt(20, 2) != 1
        throw 'Invalid compression code, not PCM'
      if readInt(22, 2) != 1
        throw 'Invalid number of channels, not 1'
      {
        sampleRate: readInt(24, 4)
        bitsPerSample: readInt(34, 2)
        samples: wav.subarray(44)
      }

    Uint8ArrayToFloat32Array = (u8a) ->
      f32Buffer = new Float32Array(u8a.length)
      i = 0
      while i < u8a.length
        value = u8a[i << 1] + (u8a[(i << 1) + 1] << 8)
        if value >= 0x8000
          value |= ~0x7FFF
        f32Buffer[i] = value / 0x8000
        i++
      f32Buffer

    uploadAudio = (mp3Data) ->
      reader = new FileReader

      reader.onload = (event) ->
        fd = new FormData
        mp3Name = encodeURIComponent('audio_recording_' + (new Date).getTime() + '.mp3')
        console.log 'mp3name = ' + mp3Name
        fd.append 'fname', mp3Name
        fd.append 'data', event.target.result
        $.ajax(
          type: 'POST'
          url: 'upload.php'
          data: fd
          processData: false
          contentType: false).done (data) ->
          #console.log(data);
          log.innerHTML += '\n' + data
          return
        return

      reader.readAsDataURL mp3Data
      return

    @context = source.context
    @node = (@context.createScriptProcessor or @context.createJavaScriptNode).call(@context, bufferLen, 2, 2)
    worker = new Worker(config.workerPath or WORKER_PATH)
    worker.postMessage
      command: 'init'
      config: sampleRate: @context.sampleRate
    recording = false
    currCallback = undefined

    @node.onaudioprocess = (e) ->
      if !recording
        return
      worker.postMessage
        command: 'record'
        buffer: [ e.inputBuffer.getChannelData(0) ]
      return

    @configure = (cfg) ->
      for prop of cfg
        if cfg.hasOwnProperty(prop)
          config[prop] = cfg[prop]
      return

    @record = ->
      recording = true
      return

    @stop = ->
      recording = false
      return

    @clear = ->
      worker.postMessage command: 'clear'
      return

    @getBuffer = (cb) ->
      currCallback = cb or config.callback
      worker.postMessage command: 'getBuffer'
      return

    @exportWAV = (cb, type) ->
      currCallback = cb or config.callback
      type = type or config.type or 'audio/wav'
      if !currCallback
        throw new Error('Callback not set')
      worker.postMessage
        command: 'exportWAV'
        type: type
      return

    #Mp3 conversion

    worker.onmessage = (e) ->
      blob = e.data
      console.log("the blob " +  blob + " " + blob.size + " " + blob.type);
      arrayBuffer = undefined
      fileReader = new FileReader

      fileReader.onload = ->
        arrayBuffer = @result
        buffer = new Uint8Array(arrayBuffer)
        data = parseWav(buffer)
        console.log 'Converting to Mp3'
        encoderWorker.postMessage
          cmd: 'init'
          config:
            mode: 3
            channels: 1
            samplerate: data.sampleRate
            bitrate: data.bitsPerSample
        encoderWorker.postMessage
          cmd: 'encode'
          buf: Uint8ArrayToFloat32Array(data.samples)
        encoderWorker.postMessage cmd: 'finish'

        encoderWorker.onmessage = (e) ->
          if e.data.cmd == 'data'
            console.log 'Done converting to Mp3'
            console.log($rootScope)
            $rootScope.onCompleteEncode(e)
          return

        return

      fileReader.readAsArrayBuffer blob
      currCallback blob
      return

    source.connect @node
    @node.connect @context.destination
  #this should not be necessary
