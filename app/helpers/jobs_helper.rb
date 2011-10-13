module JobsHelper    
    def sorting_href(column,order_by,direction)
        new_direction = direction
        if order_by == column
            if (direction == "DESC")
                new_direction = "ASC"
            else
                new_direction = "DESC"
            end
        end
        return "?order_by=" + column + "&direction=" + new_direction
    end
end
