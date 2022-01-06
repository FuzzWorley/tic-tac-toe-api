FactoryBot.define do
  factory :game do
    tiles { [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]] }
    winner { nil }
    moves { 0 } 
  end
end