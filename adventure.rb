#!/usr/bin/env ruby

require 'yaml'

class Step
  attr_reader :id, :script, :label, :actions

  def initialize(id, script, label, actions)
    @id = id
    @script = script
    @label = label
    @actions = actions
  end
end

def to_buildkite_pipeline(step)
  {
    "steps" => [
      {
        "command" => "ruby adventure.rb | buildkite-agent pipeline upload",
        "label" => step.label,
        "env" => { "ADVENTURE_SCRIPT" => step.script }
      },
      {
        "block" => ":point_right:",
        "prompt" => "Choose the next action!",
        "fields" => [ { "text" => "Yes", "key" => "#{step.id}-action" } ]
      }
    ]
  }
end

s = Step.new(:yes, :first, ":llama::", [ "Go Left", "Go Right" ])

puts to_buildkite_pipeline(s).to_yaml
