module SugarBlock::AllSugars

  include SugarBlock::Block::Nestable
  def has_block? keyword
    [:match].include? keyword or super
  end

  def create_block keyword
    ::SugarBlock::Sugar::MatchBlock.new(self)
  end
end

