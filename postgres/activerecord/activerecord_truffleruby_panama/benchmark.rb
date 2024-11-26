require 'bundler/setup'
Bundler.require(:default)

require "securerandom"
require "active_record"
require "benchmark"

ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.string :title, null: false
    t.string :body
    t.string :type_name, null: false
    t.string :key, null: false
    t.integer :upvotes, null: false
    t.integer :author_id, null: false
    t.timestamps
  end
end

class Post < ActiveRecord::Base; end

ActiveRecord::Base.uncached do
  50000.times {
    Post.create!(title: SecureRandom.alphanumeric(30),
                 type_name: SecureRandom.alphanumeric(10),
                 key: SecureRandom.alphanumeric(10),
                 body: SecureRandom.alphanumeric(100),
                 upvotes: rand(30),
                 author_id: rand(30))
  }
end

Benchmark.bm(10) do |x|
  30.times do |n|
    x.report("ActiveRecord truffleruby postgres #{n}:") do
      ActiveRecord::Base.uncached do
        50000.times do |i|
          Post.where(id: i + 1).first.title
        end
      end
    end
  end
end

