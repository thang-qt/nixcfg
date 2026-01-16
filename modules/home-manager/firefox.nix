{
  config,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    profiles.thang = {
      settings = {
        "apz.overscroll.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
        "general.autoScroll" = true;
        "general.smoothScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.trimHttps" = true;
        "browser.urlbar.trimURLs" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "browser.compactmode.show" = true;
        "browser.formfill.enable" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.revamp.round-content-area" = true;
        "sidebar.visibility" = "expand-on-hover";
        "services.sync.engine.addresses" = false;
        "services.sync.engine.history" = false;
        "services.sync.engine.passwords" = false;
        "signon.rememberSignons" = false;
        "dom.forms.autocomplete.formautofill" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
      };
    };
  };
}
