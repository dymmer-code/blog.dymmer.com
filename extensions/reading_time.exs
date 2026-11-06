import Lambdapad

transform "reading_time" do
  set(on: :item)

  set(
    run: fn post, _config ->
      words_count =
        (post["content"] || "")
        |> String.replace(~r/@|#|\$|%|&|\^|:|_|!|,/u, " ")
        |> String.split()
        |> length()

      Map.put(post, "reading_time", max(1, div(words_count, 200)))
    end
  )
end
