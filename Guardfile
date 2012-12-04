# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', input: 'src', output: "vendor/assets/javascripts", bare: false

spec_location = "spec/javascripts/%s_spec"
guard 'jasmine-headless-webkit' do
  watch(%r{^src/(.*)\.(js|coffee)$}) { |m| newest_js_file(spec_location % m[1]) }
  watch(%r{^vendor/assets/javascripts/(.*)\.(js|coffee)$}) { |m| newest_js_file(spec_location % m[1]) }
  watch(%r{^spec/javascripts/(.*)_spec\..*}) { |m| newest_js_file(spec_location % m[1]) }
end
