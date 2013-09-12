def input_to_array(input_file)
  input = File.open('./coded_messages/' + input_file).to_a
  return input
end

def input_interface
    while true
      puts "**********************************************************************"
      puts "Which coded message would you like to decode"
      puts input_choices
      puts
      response=gets.chomp
      break if input_check(response)
      puts "I'm sorry please try again."
      puts "**********************************************************************"
    end
    @input_file=response
end

def input_choices
  @input_choices=Dir.entries("coded_messages")
  @input_choices.shift
  @input_choices.shift
  @input_choices
end

def input_check(response)
  input_choices
  @input_choices.include?(response)
end

def gen_code_hash_array
  array_of_code_hashes=[]
  (0..26).each do |x|
    alphabet=[*"A".."Z"]
    shifted_alphabet=alphabet.push(alphabet.shift(x)).flatten
    array_of_code_hashes<<Hash[[*"A".."Z"].zip shifted_alphabet]
  end
  array_of_code_hashes
end

def gen_lshift_code_hash_array
  array_of_code_hashes_left=[]
  (0..26).each do |x|
    alphabet=[*"A".."Z"]
    shifted_alphabet=alphabet.unshift(alphabet.pop(x)).flatten
    array_of_code_hashes_left<<Hash[[*"A".."Z"].zip shifted_alphabet]
  end
  array_of_code_hashes_left
end

def word_to_num(word)
  code_num_array=[]
  (0...word.length).each do|y|
    (0..26).each do |x|
      code_num_array<<x if word[y]==[*"A".."Z"][x]
    end
  end
  code_num_array
end

def find_code_word_array(code_word)
  word_array=[]
 (0..26).each do |x|
    word=[]
    (0...code_word.length).each do |y|
      word<< @code_hash_array[x][code_word[y]]
    end
    word_array<<word.join
  end
  word_array
end

def decoded_message(code_word, message, lshifted_hash_array)
  decoded_message=[]
  code_word_place=0
  code_array=word_to_num(code_word)
  message.split("").each do |x|
    if ("A".."Z").include?(x)
      decoded_message<<lshifted_hash_array[code_array[code_word_place%code_array.length]][message[x]]
      code_word_place+=1
    else
      decoded_message<<x
    end
  end
  decoded_message.join
end

@code_hash_array=gen_code_hash_array
@left_code_hash_array=gen_lshift_code_hash_array
input_interface
input=input_to_array(@input_file)
coded_code_word=input[0]
message=input[2...input.length].join.to_s
word_array=find_code_word_array(coded_code_word)

while true
  puts word_array
  puts "__________________________________"
  puts "Type in Code Word from Options"
  @code_word=gets.upcase.chomp
  break if word_array.include?(@code_word)
end

puts "__________________________________"
puts decoded_message(@code_word, message.to_s, @left_code_hash_array)



