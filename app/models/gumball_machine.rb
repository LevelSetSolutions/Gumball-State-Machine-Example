require 'workflow'

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
    		# We have to be careful with the order in which our methods or callbacks are executed.
    		# If we only used `def dispense` to subtract the gumball quantity, we wouldn't be able to use
    		# the proc below to decide what state to transition it to. We would need to use == 1 or > 1 instead.
    		@gumballs = @gumballs - 1

    		# This calls the event to transition to either `sold out` or `no quarter`
    		dispense!
    	end

    	# We are checking what the CURRENT gumball count is, not what it WILL be after dispensing. It hits
    	# the first event, and if the condition is not true, it moves on to the next. If no conditions are true,
    	# it will throw an error for no available events.
      event :dispense, :transitions_to => :sold_out, :if => proc { |machine| machine.gumballs == 0 }
      event :dispense, :transitions_to => :no_quarter, :if => proc { |machine| machine.gumballs > 0 }
    end
    state :sold_out do
      event :refill, :transitions_to => :no_quarter
    end

    # This gets executed on every single transition. It's not required, I'm just using it to output the 
    # transitions to the console so we can see them.
	  on_transition do |from, to, triggering_event, *event_args|
	    puts "****** #{from} -> #{to} ******"
	  end

  end


  def initialize
  	@gumballs = 3
  end

  def dispense
  	puts "Here comes the gumball! #{@gumballs} are left in the machine."
  end

  def refill
  	@gumballs = 3
  end

end


# gc = GumballMachine.new
# gc.insert_quarter!
# gc.turn_crank!
