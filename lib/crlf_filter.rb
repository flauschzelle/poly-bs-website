class CrlfFilter < Nanoc::Filter
    identifier :crlf
    type :text
    def run(content, params={})
        content.encode(universal_newline: true).encode(crlf_newline: true)
    end
end
