require "rwanda"
require "rwanda/rails/version"
require "rwanda/rails/location"
require "action_view"

class Rwanda
  module Rails
    module FormHelper
      def self.included(arg)
        ActionView::Helpers::FormBuilder.send(:include, FormBuilder)
      end
      
      # available options:
      #  required:
      #   :force_edit - name of level that has specifically been requested to be changed by the user
      #  optional:
      #   :autosubmit - submit the form immediately rather than waiting for the button to be pressed
      #   :include_blank - string to display if nothing selected, defaults to 'Unknown'
      #   :table - output in a <table> if true
      #   #:edit_path - defaults to edit_model_path
      #   :action - defaults to edit
      
      def rwanda_location(object_name, location, raw_options={})
        # transfer everything from raw_options into config for random access
        config = { table: true, action: 'edit' }.merge(raw_options)
        
        # pick out only those raw_options that will be passed to select_tag
        select_options = { include_blank: 'Unknown' }.merge(raw_options.select {|k,v| [ :force_edit, :include_blank ].include? k })
        select_options[:onchange] = "this.form.submit();" if raw_options[:autosubmit]
        
        # object_name = company
        # location = Struct.new( :division ... )
        output = config[:table] ? "<table border=0>\n".html_safe : ''.html_safe
        # location is a Location object defined in the rails gem
        location.validate! # get rid of any erroneous data -- no more checks necessary
        force_edit = config[:force_edit] ? config[:force_edit].to_sym : nil
        #binding.pry
        #cleaned_options[:edit_path] = options[:edit_path] || edit_polymorphic_path(object_name, force_edit: force_edit)
        location.each_pair do |level, div|
          output << "<tr><td>\n".html_safe if config[:table]
          output << "<div class=\"field\">\n".html_safe
          #binding.pry
          if force_edit == level || ( location.first_missing == level && !force_edit )
            # editable
            # Want subdivisions of [district] if level is sector
            subdivisions = Rwanda.instance.subdivisions_of(location.top(Location.index_of(level)-1))
            
            subdivision_options = { selected: div }.merge(select_options)
            output <<
              select_tag("#{object_name}[#{level}]", options_for_select(subdivisions, div), select_options) <<
              " #{level.to_s.humanize}".html_safe
            output << "</td><td></td>\n".html_safe if config[:table]
          elsif div
            # display
            output <<
              "<b>#{div}</b> #{level.to_s.humanize}\n&nbsp;#{'</td><td>' if config[:table]}".html_safe <<
              link_to("[Change this]", polymorphic_path(object_name, action: config[:action], force_edit: level))
              # cleaned_options[:edit_path]) # edit_company_location_path(force_edit: level))
          else
            # greyed out message
            output << "Enter data above before selecting #{level.to_s.humanize}\n"
            output << "</td><td></td>\n".html_safe if config[:table]
          end
          output << "</div>\n".html_safe
          output << "</td></tr>\n".html_safe if config[:table]
        end
        output << "</table>\n".html_safe if config[:table]
        #location.to_s
        output
      end
      
      #private
      #def division(division, company, force_edit=false)
      #  #logger.debug "force_edit: #{force_edit} (#{force_edit.class.to_s}); division: #{division} (#{division.class.to_s})"
      #  force_edit &&= force_edit.to_symbol
      #  # all higher divisions validate
      #  if validate_higher(division, company)
      #    # this division validates
      #    if validate_this(division, company)
      #      # user has asked to edit this division
      #      if force_edit == division
      #        #> drop-down
      #        return true
      #      # user hasn't asked to edit
      #      else
      #        #> display as text with link to edit
      #        return false
      #      end
      #    # this division doesn't validate
      #    else
      #      # another division has been forced
      #      if force_edit && force_edit != division
      #        #> greyed out
      #        return false
      #      else
      #        #> drop-down
      #        return true
      #      end
      #    end
      #  # at least one higher division doesn't validate
      #  else
      #    # greyed out message
      #    return false
      #  end
      #end      
      #end
    end
    
    module FormBuilder
      # ActionPack's metaprogramming would have done this for us, if FormHelper#labeled_input 
      # had been defined at load.   Instead we define it ourselves here.
      def rwanda_location(location, options = {})
        @template.rwanda_location(@object_name, location, objectify_options(options))
      end    
    end
  end
end

ActionView::Base.send(:include, Rwanda::Rails::FormHelper)
ActionView::Helpers::FormHelper.send(:include, Rwanda::Rails::FormHelper)


