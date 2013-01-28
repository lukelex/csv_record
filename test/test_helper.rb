require 'minitest/spec'
require 'minitest/autorun'
require 'turn'
require 'csv_record'

require_relative 'helpers'

class MiniTest::Spec
  include Helpers

  after :each do
    FileUtils.rm_rf 'db'
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
  let(:obi_wan_kenobi_padawan) do
    Padawan.build(
      name: 'Obi Wan Kenobi',
      age: 22,
      midi_chlorians: '4k'
    )
  end
end