require './test/helper'
require 'paperclip/registry'

class RegistryTest < Test::Unit::TestCase
  def setup
    Paperclip::Registry.clear
  end

  context '.names_for' do
    should 'include attachment names for the given class' do
      foo = Class.new
      Paperclip::Registry.add(foo, :avatar, {})

      assert_equal [:avatar], Paperclip::Registry.names_for(foo)
    end

    should 'not include attachment names for other classes' do
      foo = Class.new
      bar = Class.new
      Paperclip::Registry.add(foo, :avatar, {})
      Paperclip::Registry.add(bar, :lover, {})

      assert_equal [:lover], Paperclip::Registry.names_for(bar)
    end

    should 'produce the empty array for a missing key' do
      assert_empty Paperclip::Registry.names_for(Class.new)
    end
  end

  context '.each_definition' do
    should 'call the block with the class, attachment name, and options' do
      foo = Class.new
      expected_accumulations = [
        [foo,:avatar, { yo: 'greeting' }],
        [foo, :greeter, { ciao: 'greeting' }]
      ]
      expected_accumulations.each do |args|
        Paperclip::Registry.add(*args)
      end
      accumulations = []

      Paperclip::Registry.each_definition do |*args|
        accumulations << args
      end

      assert_equal expected_accumulations, accumulations
    end
  end

  context '.definitions_for' do
    should 'produce the attachment name and options' do
      expected_definitions = {
        avatar: { yo: 'greeting' },
        greeter: { ciao: 'greeting' }
      }
      foo = Class.new
      Paperclip::Registry.add(foo, :avatar, { yo: 'greeting' })
      Paperclip::Registry.add(foo, :greeter, { ciao: 'greeting' })

      definitions = Paperclip::Registry.definitions_for(foo)

      assert_equal expected_definitions, definitions
    end
  end

  context '.clear' do
    should 'remove all of the existing attachment definitions' do
      foo = Class.new
      Paperclip::Registry.add(foo, :greeter, { ciao: 'greeting' })

      Paperclip::Registry.clear

      assert_empty Paperclip::Registry.names_for(foo)
    end
  end
end
