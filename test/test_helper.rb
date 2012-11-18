require 'minitest/spec'
require 'minitest/autorun'
require 'turn'
require 'pry'
require 'csv_record'

module TestHelper
  BASE_PATH = File.expand_path("../fixtures", __FILE__)

  def fetch_fixture_path(path)
    File.join(BASE_PATH, path)
  end
end

class MiniTest::Spec
  after :each do
    FileUtils.rm_rf 'db'
  end

  let(:car) do
    Car.build(
      year: 1997,
      make: 'Ford',
      model: 'E350',
      description: 'ac, abs, moon',
      price: 3000.00
    )
  end

  let(:jedi_council) { JediOrder.build rank: 'council' }
  let(:luke) do
    Jedi.build(
      name: 'Luke Skywalker',
      age: 18,
      midi_chlorians: '12k'
    )
  end
  let(:yoda) do
    Jedi.build(
      name: 'Yoda the green',
      age: 852,
      midi_chlorians: '8k'
    )
  end
  let(:qui_gon_jinn) do
    Jedi.build(
      name: 'Qui-Gon Jinn',
      age: 37,
      midi_chlorians: '3k'
    )
  end
end