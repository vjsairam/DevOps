import org.tadamhicks.JenkinsHttpClient

def buildApp(String morpheusUrl, Map<?, ?> postBody, String bearerToken) {
	JenkinsHttpClient http = new JenkinsHttpClient()
	http.postJson(morpheusUrl, postBody, bearerToken)
}
