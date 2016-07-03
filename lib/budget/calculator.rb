module Budget
	class Calculator

		def initialize
			@service = GoogleApi.new
		end

		def grab_expenses( paychecks_to_grab = 1 )
			calendar_id = ''
			response = @service.list_events(calendar_id,
	                               max_results: 10,
	                               single_events: true,
	                               order_by: 'startTime',
	                               time_min: Payday.current.to_time.iso8601).items
			response.map {|x| Expense.new(x) }
		end

		def list_expenses( expenses )
			tp expenses
		end

		def current_expenses
			current = Payday.current.to_date
			nxt = Payday.next.to_date
			expenses_for_range( current, nxt)
		end

		def expenses_for_range(current, nxt)
			grab_expenses(4).select { |x| x.date >= current && x.date < nxt }
		end

		def show_budget
			puts "Current pay day: #{Payday.current}"
			puts "Amount due: #{current_expenses.inject(0) {|total,expense| total + expense.amount}}"
			list_expenses(current_expenses)
		end

	end

end