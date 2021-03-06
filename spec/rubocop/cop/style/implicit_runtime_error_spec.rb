# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::ImplicitRuntimeError do
  subject(:cop) { described_class.new }

  %w[raise fail].each do |method|
    it "registers an offense for #{method} 'message'" do
      inspect_source("#{method} 'message'")
      expect(cop.offenses.size).to eq 1
      expect(cop.messages).to eq(["Use `#{method}` with an explicit " \
                                 'exception class and message, rather than ' \
                                 'just a message.'])
      expect(cop.highlights).to eq(["#{method} 'message'"])
    end

    it "registers an offense for #{method} with a multiline string" do
      inspect_source(["#{method} 'message' \\", "'2nd line'"])
      expect(cop.offenses.size).to eq 1
      expect(cop.messages).to eq(["Use `#{method}` with an explicit " \
                                 'exception class and message, rather than ' \
                                 'just a message.'])
      expect(cop.highlights).to eq(["#{method} 'message' \\\n'2nd line'"])
    end

    it "doesn't register an offense for #{method} StandardError, 'message'" do
      expect_no_offenses(<<-RUBY.strip_indent)
        #{method} StandardError, 'message'
      RUBY
    end

    it "doesn't register an offense for #{method} with no arguments" do
      expect_no_offenses(method)
    end
  end
end
