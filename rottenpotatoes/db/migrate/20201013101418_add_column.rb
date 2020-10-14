class AddColumn < ActiveRecord::Migration
  def change
    add_column(Movie, :director, :string)
  end
end
