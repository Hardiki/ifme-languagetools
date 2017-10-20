require 'optparse'
require "yaml_converters"
require 'languagetool'

ignoreRuleIds = [ "UPPERCASE_SENTENCE_START" ]

options = {
	"language" => "en",
	"path" => "../ifme",
	"languagetool" => "http://localhost:8081/v2"
}

OptionParser.new do |opts|
	opts.banner = "Usage: suggestlang.rb [options]\nMake sure a languagetool.org instance is running.\nSee: http://wiki.languagetool.org/http-server\n\n"

	opts.on("-l", "--language LANGUAGE", "Language code (default: en)") { |v| options["language"] = v }
	opts.on("-p", "--path PATH", "Path to if me checkout (default: ../ifme)") { |v| options["path"] = v }
	opts.on("-t", "--tool URI", "Url to languagetool.org instance (default: http://localhost:8081/v2)") { |v| options["languagetool"] = v }

end.parse!

localePath = File.join(options["path"], "config", "locales")

unless File.directory?(localePath)
	puts "Error: #{localePath} isn't a valid folder"
	exit
end

lt = LanguageTool::API.new base_uri: options["languagetool"]

Dir.glob(localePath + "/*" + options["language"] + ".yml").each do |lf|
	f = lf.dup
	f = f.sub! localePath + '/', ''
	puts "Processing: " + f
	puts "----"

	yaml_reader = YamlConverters::YamlFileReader.new(lf)
	converter = YamlConverters::YamlToSegmentsConverter.new(
		yaml_reader, YamlConverters::SegmentToHashWriter.new
	)
	ff = converter.convert

	i = 0
	ff.each do |k,v|
		i += 1

		if v.split.size > 3
			begin
				check = lt.check text: v, language: options["language"]
				if check.matches.any?
					ignoreMatches = []

					check.matches.each do |m|

						if m.rule.issue_type == "misspelling"
							if m.context.offset > 1
								localText = m.context.text.to_s

								if localText[m.context.offset-2,m.context.offset] == "%{"
									ignoreMatches.push(m)
								end
							end
						elsif ignoreRuleIds.include?(m.rule.id)
							ignoreMatches.push(m)
						end
					end

					if ignoreMatches.length != check.matches.length
						puts ""
						puts f + "@" + i.to_s + ": " + k
						puts "Original: " + v
						puts "Proposed: " + check.auto_fix

						check.matches.each do |m|
							unless ignoreMatches.include?(m)
								puts " - " + m.message
							end
						end
					end
				end
			rescue LanguageTool::APIError => e
				puts e.exception
				exit
			end
		end
	end
end