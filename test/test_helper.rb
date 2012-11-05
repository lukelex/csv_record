require 'minitest/spec'
require 'minitest/autorun'
require 'turn'

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
end