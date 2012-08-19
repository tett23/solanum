guard :coffeescript, :output=>'public/javascripts/' do
  watch(%r{^app/coffeescripts/.+\.coffee$})
end

guard :shell do
  watch(/carolinense\/(.+)\.rb/) do |w|
    system('ruby carolinense/carolinense.rb -a restart')
  end
end
