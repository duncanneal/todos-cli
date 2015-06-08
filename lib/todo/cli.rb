$LOAD_PATH.unshift File.expand_path('../../../config', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../../app/models', __FILE__)

require 'boot'
require 'list'
require 'item'

module Todo
  module CLI

    def self.add(list_name, list_item)
      list = List.find_by :name => list_name
      unless list
        list = List.create :name => list_name
        puts "Created list: #{list.name}."
      else
        puts "Found list #{list.name}."
      end
      puts "Creating list item."
      list.items.create :task => list_item
    end

    def self.list(list_name)
      unless list_name.blank? || list_name == "all"
        lists = List.where :name => list_name
      else
        lists = List.all
      end
      lists.each do |list|
        puts
        puts list.name
        puts "-" * list.name.length
        list.items.each do |item|
          done = item.is_complete ? '√' : ' '
          puts "[#{done}] #{item.id} #{item.task}"
        end
      end
    end

    def self.done(item_id)
      item = Item.find(item_id)
      item.complete!
      puts "Task: #{item.task} is done... Bam!!"
    end

    def self.next_item
     random_item = Item.order("RANDOM()").first
     puts random_item.task
   end
 
    def self.search(string)
      items = Item.where('task LIKE ?', '%' + string + '%')

    unless items.empty?
      puts "#{items.count} Matches.\n----------"

      items.each do |item|
        done = item.is_complete ? '√' : ' '
        puts "[#{done}] #{item.id} #{item.task}"
      end
    else
      puts "There were no matches."
    end
      puts ''
  end



    def self.run
      case ARGV[0]
        when "add"
          add(*ARGV[1..-1])

        when "list"
          list(ARGV[1])

        when "done"
          done(ARGV[1]) 

        when "next"
          next_item() 

        when "search"  
           search(ARGV[1]) 
        end
      end
    end
end
