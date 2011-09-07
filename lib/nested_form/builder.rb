module NestedForm
  module Builder
    def link_to_add(name, association)
      @fields ||= {}
      @template.after_nested_form(association) do
        model_object = object.class.reflect_on_association(association).klass.new
        output = %Q[<div id="#{association}_fields_blueprint" style="display: none">].html_safe
        output << fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
        output.safe_concat('</div>')
        output
      end
      @template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association)
    end
    
    def link_to_remove(*args)
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2] || {}
      hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", options, html_options.merge({:class => "remove_nested_fields"}))
    end

    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      super
    end

    def fields_for_nested_model(name, association, args, block)
      output = '<div class="fields">'.html_safe
      output << super
      output.safe_concat('</div>')
      output
    end
  end
end

class SimpleForm::FormBuilder
  include NestedForm::Builder
end