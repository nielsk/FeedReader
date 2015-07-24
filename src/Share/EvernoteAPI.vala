public class FeedReader.EvernoteAPI : GLib.Object {

    private Rest.OAuthProxy m_oauth;

    public EvernoteAPI()
    {
        if(settings_evernote.get_string("oauth-access-token") == "")
        {
            m_oauth = new Rest.OAuthProxy (
    			EvernoteSecrets.oauth_consumer_key,
    			EvernoteSecrets.oauth_consumer_secret,
    			EvernoteSecrets.base_uri,
    			false);
        }
        else
        {
            m_oauth = new Rest.OAuthProxy.with_token (
    			EvernoteSecrets.oauth_consumer_key,
    			EvernoteSecrets.oauth_consumer_secret,
                settings_evernote.get_string("oauth-access-token"),
                "",
    			EvernoteSecrets.base_uri,
    			false);

            settings_evernote.set_boolean("is-logged-in", true);
        }
    }

    public bool getRequestToken()
    {
        try
        {
			m_oauth.request_token("oauth", EvernoteSecrets.oauth_callback);
		}
        catch (Error e)
        {
			logger.print(LogMessage.ERROR, "EvernoteAPI: cannot get request token: " + e.message);
            return false;
		}

        settings_evernote.set_string("oauth-request-token", m_oauth.get_token());
        return true;
    }

    public bool getAccessToken()
    {
        if(settings_evernote.get_string("oauth-verifier") == "")
        {
            return false;
        }

        try {
			m_oauth.access_token("oauth", settings_evernote.get_string("oauth-verifier"));
		} catch (Error e) {
			logger.print(LogMessage.ERROR, "EvernoteAPI: cannot get access token: " + e.message);
            return false;
		}

        settings_evernote.set_string("oauth-access-token", m_oauth.get_token());
        return true;
    }

    public bool addBookmark(string url)
    {
        // FIXME: vala anyone? https://discussion.evernote.com/topic/86819-what-exactly-is-the-userstore/
        return false;
    }

    public bool getUsername()
    {
        // FIXME: vala anyone? https://discussion.evernote.com/topic/86819-what-exactly-is-the-userstore/
        return false;
    }

    private bool isLoggedIn()
    {
        // FIXME: vala anyone? https://discussion.evernote.com/topic/86819-what-exactly-is-the-userstore/
        return false;
    }

    public bool logout()
    {
        settings_evernote.set_string("username", "");
        settings_evernote.set_string("oauth-access-token", "");
        settings_evernote.set_string("oauth-verifier", "");
        settings_evernote.set_string("oauth-request-token", "");
        settings_evernote.set_boolean("is-logged-in", false);

        m_oauth = new Rest.OAuthProxy (
            EvernoteSecrets.oauth_consumer_key,
            EvernoteSecrets.oauth_consumer_secret,
            EvernoteSecrets.base_uri,
            false);

        return true;
    }
}
