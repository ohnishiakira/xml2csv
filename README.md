# xml2csv

  xml2csv - Convert XML to CSV

## Installation

Add this line to your application's Gemfile:

    gem 'xml2csv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xml2csv

## Usage

### Synopsis
  $ xml2csv [-F sep] [--no-hedaer] [xml_file] [root_node] [params...]

### Options
  -F _sep_
    set _sep_ as a field delimiter (default ",")

  --no-header
    Do not print header.
    Default header is generated from params.

  xml_file
    path to XML file.

  root_node
    Set XML node name.
    Expression's path are written relative to the _root_node_(see below.)

  params
    type:Expression[,...]

    Describe node name, attribute, xpath, etc...
    Expression can be written with delimiter ",".

    _type_ are any of the following.

    node
      Describe node name.

    xpath
      Same with _node_.
      Describe explicitly that it is a XPath.

    attr
      Describe attribute.

    tag
      Describe any characters.
      You can use this when you add output CSV column that is not exist in XML.

    join
      Describe Expressions.
      Join Expressions with "_".

    pair
      Describe Expressions.
      Expressions arranged in pairs.

    with
      with:base_node:Expression[,...]
      You can short cut long Expression.

    with_order
      with:Expression[,...]
      Add Expression's order from parent element as output CSV's first column.

## Todo
- Improve poor English.
- Refacotring.
- Should reconsider the raison d'etre of join, pair, with.
  (They are still exist for historical reasons.)

## Contributing

1. Fork it ( http://github.com/ohnishiakira/xml2csv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
