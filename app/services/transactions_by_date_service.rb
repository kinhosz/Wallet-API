class TransactionsByDateService
    def initialize(user)
        plannings = user.finance_planning
        lines = []
        plannings do |planning|
            lines += planning.lines
        end

        @categories = lines.map(&:finance_categories).uniq
    end

    def get(date_start, date_end)
        transactions = []
        @categories do |category|
            transaction += category.transactions.where(occurred_at: date_start..date_end)
        end

        transactions
    end
end
