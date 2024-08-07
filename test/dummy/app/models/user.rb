# frozen_string_literal: true

class User < ApplicationRecord
  enummer permissions: %i[read write execute]

  enummer facial_features: %i[nose mouth eyes], _prefix: true
  enummer diets: {
            alcohol: 1,
            cigarettes: 0,
            greens: 2
          }, _prefix: "consumes"

  enummer transport: %i[car truck submarine], _suffix: true
  enummer home: %i[box apartment house], _suffix: "home"
end
