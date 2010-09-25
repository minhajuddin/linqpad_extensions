require 'rubygems'
require 'erb'

class NUnitRunner
	include FileTest

	def initialize(paths)
		@sourceDir = paths.fetch(:source, 'source')
		@resultsDir = paths.fetch(:results, 'results')
		@compilePlatform = paths.fetch(:platform, '')
		@compileTarget = paths.fetch(:compilemode, 'debug')
		@asmPrefix = paths.fetch(:assembly_prefix, '')
	
		@nunitExe = File.join('lib', 'nunit', "nunit-console#{(@compilePlatform.empty? ? '' : "-#{@compilePlatform}")}.exe").gsub('/','\\') + ' /nothread'
	end
	
	def executeTests(assemblies)
		Dir.mkdir @resultsDir unless exists?(@resultsDir)
		
		assemblies.each do |assem|
			file = File.expand_path("#{@sourceDir}/#{assem}/bin/#{@compileTarget}/#{@asmPrefix}#{assem}.dll")
			sh "#{@nunitExe} /xml=#{@resultsDir}\\TestResults.xml \"#{file}\""
		end
	end
end

class MSBuildRunner
	def self.compile(attributes)
		version = attributes.fetch(:clrversion, 'v2.0.50727')
		compileTarget = attributes.fetch(:compilemode, 'debug')
	    solutionFile = attributes[:solutionfile]
		
		frameworkDir = File.join(ENV['windir'].dup, 'Microsoft.NET', 'Framework', version)
		msbuildFile = File.join(frameworkDir, 'msbuild.exe')
		
		sh "#{msbuildFile} #{solutionFile} /nologo /maxcpucount /v:m /property:BuildInParallel=false /property:Configuration=#{compileTarget} /t:Rebuild"
	end
end

class AspNetCompilerRunner
	def self.compile(attributes)
		
		webPhysDir = attributes.fetch(:webPhysDir, '')
		webVirDir = attributes.fetch(:webVirDir, 'This_Value_Is_Not_Used')
		
		frameworkDir = File.join(ENV['windir'].dup, 'Microsoft.NET', 'Framework', 'v2.0.50727')
		aspNetCompiler = File.join(frameworkDir, 'aspnet_compiler.exe')

		sh "#{aspNetCompiler} -nologo -errorstack -c -p #{webPhysDir} -v #{webVirDir}"
	end
end

class AsmInfoBuilder
	attr_reader :buildnumber

	def initialize(baseVersion, properties)
		@properties = properties;
		
		@buildnumber = baseVersion + (ENV["CCNetLabel"].nil? ? '0' : ENV["CCNetLabel"].to_s)
		@properties['Version'] = @properties['InformationalVersion'] = buildnumber;
	end


	
	def write(file)
		template = %q{
using System;
using System.Reflection;
using System.Runtime.InteropServices;

<% @properties.each {|k, v| %>
[assembly: Assembly<%=k%>Attribute("<%=v%>")]
<% } %>
		}.gsub(/^    /, '')
		  
	  erb = ERB.new(template, 0, "%<>")
	  
	  File.open(file, 'w') do |file|
		  file.puts erb.result(binding) 
	  end
	end
end
#fluent migration tasks
class FluentMigratorWrapper

  def self.execute(args)
    task = args.fetch(:task, 'migrate')
    version = args.fetch(:version, 0)
    steps = args.fetch(:steps, 0)
    connection = args.fetch(:connection,"\"Data Source=db.sqlite;Version=3;\"")
    db = args.fetch(:db,'Sqlite')		
    assemblyPath = args.fetch(:assembly_path, '')
    
    command = "tools/FluentMigrator/FluentMigrator.Console.exe /connection #{connection} /db #{db} /target  #{assemblyPath} /log"
    command += " /task #{task}"
    command += " /version #{version}" unless version == 0
    command += " /steps #{steps}" unless steps == 0
    sh command
  end

end



