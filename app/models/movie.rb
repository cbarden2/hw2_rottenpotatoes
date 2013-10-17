class Movie < ActiveRecord::Base
  @@possible = ['G','PG','PG-13','R','NC-17']
  def self.possible_ratings
    return @@possible
  end
end
