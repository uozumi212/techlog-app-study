module MarkdownHelper
  class HTMLWithRouge < Redcarpet::Render::HTML
    def block_code(code, language)
      formatter = Rouge::Formatters::HTML.new
      lexer = language.present? ? Rouge::Lexer.find_fancy(language, code) : Rouge::Lexers::PlainText.new
      lexer ||= Rouge::Lexers::PlainText.new
      %(<div class="markdown-code"><pre>#{formatter.format(lexer.lex(code))}</pre></div>)
    end
  end

  def markdown(text)
    renderer = HTMLWithRouge.new(filter_html: true, hard_wrap: true)
    options = {
      fenced_code_blocks: true,
      autolink: true,
      tables: true,
      strikethrough: true,
      lax_spacing: true
    }

    markdown = Redcarpet::Markdown.new(renderer, options)
    sanitize(
      markdown.render(text.to_s),
      tags: %w[h1 h2 h3 h4 h5 h6 p br ul ol li strong em code pre blockquote table thead tbody tr th td a div span],
      attributes: %w[href class]
    )
  end
end
