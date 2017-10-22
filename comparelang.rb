require 'optparse'
require "yaml_converters"

ignoreRuleIds = [ "UPPERCASE_SENTENCE_START" ]

options = {
	"sourcelanguage" => "en",
	"comparelanguage" => "sv",
	"path" => "../ifme"
}

OptionParser.new do |opts|
	opts.banner = "Usage: comparelang.rb [options]\nCompares two languages for missing keys\n\n"

	opts.on("-s", "--sourcelanguage LANGUAGE", "Language code (default: en)") { |v| options["sourcelanguage"] = v }
	opts.on("-c", "--comparelanguage LANGUAGE", "Language code (default: sv)") { |v| options["comparelanguage"] = v }
	opts.on("-p", "--path PATH", "Path to if me checkout (default: ../ifme)") { |v| options["path"] = v }

end.parse!

localePath = File.join(options["path"], "config", "locales")

unless File.directory?(localePath)
	puts "Error: #{localePath} isn't a valid folder"
	exit
end

Dir.glob(localePath + "/*" + options["sourcelanguage"] + ".yml").each do |lf|
	f = lf.dup
	f = f.sub! localePath + '/', ''
	cf = lf.dup
	cf = cf.sub! options["sourcelanguage"] + '.', options["comparelanguage"] + '.'
	c = cf.dup
	c = c.sub! localePath + '/', ''

	puts "Processing: " + f + ' vs ' + c
	puts "----"
	unless File.file?(cf)
		puts "File doesn't exist " + cf
	else
		syaml_reader = YamlConverters::YamlFileReader.new(lf)
		sconverter = YamlConverters::YamlToSegmentsConverter.new(
			syaml_reader, YamlConverters::SegmentToHashWriter.new
		)

		cyaml_reader = YamlConverters::YamlFileReader.new(cf)
		cconverter = YamlConverters::YamlToSegmentsConverter.new(
			cyaml_reader, YamlConverters::SegmentToHashWriter.new
		)

		sff = sconverter.convert
		cff = cconverter.convert

		i = 0
		sff.each do |k,v|
			i += 1
			ck = k.dup
			la = options["comparelanguage"] + ck[options["sourcelanguage"].length..-1]
			unless cff.key?(la)
				puts "Key doesn't exist: " + la
			end
		end

	end
end