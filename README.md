# hyrax-active_encode
Hyrax plugin to enable audiovisual derivative generation through [active_encode](https://github.com/samvera-labs/active_encode).

## Installation

Add this line to your application's Gemfile:

```
gem 'hyrax-active_encode'
```

And then execute:

    $ bundle
    
## Usage

To enable derivative generation through `active_encode` run the install generator which will modify the generated `FileSet` model:

    $ rails g hyrax:active_encode:install
    
## Configuration

By default, hyrax-active_encode will use ActiveEncode's FFmpeg adapter and default ffmpeg options which will generate derivatives matching the defaults in Hyrax.

`Hyrax::ActiveEncode::ActiveEncodeDerivativeService` can be passed an option service which should return the output options array that will be passed to Hydra-Derivatives and then to ActiveEncode.  See (https://github.com/samvera-labs/hyrax-active_encode/blob/master/app/services/hyrax/active_encode/default_option_service.rb) for the default option service.

`Hyrax::ActiveEncode::ActiveEncodeDerivativeService` can also be passed the ActiveEncode encode class to be used.  By default this will be `ActiveEncode::Base`.

