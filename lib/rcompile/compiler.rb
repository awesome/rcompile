module RCompile
  using RCompile::Colorize

  class Compiler
    include Methadone::CLILogging
    include Methadone::SH

    attr_reader :options

    def initialize(options = {})
      @options = options
      set_sh_logger nil
    end

    def exec(command)
      command_name = parse_caller(caller(1).first)
      begin
        success = sh command
        puts command.green if success && verbose
      rescue
        puts "#{command_name} failed to run".red
      end

      if options[:fail_on_error] && !success
        $stderr.puts "#{command} failed"
        exit $?.exitstatus
      end
    end

    def parse_caller(at)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
        Regexp.last_match[3]
      end
    end

    def run_task(verbose)
      compile
    end

    def compile
      stop_rails_server
      prepare

      start_rails_server
      download_html

      stop_rails_server

      prettify

      path = options[:release_dir].to_s.bold.green
      puts "Saved a version of the website into: #{path}".green
    end

    def stop_rails_server
      exec "ps -eo pid,command | grep 'rails' | grep -v grep | awk '{print $1}' | xargs kill"
    end

    def prepare
      clean_directories
      clean_rails_assets
      precompile_rails_assets
      create_font_directory
      copy_gem_fonts
    end

    def clean_directories
      exec "rm -rf #{options[:release_dir]} #{options[:asset_dir]}"
    end

    def clean_rails_assets
      exec 'bundle exec rake assets:clean'
    end

    def precompile_rails_assets
      exec 'bundle exec rake assets:precompile'
    end

    def create_font_directory
      exec 'mkdir -p public/fonts'
    end

    def copy_gem_fonts
      exec 'cp -r $(bundle show bootstrap-sass-rails)/app/assets/fonts/* public/assets/'
    end

    def start_rails_server
      exec 'bundle exec rails s -p 3311 -d -e production'
    end

    def download_html
      exec 'wget -H -r -l 10 -k -p -P html -nH localhost:3311'
    end

    def prettify
      prettify_html
      prettify_css
    end

    def prettify_html

    end

    def prettify_css

    end

  private

    def html_files_to_prettify
      FileList[ "./#{options[:release_dir]}{,/*/**}/*.html" ].sort.map(&:shellescape)
    end

    def css_files_to_prettify
      FileList[ "./#{options[:release_dir]}{,/*/**}/*.css" ].sort.map(&:shellescape)
    end
  end
end