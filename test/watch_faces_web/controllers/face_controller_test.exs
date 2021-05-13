defmodule WatchFacesWeb.FaceControllerTest do
  use WatchFacesWeb.ConnCase

  alias WatchFaces.Faces

  @create_attrs %{author: 42, keywords: [], name: "some name"}
  @update_attrs %{author: 43, keywords: [], name: "some updated name"}
  @invalid_attrs %{author: nil, keywords: nil, name: nil}

  def fixture(:face) do
    {:ok, face} = Faces.create_face(@create_attrs)
    face
  end

  describe "index" do
    test "lists all faces", %{conn: conn} do
      conn = get(conn, Routes.face_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Faces"
    end
  end

  describe "new face" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.face_path(conn, :new))
      assert html_response(conn, 200) =~ "New Face"
    end
  end

  describe "create face" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.face_path(conn, :create), face: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.face_path(conn, :show, id)

      conn = get(conn, Routes.face_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Face"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.face_path(conn, :create), face: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Face"
    end
  end

  describe "edit face" do
    setup [:create_face]

    test "renders form for editing chosen face", %{conn: conn, face: face} do
      conn = get(conn, Routes.face_path(conn, :edit, face))
      assert html_response(conn, 200) =~ "Edit Face"
    end
  end

  describe "update face" do
    setup [:create_face]

    test "redirects when data is valid", %{conn: conn, face: face} do
      conn = put(conn, Routes.face_path(conn, :update, face), face: @update_attrs)
      assert redirected_to(conn) == Routes.face_path(conn, :show, face)

      conn = get(conn, Routes.face_path(conn, :show, face))
      assert html_response(conn, 200) =~ ""
    end

    test "renders errors when data is invalid", %{conn: conn, face: face} do
      conn = put(conn, Routes.face_path(conn, :update, face), face: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Face"
    end
  end

  describe "delete face" do
    setup [:create_face]

    test "deletes chosen face", %{conn: conn, face: face} do
      conn = delete(conn, Routes.face_path(conn, :delete, face))
      assert redirected_to(conn) == Routes.face_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.face_path(conn, :show, face))
      end
    end
  end

  defp create_face(_) do
    face = fixture(:face)
    %{face: face}
  end
end
