class ToggleSmallInput < ToggleInput
  def additional_classes
    super.push("small").push("toggle")
  end
end
