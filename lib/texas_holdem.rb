module TexasHoldem
  ClassFiles = Dir.entries( File.join( File.dirname(__FILE__), '..', 'lib' ) ).grep(/\.rb$/)
  ClassFiles.each {|klass| require klass.gsub /\.rb/, ''} 
end