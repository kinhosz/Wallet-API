admin = User.create!([
  { name: 'admin', email: 'admin@email.com', password: '123456' },
]).first

categories = Finance::Category.create!([
  { 
    name: 'Salary', 
    description: 'Monthly Salary',
    uuid: '065b2332-b0f0-4e8a-a0cb-53e4cfa11610',
    user_id: admin.id,
    icon: 23,
  },
  { 
    name: 'Payment', 
    description: 'Arbitrary Payments',
    uuid: '8cc2bc37-67bd-4971-acee-fab1296cced3',
    user_id: admin.id,
    icon: 12,
  },
  { 
    name: 'School', 
    description: 'School expenses',
    uuid: '75db430c-acb5-4d7d-a193-d05657ee013d',
    user_id: admin.id,
    icon: 2,
  },
  { 
    name: 'House', 
    description: 'House expenses',
    uuid: 'ffd26970-49c4-49b9-9930-0398db62d91e',
    user_id: admin.id,
    icon: 8,
  },
  { 
    name: 'Food', 
    description: 'Food expenses',
    uuid: '3850cf70-0a54-40ea-b21f-187f9a66a8a5',
    user_id: admin.id,
    icon: 3,
  },
  { 
    name: 'Gym', 
    description: 'Gym expenses',
    uuid: '756dd78a-ec48-47f8-9aaf-e4569ff084e3',
    user_id: admin.id,
    icon: 18,
  },
])

plannings = Finance::Planning.create!([
  { currency: 'BRL', date_start: Date.today - 1.month, user_id: admin.id }
])

Finance::PlanningLine.create!([
  { value: 1400, finance_planning_id: plannings[0].id, finance_category_id: categories[0].id },
  { value: 500, finance_planning_id: plannings[0].id, finance_category_id: categories[1].id },
  { value: -420, finance_planning_id: plannings[0].id, finance_category_id: categories[2].id },
  { value: -300, finance_planning_id: plannings[0].id, finance_category_id: categories[3].id },
  { value: -250, finance_planning_id: plannings[0].id, finance_category_id: categories[4].id },
  { value: -180, finance_planning_id: plannings[0].id, finance_category_id: categories[5].id },
])

Finance::Transaction.create!([
  { currency: 'BRL', description: 'First balance', occurred_at: Date.today - 2.month, value: 500, finance_category_id: categories[0].id },
  { currency: 'BRL', description: 'Salary income', occurred_at: Date.today - 15.days, value: 1500, finance_category_id: categories[0].id },
  { currency: 'BRL', description: 'Freelance payment', occurred_at: Date.today - 10.days, value: 400, finance_category_id: categories[1].id },
  { currency: 'BRL', description: 'books', occurred_at: Date.today - 20.days, value: -380, finance_category_id: categories[2].id },
  { currency: 'BRL', description: 'New Bedroom', occurred_at: Date.today - 22.days, value: -350, finance_category_id: categories[3].id },
  { currency: 'BRL', description: 'Picnic', occurred_at: Date.today - 5.days, value: -250, finance_category_id: categories[4].id },
  { currency: 'BRL', description: 'Jiu jitsu', occurred_at: Date.today - 17.days, value: -100, finance_category_id: categories[5].id },
  { currency: 'BRL', description: 'Crossfit', occurred_at: Date.today - 40.days, value: -90, finance_category_id: categories[5].id },
])
