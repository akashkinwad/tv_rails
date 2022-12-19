module ApiHelper

  def paginate(collection)
    total_count = collection.count
    current_page_num = collection.current_page
    last_page_num = collection.total_pages
    {
      previous_page: previous_page(current_page_num),
      current_page: collection.current_page,
      next_page:  collection.next_page,
      last_page: last_page_num,
      total_pages: collection.total_pages,
      total_count: total_count
    }
  end

  def previous_page(current_page_num)
    return nil if current_page_num <= 1
    current_page_num-1
  end

  def next_page(current_page_num, last_page_num)
    return nil if current_page_num >= last_page_num
    current_page_num+1
  end

end
