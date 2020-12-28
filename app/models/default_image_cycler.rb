class DefaultImageCycler
  IMAGES = [
    "photographs/boston_ducks.jpg",
    "photographs/docks.jpg",
    "photographs/keukenhof.jpg"
  ]

  IMAGES_SMALL = [
    "photographs/boston_ducks_small.jpg",
    "photographs/docks_small.jpg",
    "photographs/keukenhof_small.jpg"
  ]

  def next_image
    image = IMAGES[count % IMAGES.length]
    increment_count

    return image
  end

  def next_small_image
    image = IMAGES_SMALL[count % IMAGES_SMALL.length]
    increment_count

    return image
  end

  private

  def increment_count
    @_count = @_count + 1
  end

  def count
    @_count ||= 0
  end
end
