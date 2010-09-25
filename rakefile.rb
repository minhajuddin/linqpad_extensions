COMPILE_TARGET = "release"
ASSEMBLY_PREFIX = 'LinqpadExtensions.'
SOLUTION_FILE = "src/#{ASSEMBLY_PREFIX}sln"
CLR_VERSION = "v3.5"

props = {:archive => "build"}
require 'build_tasks'
include FileTest
require 'albacore'

desc "'Default' task compiles the code"
task :default=> :compile

desc "Compiles the app"
task :compile => :clean do
  MSBuildRunner.compile :compilemode => COMPILE_TARGET, :solutionfile => SOLUTION_FILE, :clrversion => CLR_VERSION

  copyOutputFiles "src/Core/bin/#{COMPILE_TARGET}", "*.{dll,pdb}", props[:archive]
end

def copyOutputFiles(fromDir, filePattern, outDir)
  Dir.glob(File.join(fromDir, filePattern)){|file| 		
    copy(file, outDir) if File.file?(file)
  } 
end


desc "Prepares the working directory for a new build"
task :clean do
  #TODO: do any other tasks required to clean/prepare the working directory
  Dir.mkdir props[:archive] unless exists?(props[:archive])
end
