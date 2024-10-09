{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
      brewfile = true;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
