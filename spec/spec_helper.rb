$:.unshift(File.expand_path("../../lib/", __FILE__))

Matest.configure do |c|
  c.use_color
end
