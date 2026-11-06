import Lambdapad

blog do
  extension("extensions/postinfo.exs")
  extension("extensions/reading_time.exs")

  config do
    set(
      transform: fn config ->
        desc_entry = get_in(config, ["blog", "description"])

        truncate_fn = fn str ->
          raw_desc = str |> to_string() |> String.split() |> Enum.join(" ")
          max_len = 155

          if String.length(raw_desc) <= max_len do
            raw_desc
          else
            words = raw_desc |> String.slice(0, max_len - 1) |> String.split(" ")

            case Enum.slice(words, 0, max(length(words) - 1, 1)) do
              kept when kept != [] -> Enum.join(kept, " ") <> "…"
              _ -> String.slice(raw_desc, 0, max_len - 1) <> "…"
            end
          end
        end

        desc =
          if is_map(desc_entry) do
            Map.new(desc_entry, fn {k, v} -> {k, truncate_fn.(v)} end)
          else
            truncate_fn.(desc_entry || "")
          end

        config
        |> put_in(["blog", "description"], desc)
        |> Map.put("site_root", "/")
        |> Map.put("current_year", Date.utc_today().year)
      end
    )
  end

  source(posts: "posts/**/*.md")

  assets "css" do
    set(from: "assets/**/*.css")
    set(to: "site/")
    set(tool: :tailwind)
    set(tailwind: [
      path:
        System.get_env("TAILWIND_PATH") ||
          System.find_executable("tailwind") ||
          Path.expand("tailwind-macos-arm64"),
      extra_args: ~w(--minify)
    ])
  end

  assets "general" do
    set(from: "assets/{favicon,images,og,x}/**")
    set(to: "site/assets")
  end

  assets "static" do
    set(from: "static/*")
    set(to: "site/")
  end

  widget "recent_posts" do
    set(from: :posts)
    set(index: true)
    set(var_name: "posts")
    set(template: "recent_posts.html.eex")
    set(format: :eex)
    set(transform_on_item: ["date", "author", "tags", "reading_time"])
    set(transform_on_page: ["filter by language", "order by date desc"])
  end

  # Widgets registered so `lpad gettext` extracts their strings automatically
  widget "i18n_head" do
    set(from: nil)
    set(var_name: "data")
    set(template: "head.html.eex")
    set(format: :eex)
  end

  widget "i18n_header" do
    set(from: nil)
    set(var_name: "data")
    set(template: "header.html.eex")
    set(format: :eex)
  end

  widget "i18n_footer" do
    set(from: nil)
    set(var_name: "data")
    set(template: "footer.html.eex")
    set(format: :eex)
  end

  pages "root" do
    set(uri: "/")
    set(template: "redirect.html.eex")
    set(format: :eex)
    set(language: "es")
  end

  pages "index" do
    set(from: :posts)
    set(index: true)
    set(var_name: "posts")
    set(uri: "/{{ language }}/")
    set(template: "index.html.eex")
    set(format: :eex)
    set(transform_on_item: ["date", "author", "tags", "reading_time"])
    set(transform_on_page: ["filter by language", "order by date desc"])
  end

  pages "posts index" do
    set(from: :posts)
    set(index: true)
    set(var_name: "posts")
    set(uri: "/{{ language }}/posts")
    set(template: "index.html.eex")
    set(format: :eex)
    set(transform_on_item: ["date", "author", "tags", "reading_time"])
    set(transform_on_page: ["filter by language", "order by date desc"])
  end

  pages "posts" do
    set(from: :posts)
    set(var_name: "post")
    set(uri: "/{{ language }}/posts/{{ post.id }}")
    set(template: "post.html.eex")
    set(format: :eex)
    set(transform_on_item: ["date", "author", "tags", "reading_time"])
    set(transform_on_page: ["filter by language"])
  end

  pages "sitemap" do
    set(from: :posts)
    set(index: true)
    set(var_name: "posts")
    set(uri: "/sitemap.xml")
    set(uri_type: :file)
    set(template: "sitemap.xml.eex")
    set(format: :eex)
    set(language: "es")
    set(transform_on_item: ["date"])
    set(transform_on_page: ["order by date desc"])
  end
end
