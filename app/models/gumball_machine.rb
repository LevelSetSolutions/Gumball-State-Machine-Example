require 'workflow'

# class GumballMachine < ActiveRecord::Base
class GumballMachine

	attr_accessor :workflow_state
	attr_accessor :gumballs

  include Workflow
  workflow do
    state :no_quarter do
      event :insert_quarter, :transitions_to => :has_quarter
    end
    state :has_quarter do
      event :turn_crank, :transitions_to => :sold
      event :eject_quarter, :transitions_to => :no_quarter
    end
    state :sold do
    	on_entry do
    		@gumballs = @gumballs - 1
    		dispense!
    	end

      event :dispense, :transitions_to => :sold_out, :if => proc { |machine| machine.gumballs == 0 }
      event :dispense, :transitions_to => :no_quarter, :if => proc { |machine| machine.gumballs > 0 }
    end
    state :sold_out do
      event :refill, :transitions_to => :no_quarter
    end
  end


  def initialize
  	@gumballs = 3
  end

  def turn_crank
  	puts current_state.to_s
  	# dispense!
  end

  def sold
  	# I'm considering the gumball gone at this point.
  	@gumballs = @gumballs - 1
  end

  def dispense
  	puts "Here comes the gumball! #{@gumballs} are left in the machine."
  end

  def is_empty?
  	@gumballs > 0
  end

  def refill
  	@gumballs = 3
  end

end


# machine = GumballMachine.new
# machine.insert_quarter!
# machine.turn_crank!
