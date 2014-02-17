require "xml2csv/version"

require "csv"
require "digest"

require "nokogiri"
require "slop"
require "active_support/core_ext"

module XML2CSV
  module_function
  def get_content(node, param)
    key, values = param.to_a.first

    case key
    when "join"
      values.split(/,/).map{|value|
        node.xpath(value).map{|v| v.content.chomp}.join("-")
      }.join("_")
    when "pair"
      values.split(/,/).map{|value|
        node.xpath(value).map{|v| v.content.chomp}
      }
    when "with"
      wkey, wvalues = values.split(/:/, 2)

      wvalues.split(/,/).map{|value|
        node.xpath([wkey, value].join("/")).map{|v| v.content.chomp}.join("-")
      }
    when "digest"
      keys = values.split(/,/).map{|value|
        node.xpath(value).map{|v| v.content.chomp}
      }

      Digest::MD5.hexdigest keys.join
    when "with_order"
      ret = values.split(/,/).map{|value|
        if v = node.at_xpath(value)
          v.content.chomp
        else
          ""
        end
      }

      ret.empty? ? nil : ret.unshift(node.parent.children.index(node))
    else
      values.split(/,/).map{|value|
        case key
        when "tag"
          value
        when "node", "xpath" then
          ret = node.xpath(value).map{|v| v.content.chomp}
          ret.empty? ? nil : ret
        when "attr" then
          ret = node[value]
          ret.nil? ? nil : ret.chomp
        end
      }
    end
  end

  def parse_xml(xml_io, root_node, parameters)
    Nokogiri::XML(xml_io).xpath("//#{root_node}").map do |node|
      parameters.flat_map{|param|
        get_content(node, param)
      }
    end
  end

  def parse_params(argv)
    Hash[*argv.split(/:/, 2)]
  end

  def xml2csv
    Signal.trap("PIPE", "EXIT")

    args = Slop.parse{
      on :h, :help
      on :F=, '[field separater]'
      on :"no-header"
    }.to_hash

    if args.delete(:help)
      puts HELP
      exit
    end

    if col_sep = args.delete(:F)
      ["-F", col_sep].each{|s| ARGV.delete s}
      col_sep = eval %Q{"#{col_sep}"}
    end

    if no_header = args.delete(:"no-header")
      ARGV.delete "--no-header"
    end

    xml_io     = $stdin.tty? ? File.read(ARGV.shift) : $stdin.read
    root_node  = ARGV.shift
    parameters = ARGV.map{|argv| parse_params(argv)}

    header = parameters.map{|h|
      h.each_pair.map{|k,v|
        v.split(/,/).map{|_v| File.basename _v}
      }
    }.flatten

    csv_options = {force_quotes: true, headers: header, write_headers: true}

    if col_sep
      csv_options.merge! col_sep: col_sep
      csv_options.delete :force_quotes
    end

    if no_header
      [:headers, :write_headers].each{|key|
        csv_options.delete key
      }
    end

    print CSV.generate("", csv_options){|csv|
      parse_xml(xml_io, root_node, parameters).each{|row|
        row = row.flatten
        csv << row unless row.blank?
      }
    }
  end
end
