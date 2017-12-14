require 'rake/tasklib'
require 'rspec/core/rake_task'
require_relative '../zauber-automato'

# the rake interface for ZauberAutomato
class ZauberAutomato::Tasks < ::Rake::TaskLib
  def initialize
    specs = Dir.glob('**/*_spec.rb')
    specdirs = specs.map { |spec| File.dirname(spec) }
    specdirs.uniq!

    desc 'Execute ZauberAutomato on all spec directories'
    task zauberautomato: specdirs.map(&:to_sym)

    specdirs.each do |specdir|
      desc "Execute ZauberAutomato on #{specdir}"
      # gather types from serverspec spec files in target directory
      RSpec::Core::RakeTask.new(specdir.to_sym) do |task|
        task.pattern = "#{specdir}/*_spec.rb"
        # we do not want it to fail simply because of a missing matcher
        task.fail_on_error = false
        # doc formatting because we need instant feedback on parsing
        task.rspec_opts = '--color -f documentation'
      end

      # execute the generators on the gathered resources
      task "zm-#{specdir}".to_sym do
        # use the spec directory name as the basis for generated files
        ZauberAutomato.new(File.basename(specdir))
      end

      # execute the generators task after the gather resources task
      Rake::Task[specdir.to_sym].enhance { Rake::Task["zm-#{specdir}".to_sym].invoke }
    end
  end
end

ZauberAutomato::Tasks.new

# pass vars
# task :sum, [:num1, :num2] do |_, args|
#   puts "the sum of #{args[:num1]} and #{args[:num2]} is #{args[:num1].to_i + args[:num2].to_i}"
# end

# parallel
# multitask main_taks: [:long_task_1, :long_task_2, :long_task_3] do
#   do stuff after all the above are finished (they will execute in parallel)
# end
