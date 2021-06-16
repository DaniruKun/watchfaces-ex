defmodule WatchFacesWeb.KeywordControllerTest do
  use WatchFacesWeb.ConnCase

  alias WatchFaces.Keywords

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:keyword) do
    {:ok, keyword} = Keywords.create_keyword(@create_attrs)
    keyword
  end

  describe "index" do
    test "lists all keywords", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Keywords"
    end
  end

  describe "new keyword" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :new))
      assert html_response(conn, 200) =~ "New Keyword"
    end
  end

  describe "create keyword" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.keyword_path(conn, :create), keyword: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.keyword_path(conn, :show, id)

      conn = get(conn, Routes.keyword_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Keyword"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.keyword_path(conn, :create), keyword: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Keyword"
    end
  end

  describe "edit keyword" do
    setup [:create_keyword]

    test "renders form for editing chosen keyword", %{conn: conn, keyword: keyword} do
      conn = get(conn, Routes.keyword_path(conn, :edit, keyword))
      assert html_response(conn, 200) =~ "Edit Keyword"
    end
  end

  describe "update keyword" do
    setup [:create_keyword]

    test "redirects when data is valid", %{conn: conn, keyword: keyword} do
      conn = put(conn, Routes.keyword_path(conn, :update, keyword), keyword: @update_attrs)
      assert redirected_to(conn) == Routes.keyword_path(conn, :show, keyword)

      conn = get(conn, Routes.keyword_path(conn, :show, keyword))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, keyword: keyword} do
      conn = put(conn, Routes.keyword_path(conn, :update, keyword), keyword: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Keyword"
    end
  end

  describe "delete keyword" do
    setup [:create_keyword]

    test "deletes chosen keyword", %{conn: conn, keyword: keyword} do
      conn = delete(conn, Routes.keyword_path(conn, :delete, keyword))
      assert redirected_to(conn) == Routes.keyword_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.keyword_path(conn, :show, keyword))
      end
    end
  end

  defp create_keyword(_) do
    keyword = fixture(:keyword)
    %{keyword: keyword}
  end
end
