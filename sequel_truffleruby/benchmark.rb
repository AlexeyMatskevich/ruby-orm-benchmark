require 'bundler/setup'
Bundler.require(:default)

require 'securerandom'
require 'sequel'
require 'benchmark'

DB = Sequel.connect(ENV["DATABASE_URL"])

DB.create_table(:posts) do
  primary_key :id
  String :title, null: false
  String :body
  String :type_name, null: false
  String :key, null: false
  Integer :upvotes, null: false
  Integer :author_id, null: false
  DateTime :created_at
  DateTime :updated_at
end

class Post < Sequel::Model(:posts)
end

50000.times do
  Post.create(
    title: SecureRandom.alphanumeric(30),
    type_name: SecureRandom.alphanumeric(10),
    key: SecureRandom.alphanumeric(10),
    body: SecureRandom.alphanumeric(100),
    upvotes: rand(30),
    author_id: rand(30),
    created_at: Time.now,
    updated_at: Time.now
  )
end

Benchmark.bm(10) do |x|
  30.times do |n|
    x.report("Sequel-tr run #{n}:") do
      Post.where(id: n + 1).first.title
    end
  end
end

# warmup
50000.times do |i|
  Post.where(id: i + 1).first.title
end

Benchmark.bm(10) do |x|
  x.report("Sequel-tr:") do
    50000.times do |i|
      Post.where(id: i + 1).first.title
    end
  end
end
