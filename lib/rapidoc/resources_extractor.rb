module Rapidoc

  ##
  # This module get resources info.
  #
  # Info of each route include:
  # - method
  # - action
  # - url
  # - controller_file
  #
  module ResourcesExtractor

    ##
    # Reads 'rake routes' output and gets the routes info
    # @return [RoutesDoc] class with routes info
    #
    def get_routes_doc
      puts "Executing 'rake routes'..." if trace?

      routes_doc = RoutesDoc.new
      if routes_filter_regex_pattern.blank?
        routes = Dir.chdir( ::Rails.root.to_s ) { `rake routes` }
      else
        routes = Dir.chdir( ::Rails.root.to_s ) { `rake routes | grep #{routes_filter_regex_pattern}` }
      end

      routes.split("\n").each do |entry|
        routes_doc.add_route( entry ) unless entry.match(/URI/)
      end

      routes_doc
    end

    ##
    # Create new ResourceDoc for each resource extracted from RoutesDoc
    # @return [Array] ResourceDoc array
    #
    def get_resources
      routes_doc = get_routes_doc
      resources_names = routes_doc.get_resources_names - resources_black_list

      resources_names.map do |resource|
        puts "Generating #{resource} documentation..." if trace?
        ResourceDoc.new( resource, routes_doc.get_actions_route_info( resource ) )
      end
    end
  end
end
