import WebKit


final class VKLoginViewController: UIViewController  {

    private var webView = WKWebView()

//MARK: - Life cycle
    override func viewDidLoad() {
        view.addSubview(webView)

        webView.frame = view.bounds
        webView.navigationDelegate = self
        launchingLoginPage()
    }

//MARK: - Private Methods

    private func launchingLoginPage() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: "7922677"),
                                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                    URLQueryItem(name: "display", value: "mobile"),
                                    URLQueryItem(name: "response_type", value: "token"),
                                    URLQueryItem(name: "scope", value: "270342"),
                                    URLQueryItem(name: "v", value: "5.131")]

        guard let url = urlComponents.url else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }

}

//MARK: - Extension

extension VKLoginViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard navigationResponse.response.url?.path == "/blank.html",
              let fragment = navigationResponse.response.url?.fragment else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }

        Session.shared.token = params["access_token"] ?? ""
        Session.shared.userID = params["user_id"] ?? ""

        present(Builder.makeTabBarController(), animated: true, completion: nil)
        decisionHandler(.cancel)

    }

}
