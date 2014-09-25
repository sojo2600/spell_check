# SpellCheck

This gem will check to see if an word exists in its text dictionary.  It will accept any case input and will correct
any over or under repeated characters.

## Installation

Add this line to your application's Gemfile:

    gem 'spell_check'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spell_check

## Usage

checkWord(word)  The parameter is the word you want to have corrected.  If the word is spelled correctly, your word will
be returned to you.  If not, it will attempt to correct the case and repetition of characters.  If no correction
is found, you will be notified.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/spell_check/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
