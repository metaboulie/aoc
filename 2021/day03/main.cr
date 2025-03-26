class Main
  getter lines : Array(String), bit_length : Int32

  def initialize(file_path : String)
    @lines = File.read_lines(file_path).reject(&.empty?)
    @bit_length = @lines.first.size
  end

  def part_one
    bit_counts = Array.new(@bit_length, 0)
    
    @lines.each do |line|
      line.each_char_with_index do |char, i|
        bit_counts[i] += 2 * char.to_i - 1
      end
    end
    
    gamma, epsilon = "", ""
    
    bit_counts.each do |value|
      if value > 0
        gamma += "1"
        epsilon += "0"
      else
        gamma += "0"
        epsilon += "1"
      end
    end
    
    gamma.to_i(2) * epsilon.to_i(2)
  end

  def part_two
    oxygen = find_rating(@lines.dup) { |count| count >= 0 ? 1 : 0 }
    co2 = find_rating(@lines.dup) { |count| count >= 0 ? 0 : 1 }
    
    oxygen.to_i(2) * co2.to_i(2)
  end

  private def find_rating(numbers : Array(String), &block : Int32 -> Int32) : String
    idx = 0
    
    while numbers.size > 1 && idx < @bit_length
      count = numbers.sum { |num| 2 * num[idx].to_i - 1 }
      bit = yield(count)
      numbers.select! { |num| num[idx].to_i == bit }
      idx += 1
    end
    
    numbers.first
  end
end

main = Main.new("./input.txt")
puts main.part_one, main.part_two
