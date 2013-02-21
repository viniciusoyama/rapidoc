# encoding: utf-8

module Rapidoc

  ##
  # This module has all config information about directories and config files.
  #
  module Config
    GEM_CONFIG_DIR = File.join( File.dirname(__FILE__), 'config' )
    GEM_ASSETS_DIR = File.join( File.dirname(__FILE__), 'templates/assets' )
    GEM_EXAMPLES_DIR = File.join( File.dirname(__FILE__), 'config/examples')

    def gem_templates_dir( f = nil )
     @gem_templates_dir ||= File.join( File.dirname(__FILE__), 'templates' )
     form_file_name @gem_templates_dir, f
    end

    def config_dir( f = nil )
      @config_dir ||= File.join( ::Rails.root.to_s, 'config/rapidoc' )
      form_file_name @config_dir, f
    end

    def target_dir( f = nil )
      @target_dir ||= File.join( ::Rails.root.to_s, target_relative_dir )
      form_file_name @target_dir, f
    end

    def controller_dir(f = nil)
      @controller_dir ||= File.join( ::Rails.root.to_s, 'app/controllers' )
      form_file_name @controller_dir, f
    end

    def form_file_name(dir, file)
      case file
      when NilClass then dir
      when String then File.join(dir, file)
      else raise ArgumentError, "Invalid argument #{file}"
      end
    end

    def target_relative_dir
      return "rapidoc" unless File.exists?( "#{config_dir}/rapidoc.yml" )
      config = YAML.load( File.read( "#{config_dir}/rapidoc.yml" ) )
      ( not config or not config.has_key?("route") )  ? "rapidoc" : config["route"]
    end

    def get_examples_dir( f = nil )
      if File.exists?("#{config_dir}/rapidoc.yml")
        dir = get_example_dir_from_config_file
      else
        dir = "#{config_dir}/examples"
      end

      form_file_name( dir, f )
    end

    private

    def get_example_dir_from_config_file
      config = YAML.load( File.read( "#{config_dir}/rapidoc.yml" ) )

      if config and config.has_key?("example_route")
        config_dir config["example_route"]
      else
        config_dir '/examples'
      end
    end
  end
end
