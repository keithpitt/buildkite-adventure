#!/usr/bin/env ruby

require 'yaml'

class Step
  attr_reader :page, :actions

  def initialize(page, actions)
    @page = page
    @actions = actions
  end
end

def to_buildkite_pipeline(step)
  {
    "steps" => [
      {
        "block" => ":point_right:",
        "prompt" => "Choose the next action!",
        "fields" => [ { "text" => "Yes", "key" => "decision" } ]
      },
      {
        "command" => "ruby adventure.rb 2> >(buildkite-agent pipeline upload)",
        "label" => ":book:"
      }
    ]
  }
end

s = Step.new("welcome", [ "Go Left", "Go Right" ])

STDOUT.puts `./pages/#{s.page}.sh`
STDERR.puts to_buildkite_pipeline(s).to_yaml
