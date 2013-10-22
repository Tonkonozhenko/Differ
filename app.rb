# app.rb

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end


module Diff
  def self.diff(old_array, new_array)
    lcs = lcs(old_array, new_array)
    diff = Array.new

    new_array_index = 0; old_array_index = 0; lcs_array_index = 0
    #while old_array_index < old_array.size and new_array_index < new_array.size and lcs_array_index < lcs.size
    while !(old_array[old_array_index].nil? and new_array[new_array_index].nil? and lcs[lcs_array_index].nil?)
      if old_array[old_array_index] != lcs[lcs_array_index]
        diff << {:value => old_array[old_array_index], :type => :removed, :old_position => old_array_index+1, :new_position => new_array_index+1}
        old_array_index+=1
      elsif new_array[new_array_index] != lcs[lcs_array_index]
        diff << {:value => new_array[new_array_index], :type => :added, :old_position => old_array_index+1, :new_position => new_array_index+1}
        new_array_index+=1
      else
        diff << {:value => lcs[lcs_array_index], :type => :same, :old_position => old_array_index+1, :new_position => new_array_index+1}
        old_array_index+=1; new_array_index+=1; lcs_array_index+=1
      end
    end
   diff
  end

  def self.lcs(old, new)
    old_length = old.length; new_length= new.length

    m = Array.new(old_length + 1) do
      Array.new(new_length + 1) do
        {:value => nil, :previous => nil}
      end
    end

    0.upto(old_length) do |i|
      m[i][0][:value] = 0
    end
    0.upto(new_length) do |j|
      m[0][j][:value] = 0
    end

    1.upto(old_length) do |i|
      1.upto(new_length) do |j|
        if old[i-1] == new[j-1]
          m[i][j][:value] = m[i-1][j-1][:value] + 1
          m[i][j][:previous] = [-1, -1]
        else
          if m[i-1][j][:value] >= m[i][j-1][:value]
            m[i][j][:value] = m[i-1][j][:value]
            m[i][j][:previous] = [-1, 0]
          else
            m[i][j][:value] = m[i][j-1][:value]
            m[i][j][:previous] = [0, -1]
          end
        end
      end
    end

    lcs = old.class == String || new.class == String ? String.new : Array.new
    i = old_length; j = new_length
    until m[i][j][:previous] == nil do
      lcs << old[i-1] if m[i][j][:previous][0] == -1 and m[i][j][:previous][1] == -1
      tmp = i; i += m[i][j][:previous][0]; j += m[tmp][j][:previous][1]
    end
    lcs.reverse!

    return lcs
  end
end

get '/' do
  erb :index
end

post '/' do
  Diff.diff('123','124')

  # Read old code
  old_file = params[:old_code].split("\r\n")

  # Read new code
  new_file = params[:new_code].split("\r\n")

  results = Diff.diff(old_file, new_file)

  @left = []
  @right = []

  @max_rows = results.map { |r| r[:type]==:same || r[:type]==:inserted }.count

  results.each do |r|
    if r[:type] == :same
      @left << r
      @right << r
    elsif r[:type] == :removed
      if @left.last.nil? && !@left.empty?
        @left[@left.count - 1] = r
        @max_rows -= 1
      else
        @left << r
        @right << nil
      end
    else
      if @right.last.nil? && !@right.empty?
        @right[@right.count - 1] = r
        @max_rows -= 1
      else
        @left << nil
        @right << r
      end
    end
  end

  0.upto(@max_rows - 1) do |i|
    left_chunk = @left[i]
    right_chunk = @right[i]
    unless left_chunk.nil? || right_chunk.nil?
      if left_chunk[:type] == :removed and right_chunk[:type] == :added
        diff = Diff.diff(left_chunk[:value], right_chunk[:value])
        new_diff = []
        diff.each do |d|
          if !new_diff.last.nil? and new_diff.last[:type] == d[:type]
            new_diff[new_diff.count - 1][:value] += d[:value]
          else
            new_diff << d
          end
        end
        @left[i][:value] = new_diff
        @right[i][:value] = new_diff
      end
    end
  end

  erb :result
end