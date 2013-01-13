# Dropcam

RubyGem to access Dropcam account and Camera including direct live stream access

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/nolanbrown/dropcam)


## Installation

Add this line to your application's Gemfile:

    gem 'dropcam'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dropcam

## Usage

	require 'dropcam'
	
	dropcam = Dropcam::Dropcam.new("<USERNAME>","<PASSWORD>")
	camera = dropcam.cameras.first
	
	# returns jpg image data of the latest frame captured
	screenshot = camera.screenshot.current
	
	# write data to disk
	File.open("#{camera.title}.jpg", 'w') {|f| f.write(screenshot) }
	
	# access and modify settings
	# this disables the watermark on your camera stream
	settings = camera.settings
	settings["watermark.enabled"].set(false)


## Live Stream

**Streaming isn't directly integrated currently and it's up to you to find a player. Some of the players available:**
	
- VLC (RTSP/RTMP)
- RTMPDump (RTMP)
- openRTSP (RTSP)

The easiest way to record the live camera stream is with RTMPDump. Install via homebrew:
	
	`$ brew install rtmpdump`

To save a live stream:

	require 'dropcam'
	dropcam = Dropcam::Dropcam.new("<USERNAME>","<PASSWORD>")
	camera = dropcam.cameras.first
	
	# record the live stream for 30 seconds
	camera.stream.save_live("#{camera.title}.flv", 30)
	
	# to get access information to use a third party application
	# RTMP/Flash Streaming
	camera.stream.rtmp_details
	
	# RTSP Streaming
	camera.stream.rtsp_details
	

Currently stream resolution is limited to 400x240.



## NOTES: ##

The Dropcam API is unofficial and unreleased. This code can break at anytime as Dropcam changes/updates their service. 

This gem has only been tested on Mac OS 10.8 running Ruby 1.9.3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
