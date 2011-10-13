module ApplicationHelper
    def decode(input)
        coder = HTMLEntities.new
        return coder.decode(input)
    end
end
