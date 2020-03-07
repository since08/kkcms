module DocProcessor
  def self.to_html(doc_path)
    html = PandocRuby.convert(IO.read(doc_path),
                              from: :docx,
                              to: :html,
                              'extract-media': "./public/uploads/doc/#{SecureRandom.hex(4)}")
    image_tags = html.scan(/<img.*?>/)
    image_tags.each do |tag|
      image_path = tag.match(/src="(.*?)"/)[1]
      image = AdminImage.create(image: File.open(image_path))
      html = html.gsub(tag, "<img src=\"#{image.original}\">")
    end
    html
  end
end