class ChatbotController < ApplicationController
  def index
  end

  def ask
    user_input = params[:question]
    response = get_response_from_huggingface(user_input)
    render json: { answer: response }
  end

  private

  def get_response_from_huggingface(input)
    api_key = ENV['HUGGING_FACE_API_KEY']
    url = 'https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill'
    headers = { 'Authorization' => "Bearer #{api_key}", 'Content-Type' => 'application/json' }
    response = HTTP.headers(headers).post(url, json: { inputs: input })
    response_body = JSON.parse(response.body)
    
    Rails.logger.debug "Response Body: #{response_body.inspect}"
    
    if response_body.is_a?(Array)
      response_body.dig(0, 'generated_text') || "Sorry, I didn't understand that."
    else
      response_body['generated_text'] || "Sorry, I didn't understand that."
    end
  end
end
