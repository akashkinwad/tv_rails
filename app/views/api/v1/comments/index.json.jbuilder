json.array! @comments do |comment|
  json.partial! "api/v1/comments/comment", comment: comment
  json.replies do
    json.array! comment.replies do |r1|
      json.partial! "api/v1/comments/comment", comment: r1
      json.replies do
        json.array! r1.replies do |r2|
          json.partial! "api/v1/comments/comment", comment: r2
          json.replies do
            json.array! r2.replies do |r3|
              json.partial! "api/v1/comments/comment", comment: r3
              json.replies do
                json.array! r3.replies do |r4|
                  json.partial! "api/v1/comments/comment", comment: r4
                  json.replies do
                    json.array! r4.replies do |r5|
                      json.partial! "api/v1/comments/comment", comment: r5
                      json.replies do
                        json.array! r5.replies do |r6|
                          json.partial! "api/v1/comments/comment", comment: r6
                          json.replies do
                            json.array! r6.replies do |r7|
                              json.partial! "api/v1/comments/comment", comment: r7
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
