#!/usr/bin/env ruby
require 'yaml'

Dir['_posts/*.md'].each do |post|
  content = File.read(post).split "---\n"
  front = YAML.load content[1]
  title = front['title']
  puts '=' * 10 + title + '=' * 10
  puts "downloading #{front['podcastfile']}"
  `curl -sL '#{front['podcastfile']}' -o /tmp/episode`
  size = File.size('/tmp/episode')
  unless size == front['length'].to_i
    puts "SIZE DOESN'T MATCH, actually: #{size}"
  end
  probed = `ffprobe '/tmp/episode' 2>&1`
  duration = probed.match(/Duration: (.*?),/)[1]
  duration.gsub!(/[.]\d\d$/, '')
  duration.gsub!(/^00:/, '')
  unless duration == front['duration']
    puts "DURATION DOESN'T MATCH, actually: #{duration}"
  end
end
# duration=$(ffprobe "$file" 2>&1 | awk '/Duration/ { print $2  }')
 # echo -e $duration"\t"$file
