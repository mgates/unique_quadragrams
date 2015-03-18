require 'set'

class UniqueQuadragrams
  def find(dictionary, quads_file, words_file)
    pairs = {}
    dups = Set.new
    words_from(dictionary).each do |word|
      quads_from(word).each do |quad|
        next if dups.include? quad
        if pairs[quad]
          pairs.delete(quad)
          dups << quad
        else
          pairs[quad] = word
        end
      end
    end

    quads_file.puts pairs.keys.join("\n")
    words_file.puts pairs.values.join("\n")
  end

  private

  def words_from(dictionary)
    dictionary.each_line.map(&:chomp)
  end

  def quads_from(word)
    word.
      chars.
      each_cons(4).
      map(&:join).
      map(&:downcase).
      find_all {|quad| quad.match(/\A[[:alpha:]]+\Z/)}
  end
end
