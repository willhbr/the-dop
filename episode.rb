#!/usr/bin/env ruby

url = ARGV[0]

puts "downloading #{url}"
`curl -sL '#{url}' -o /tmp/episode`

episode_num = url.match(/episode-(\d+)[.]mp3/)[1]

info = `ffprobe /tmp/episode 2>&1`

title = info.match(/title\s+: (.*?)$/)[1]
title.gsub!(/Almost Logical( ?- ?)?/, '')
duration = info.match(/Duration: (.*?),/)[1]
duration.gsub!(/[.]\d\d$/, '')
duration.gsub!(/^00:/, '')
length = File.size '/tmp/episode'
date = Time.now.strftime '%Y-%m-%d'

template = <<-EOF
---
title: "#{title}"
duration: "#{duration}"
date: #{date}
podcastfile: "#{url}"
length: "#{length}"
permalink: /episodes/#{episode_num}
layout: post
---

SHOW NOTES
EOF

File.write("_posts/#{date}-#{title.gsub(/[^\w]+/, '-').downcase}.md", template)
