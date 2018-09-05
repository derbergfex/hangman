require 'json'

class Hangman

	def initialize
		@secret_word = generate_secret_word
		@game_screen = "_" * @secret_word.length
    @failed_attemps = 0
	end

	def init_game
		mode_selected = false
		while mode_selected == false
			puts "Type '1' to start a new game."
			puts "Type '2' to load a saved game."
		
			option = gets.chomp[0]

			if option == '1'
				mode_selected = true
				start_game
				break
			elsif option == '2'
				puts "Type the exact name of your saved game."
				game_name = gets.chomp

				if File.exist?("saved_games/#{game_name}.json")
					mode_selected = true
					load_game("saved_games/#{game_name}.json")
					break
				else
					puts "Invalid file name."
				end
			end
		end
	end

	private 
	
	def generate_secret_word
		words = File.readlines("5desk.txt").select {|word| word.length.between?(5, 12)}
    words[rand(words.length)].strip
	end

	def save_game
		saved_json_object = { 
			:secret_word => @secret_word, 
			:game_screen => @game_screen,
			:failed_attemps => @failed_attemps 
		}.to_json
		puts "Type the name for your saved game."
		saved_game_name = gets.chomp
		File.open("saved_games/#{saved_game_name}.json", "w") {|file| file.write(saved_json_object)}
		puts "Game saved successfully as #{saved_game_name}"
	end

	def load_game(saved_game)
		saved_file = File.read(saved_game)
		saved_file_hash = JSON.parse(saved_file)
		@secret_word = saved_file_hash["secret_word"]
		@game_screen = saved_file_hash["game_screen"]
		@failed_attemps = saved_file_hash["failed_attemps"]
		start_game
	end

	def start_game
		player_won = false
		puts %q[
Enter one of the following options:
1. A letter.
2. The full word.
3. 'save' to save the game.
4. 'exit' to quit the game.
]
		while @failed_attemps < 9
			puts "You have #{9 - @failed_attemps.to_i} attempts left."
			puts @game_screen

			input = gets.chomp
			if input == "save"
				save_game
				next
			elsif input == "exit"
				puts "Thanks for playing!"
				break
			else 
				update_game(input)
			end
			
			break if player_won?
		end

		if @failed_attemps == 9
		  update_game('00000')
			puts "You lost. The secret word was #{@secret_word}"
		end
		 
	end

	def player_won?
    unless @game_screen.include?("_")
      puts "You found the correct word: #{@secret_word}!"
      true
    end
  end

	def update_game(input)
		current_game_screen = "#{@game_screen}"
		input.downcase!

		if input.length == 1
			@game_screen.length.times do |index|
			@game_screen[index] = input if @secret_word[index].downcase == input
			end
		else
			@game_screen = input if @secret_word.downcase == input
		end
		
		current_game_screen == @game_screen ? update_screen(1) : update_screen(0)
	end

	def update_screen(result)
		@failed_attemps += result

		case @failed_attemps	
		when 0
			puts "        "
			puts "        |"
			puts "        |"
			puts "        |"
			puts "        |"	
		when 1
			puts "  ______"
			puts "        |"
			puts "        |"
			puts "        |"
			puts "        |"
		when 2
			puts "  ______"
			puts " |      |"
			puts "        |"
			puts "        |"
			puts "        |"
		when 3
			puts "  ______"
			puts " |      |"
			puts " O      |"
			puts "        |"
			puts "        |"
		when 4
			puts "  ______"
			puts " |      |"
			puts " O      |"
			puts " |      |"
			puts "        |"
		when 5
			puts "  ______"
			puts " |      |"
			puts " O      |"
			puts " |      |"
			puts "        |"  
		when 6
			puts "  ______"
			puts " |      |"
			puts " O      |"
			puts "/|      |"
			puts "        |"
		when 7
			puts "  ______"
			puts " |      |"
			puts " O      |"
			puts "/|\\     |"
			puts "        |"
		when 8
			puts "  ______"
			puts " |      |"
			puts " O      |"
			puts "/|\\     |"
			puts "/       |"
		when 9
			puts "  ______"
			puts " |      |"
			puts " O      |"
			puts "/|\\     |"
			puts "/ \\     |"         
		end
			puts ""	
	end
end


my_game = Hangman.new
my_game.init_game
