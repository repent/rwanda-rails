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
      
      def rwanda_location(object_name, location, options={})
        cleaned_options = { include_blank: 'Unknown' }
        cleaned_options[:onchange] = "this.form.submit();" if options[:autosubmit]
        cleaned_options.merge!(options.select {|k,v| [ :force_edit, :table ].include? k })
        # object_name = company
        # location = Struct.new( :division ... )
        output = cleaned_options[:table] ? "<table border=0>\n".html_safe : ''.html_safe
        # location is a Location object defined in the rails gem
        location.validate! # get rid of any erroneous data -- no more checks necessary
        force_edit = options[:force_edit]
        location.each_pair do |level, div|
          output << "<tr><td>\n".html_safe if cleaned_options[:table]
          output << "<div class=\"field\">\n".html_safe
          if force_edit == level || ( location.first_missing == level && !force_edit )
            # editable
            # Want subdivisions of [district] if level is sector
            subdivisions = Rwanda.instance.subdivisions_of(location.top(Location.index_of(level)-1))
            
            subdivision_options = { selected: div }.merge(cleaned_options)
            output <<
              select_tag("#{object_name}[#{level}]", options_for_select(subdivisions, div), cleaned_options) <<
              " #{level.humanize}".html_safe
            output << "</td><td></td>\n".html_safe if cleaned_options[:table]
          elsif div
            # display
            output <<
              "<b>#{div}</b> #{level.humanize}\n&nbsp;#{'</td><td>' if cleaned_options[:table]}".html_safe <<
              link_to("[Change this]", edit_company_location_path(force_edit: level))
          else
            # greyed out message
            output << "Enter data above before selecting #{level.humanize}\n"
            output << "</td><td></td>\n".html_safe if cleaned_options[:table]
          end
          output << "</div>\n".html_safe
          output << "</td></tr>\n".html_safe if cleaned_options[:table]
        end
        output << "</table>\n".html_safe if cleaned_options[:table]
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


