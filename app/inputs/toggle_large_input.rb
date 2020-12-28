class ToggleLargeInput < ToggleInput
  def additional_classes
    super.push("large").push("toggle")
  end
end
