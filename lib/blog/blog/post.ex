defmodule Blog.Blog.Post do
  @enforce_keys [:id, :author, :title, :banner, :body, :description, :tags, :date]
  defstruct [:id, :author, :title, :banner, :body, :description, :tags, :date]

  def build(filename, attrs, body) do
    IO.inspect(attrs)
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    struct!(__MODULE__, [id: id, date: date, body: body] ++ Map.to_list(attrs))
  end
end
