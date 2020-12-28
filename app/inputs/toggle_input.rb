class ToggleInput < SimpleForm::Inputs::BooleanInput
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    build_check_box(unchecked_value, merged_input_options) + toggle_html
  end

  def additional_classes
    classes = ["toggle-container", "toggle"]
    classes.push("active") if object.send(attribute_name.to_sym)

    super + classes
  end

  private

  def toggle_html
    '<div class="toggle-container"><div></div></div>'.html_safe
  end
end
