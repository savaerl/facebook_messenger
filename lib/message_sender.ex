defmodule FacebookMessenger.Sender do
  @moduledoc """
  Module responsible for communicating back to facebook messenger
  """
  require Logger

  @doc """
  sends a message to the the recepient

    * :recepient - the recepient to send the message to
    * :message - the message to send
  """
  @spec send(String.t, String.t) :: HTTPotion.Response.t
  def send(recepient, message) do
    res = manager.post(
      url: url,
      body: text_payload(recepient, message) |> to_json
    )
    Logger.info("response from FB #{inspect(res)}")
    res
  end

  @doc """
  sends an image message to the recipient

  * :recepient - the recepient to send the message to
  * :image_url - the url of the image to be sent
  """
  @spec send_image(String.t, String.t) :: HTTPotion.Response.t
  def send_image(recepient, image_url) do
    res = manager.post(
      url: url,
      body: image_payload(recepient, image_url) |> to_json
    )
    Logger.info("response fro FB #{inspect(res)}")
    res
  end

  @spec send_code(String.t, Map.t()) :: HTTPotion.Response.t
  def send_code(recepient, body_map) do
    res = manager.post(
      url: url_code(),
      body: body_map |> to_json
    )
    Logger.info("response fro FB #{inspect(res)}")
    res
  end
  @doc """
  sends a default messages to the recipient

  * :recepient - the recepient to send the message to
  * :body_lists - keyword lists
  """
  @spec send_default(String.t, Map.t()) :: HTTPotion.Response.t
  def send_default(recepient, body_map) do
    res = manager.post(
      url: url,
      body: body_payload(recepient, body_map) |> to_json
    )
    Logger.info("response fro FB #{inspect(res)}")
    res
  end

  @doc """
  creates a payload to send to facebook

    * :recepient - the recepient to send the message to
    * :message - the message to send
  """
  def text_payload(recepient, message) do
    %{
      recipient: %{id: recepient},
      message: %{text: message}
    }
  end



  @doc """
  creates a payload for an image message to send to facebook

    * :recepient - the recepient to send the message to
    * :image_url - the url of the image to be sent
  """
  def image_payload(recepient, image_url) do
    %{
      recipient: %{id: recepient},
      message: %{
        attachment: %{
          type: "image",
          payload: %{
            url: image_url
          }
        }
      }
    }
  end

  def body_payload(recepient, body_map) do
    %{
      recipient: %{id: recepient},
      message: body_map
    }
  end

  @doc """
  converts a map to json using poison

  * :map - the map to be converted to json
  """
  def to_json(map) do
    map
    |> Poison.encode
    |> elem(1)
  end

  @doc """
  return the url to hit to send the message
  """
  def url do
    query = "access_token=#{page_token}"
    "https://graph.facebook.com/v2.6/me/messages?#{query}"
  end

  def url_code() do
    query = "access_token=#{page_token}"
    "https://graph.facebook.com/v2.6/me/messenger_codes?#{query}"
  end


  defp page_token do
    Application.get_env(:facebook_messenger, :facebook_page_token)
  end

  defp manager do
    Application.get_env(:facebook_messenger, :request_manager) || FacebookMessenger.RequestManager
  end
end
