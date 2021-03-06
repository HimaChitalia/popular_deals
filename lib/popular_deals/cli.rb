#CLI Controller
class PopularDeals::CLI
  BASE_URL = "https://slickdeals.net/deals/"
  PAGE2_URL = "https://slickdeals.net/deals/?page=2&sort=recent"
  PAGE3_URL = "https://slickdeals.net/deals/?page=3&sort=recent"
  PAGE4_URL = "https://slickdeals.net/deals/?page=4&sort=recent"
  PAGE5_URL = "https://slickdeals.net/deals/?page=5&sort=recent"

  attr_accessor :product_url

  def call
    scrap_all_deals
    select_list_of_deals
  end

  def scrap_all_deals
    PopularDeals::Scrapper.scrap_slickdeals(BASE_URL)
    PopularDeals::Scrapper.scrap_slickdeals(PAGE2_URL)
    PopularDeals::Scrapper.scrap_slickdeals(PAGE3_URL)
    PopularDeals::Scrapper.scrap_slickdeals(PAGE4_URL)
    PopularDeals::Scrapper.scrap_slickdeals(PAGE5_URL)
  end

  def select_list_of_deals
    puts ""
    puts "Which list of the deals would you like to see?".upcase.cyan.bold
    puts "Type 1 for the first list of 1-20 deals.".yellow
    puts "Type 2 for the second list of 21-40 deals.".yellow
    puts "Type 3 for the third list of 41-60 deals.".yellow
    puts "Type 4 for the fourth list of 61-80 deals.".yellow
    puts "Type 5 for the fifth list of 81-100 deals.".yellow
    puts ""
    @input1 = gets.strip.downcase
    available_lists
  end

  def available_lists
    integer_input = @input1.to_i

    if integer_input == 1
      list1_actions
    elsif integer_input == 2
      list2_actions
    elsif integer_input == 3
      list3_actions
    elsif integer_input == 4
      list4_actions
    elsif integer_input == 5
      list5_actions
    elsif @input1 == "exit"
      goodbye
    else
      puts "Don't understand that command".colorize(:color => :white, :background => :red)
      select_list_of_deals
    end
  end

  def list1_actions
    @deals = PopularDeals::NewDeals.deals[0..19]
    puts ""
    puts "------------------ Deal list:1 - deals 1 - 20 ------------------".yellow
    puts ""
    deal_list
    show_deal_detail
  end

  def list2_actions
    @deals = PopularDeals::NewDeals.deals[20..39]
    puts ""
    puts "------------------ Deal list:2 - deals 21 - 40 ------------------".yellow
    puts ""
    deal_list
    show_deal_detail
  end

  def list3_actions
    @deals = PopularDeals::NewDeals.deals[40..59]
    puts ""
    puts "------------------ Deal list:3 - deals 41 - 60 ------------------".yellow
    puts ""
    deal_list
    show_deal_detail
  end

  def list4_actions
    @deals = PopularDeals::NewDeals.deals[60..79]
    puts ""
    puts "------------------ Deal list:4 - deals 61 - 80 ------------------".yellow
    puts ""
    deal_list
    show_deal_detail
  end

  def list5_actions
    @deals = PopularDeals::NewDeals.deals[80..99]
    puts ""
    puts "------------------ Deal list:5 - deals 81 - 100 ------------------".yellow
    puts ""
    deal_list
    show_deal_detail
  end

  # All of he below methods just support main methods.

  def deal_list
    @deals.each do |deal|
      i = "#{deal.number}".to_i
      if  i < 10
        puts "#{i}. #{deal.title}".cyan.bold
        puts "Deal rating: #{deal.deal_rating}.".gsub(/^/, "   ")
        puts "Deal value - #{deal.price}".gsub(/^/, "   ")
        puts "#{deal.posted}".gsub(/^/, "   ")
        puts ""
      elsif i >= 10
        puts "#{i}. #{deal.title}".cyan.bold
        puts "Deal rating: #{deal.deal_rating}.".gsub(/^/, "    ")
        puts "Deal value - #{deal.price}".gsub(/^/, "    ")
        puts "#{deal.posted}".gsub(/^/, "    ")
        puts ""
      elsif i >= 100
        puts "#{i}. #{deal.title}".cyan.bold
        puts "Deal rating: #{deal.deal_rating}.".gsub(/^/, "     ")
        puts "Deal value - #{deal.price}".gsub(/^/, "     ")
        puts "#{deal.posted}".gsub(/^/, "     ")
        puts ""
      end
    end
  end

  def deal_numbers
    @deal_numbers = []
    @deals.each do |deal|
        i = "#{deal.number}".to_i
      @deal_numbers << i
    end
    @deal_numbers
  end

  def show_deal_detail
    input = nil
    while input != "exit"
      deal_message

      input = gets.strip.downcase
      puts ""
      i = input.to_i
      deal_numbers

      if @deal_numbers.include?(i)
        space
        puts "Please see below details of deal no. #{input}".upcase.cyan.bold
        disply_deal(BASE_URL, input, product_url)
      elsif !@deal_numbers.include?(i) && i.between?(1, 100)
        puts "Deal ##{input} is not from the list ##{@input1}.".yellow
        available_options
      elsif input == "list"
        available_lists
        break
      elsif input == "select list"
        select_list_of_deals
        break
      break elsif input == "exit"
        goodbye
        break
      else
        error_handling
        available_options
      end

    end
  end

  def space
    puts ""
    puts "-----------------------------------------------------------------------------------------------------------"
    puts ""
  end

  def deal_message
    puts ""
    puts "Enter the number of deal you would like more info on or type Exit.".light_blue.bold
    puts ""
  end

  def error_handling
    puts "Don't understand your command.".colorize(:color => :white, :background => :red)
  end

  def available_options
    puts "Type 'SELECT LIST' to see available deal lists.".yellow
    puts "Type 'LIST' to see the current deal list.".yellow
    puts "Type 'EXIT' to exit.".yellow
    puts ""
  end

  def disply_deal(base_url, input, product_url)
    deal = PopularDeals::Scrapper.deal_page(BASE_URL, input, product_url)
    keys = deal.keys
    puts ""
    puts "DEAL:".magenta.bold.gsub(/^/, "    ")
    puts "#{deal[keys[0]]}".gsub(/^/, "    ")
    puts ""
    puts "Description:".upcase.magenta.bold.gsub(/^/, "    ")
    puts "#{deal[keys[1]]}".gsub(/^/, "    ")
    puts ""

    if deal[keys[2]].nil?
      puts "To lock this deal, please visit:".upcase.magenta.bold.gsub(/^/, "    ")
      puts "#{product_url}".gsub(/^/, "    ")
    else
      puts "To lock this deal, please visit:".upcase.magenta.bold.gsub(/^/, "    ")
      puts "#{deal[keys[2]]}".gsub(/^/, "    ")
    end
    space
  end

  def goodbye
    shopping = ["We could give up shopping but we are not a quitter.", "When in doubt, go shopping.", "I still believe in the Holy Trinity, except now it's Target, Trader Joe's, and IKEA.", "I love shopping. There is a little bit of magic found in buying something new. It is instant gratification, a quick fix.", "If you can not stop thinking about it, Buy it!", "Shopping is cheaper than therapy."]
    line = shopping.sample
    puts ""
    print "#{line}".yellow
    puts "\u{1f609}"
    puts "Come back again for more deals. Have a great day!".yellow
    puts ""
  end

end
