# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::RedundantComparisonWithBoolean, :config do
  context 'with `condition && false`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        condition && false
        ^^^^^^^^^^^^^^^^^^ Remove redundant comparison.
      RUBY

      expect_correction(<<~RUBY)
        false
      RUBY
    end
  end

  context 'with `condition && true`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        condition && true
        ^^^^^^^^^^^^^^^^^ Remove redundant comparison.
      RUBY

      expect_correction(<<~RUBY)
        condition
      RUBY
    end
  end

  context 'with `condition || false`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        condition || false
        ^^^^^^^^^^^^^^^^^^ Remove redundant comparison.
      RUBY

      expect_correction(<<~RUBY)
        condition
      RUBY
    end
  end

  context 'with `condition || true`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        condition || true
        ^^^^^^^^^^^^^^^^^ Remove redundant comparison.
      RUBY

      expect_correction(<<~RUBY)
        true
      RUBY
    end
  end
end
