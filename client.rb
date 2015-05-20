require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'base64'
require 'pp'

client = Google::APIClient.new(
  :application_name => 'Example Ruby application',
  :application_version => '1.0.0'
)

# use pkc12
key = Google::APIClient::KeyUtils.load_from_pkcs12('client.p12', 'notasecret')
client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => ['https://www.googleapis.com/auth/pubsub','https://www.googleapis.com/auth/cloud-platform'],
  :issuer => '848252309922-665kbdgdnoernrh0fslg99d3e7j9atrf@developer.gserviceaccount.com',
  :signing_key => key)
client.authorization.fetch_access_token!

# use OAuth 2.0
# client_secrets = Google::APIClient::ClientSecrets.load
#
# flow = Google::APIClient::InstalledAppFlow.new(
#   :client_id => client_secrets.client_id,
#   :client_secret => client_secrets.client_secret,
#   :scope => ['https://www.googleapis.com/auth/pubsub','https://www.googleapis.com/auth/cloud-platform']
# )
#
# client.authorization = flow.authorize

pubsub = client.discovered_api('pubsub', 'v1beta2')

pp Time.now
# Make an API call.
result = client.execute(
  :api_method => pubsub.projects.topics.publish,
  :parameters => {
    'topic' => 'projects/dev-yamashita/topics/topic-pubsub-api-appengine-sample'
  },
  :body_object => {
    'messages' => [
      {
        'data' => Base64.encode64('message from app2'),
        'attributes' => {
          'data1' => 'good',
          'data2' => 'bad',
        }
      }
    ]
  }
)
pp Time.now
puts result.data.to_json
result = client.execute(
  :api_method => pubsub.projects.topics.publish,
  :parameters => {
    'topic' => 'projects/dev-yamashita/topics/topic-pubsub-api-appengine-sample'
  },
  :body_object => {
    'messages' => [
      {
        'data' => Base64.encode64('うっひょー2'),
        'attributes' => {
          'data3' => 'good',
          'data4' => 'bad',
        }
      }
    ]
  }
)
pp Time.now
puts result.data.to_json
