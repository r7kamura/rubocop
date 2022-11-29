# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Checks for redundant comparison with boolean.
      #
      # @safety
      #   This cop is unsafe because while the condition is always considered to return a boolean
      #   value, it may not in fact. If the difference matters, it is not redundant. For example,
      #   `nil && false` returns `nil`, not `false`, so replacing it with `false` would change
      #   its result.
      #
      # @example
      #   # bad
      #   condition && false
      #
      #   # good
      #   false
      #
      #   # bad
      #   condition && true
      #
      #   # good
      #   condition
      #
      #   # bad
      #   condition || false
      #
      #   # good
      #   condition
      #
      #   # bad
      #   condition || true
      #
      #   # good
      #   true
      class RedundantComparisonWithBoolean < Base
        extend AutoCorrector

        include RangeHelp

        MSG = 'Remove redundant comparison.'

        # @!method match_something_and_false(node)
        def_node_matcher :match_something_and_false, <<~PATTERN
          (_
            <
              $_
              false
            >
          )
        PATTERN

        # @!method match_something_and_true(node)
        def_node_matcher :match_something_and_true, <<~PATTERN
          (_
            <
              $_
              true
            >
          )
        PATTERN

        def on_and(node)
          match_something_and_true(node) do |condition_node|
            add_offense(node) do |corrector|
              corrector.replace(node, condition_node.source)
            end
          end

          match_something_and_false(node) do |_|
            add_offense(node) do |corrector|
              corrector.replace(node, 'false')
            end
          end
        end

        def on_or(node)
          match_something_and_true(node) do |_|
            add_offense(node) do |corrector|
              corrector.replace(node, 'true')
            end
          end

          match_something_and_false(node) do |condition_node|
            add_offense(node) do |corrector|
              corrector.replace(node, condition_node.source)
            end
          end
        end
      end
    end
  end
end
