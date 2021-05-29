defmodule WatchFacesWeb.KeywordController do
  use WatchFacesWeb, :controller

  alias WatchFaces.Keywords
  alias WatchFaces.Keywords.Keyword

  def index(conn, _params) do
    keywords = Keywords.list_keywords()
    render(conn, "index.html", keywords: keywords)
  end

  def new(conn, _params) do
    changeset = Keywords.change_keyword(%Keyword{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"keyword" => keyword_params}) do
    case Keywords.create_keyword(keyword_params) do
      {:ok, keyword} ->
        conn
        |> put_flash(:info, "Keyword created successfully.")
        |> redirect(to: Routes.keyword_path(conn, :show, keyword))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    keyword = Keywords.get_keyword!(id)
    render(conn, "show.html", keyword: keyword)
  end

  def edit(conn, %{"id" => id}) do
    keyword = Keywords.get_keyword!(id)
    changeset = Keywords.change_keyword(keyword)
    render(conn, "edit.html", keyword: keyword, changeset: changeset)
  end

  def update(conn, %{"id" => id, "keyword" => keyword_params}) do
    keyword = Keywords.get_keyword!(id)

    case Keywords.update_keyword(keyword, keyword_params) do
      {:ok, keyword} ->
        conn
        |> put_flash(:info, "Keyword updated successfully.")
        |> redirect(to: Routes.keyword_path(conn, :show, keyword))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", keyword: keyword, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    keyword = Keywords.get_keyword!(id)
    {:ok, _keyword} = Keywords.delete_keyword(keyword)

    conn
    |> put_flash(:info, "Keyword deleted successfully.")
    |> redirect(to: Routes.keyword_path(conn, :index))
  end
end
