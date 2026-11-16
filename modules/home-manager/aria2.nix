{
  programs.aria2 = {
    enable = true;
    settings = {
      user-agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36";

      continue = true;

      max-concurrent-downloads = 3;
      max-connection-per-server = 4;
      split = 4;
      file-allocation = "falloc";

      retry-wait = 5;
    };
  };
}
