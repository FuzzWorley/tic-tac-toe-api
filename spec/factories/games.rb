FactoryBot.define do
  factory :game do
    board { Matrix[[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]] }
    winner { nil }
    moves { 0 } 
  end
end