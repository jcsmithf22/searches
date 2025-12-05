module SearchesHelper
  def formatted_price_range(search)
    min = search.minimum
    max = search.maximum

    if min.present? && max.present?
      "#{min.format} to #{max.format}"
    elsif max.present?
      "up to #{max.format}"
    elsif min.present?
      "#{min.format} and up"
    else
      "Any price"
    end
  end

  def random_book_title
    [
      "To Kill a Mockingbird",
      "1984",
      "The Great Gatsby",
      "Pride and Prejudice",
      "The Catcher in the Rye",
      "Lord of the Flies",
      "Animal Farm",
      "Brave New World",
      "The Lord of the Rings",
      "Harry Potter and the Philosopher's Stone",
      "The Chronicles of Narnia",
      "Moby-Dick",
      "War and Peace",
      "Crime and Punishment",
      "The Odyssey",
      "Don Quixote",
      "The Picture of Dorian Gray",
      "Frankenstein",
      "Dracula",
      "Jane Eyre"
    ].sample
  end
end
