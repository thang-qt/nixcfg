{
  inputs,
  lib,
  pkgs,
  ...
}: let
  settings = {
    "browser.newtabpage.enabled" = false;
    "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
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
    "browser.newtabpage.activity-stream.trendingSearch.defaultSearchEngine" = "DuckDuckGo";
    "browser.search.defaultenginename" = "DuckDuckGo";
    "browser.search.defaultenginename.private" = "DuckDuckGo";
    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = false;
    "sidebar.revamp.round-content-area" = true;
    "sidebar.visibility" = "expand-on-hover";
    "sidebar.expandOnHover" = true;
    "sidebar.animation.enabled" = false;
    "browser.tabs.splitView.enabled" = true;
    "services.sync.engine.addresses" = false;
    "services.sync.engine.history" = false;
    "services.sync.engine.passwords" = false;
    "signon.rememberSignons" = false;
    "dom.forms.autocomplete.formautofill" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "network.trr.mode" = 2;
    "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
    "reader.color_scheme" = "sepia";
    "network.IDN_show_punycode" = true;
  };

  zen = pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped {
    pname = "zen-browser";
    extraPrefs = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "pref(${builtins.toJSON name}, ${builtins.toJSON value});") settings
    );
    extraPolicies = {
      DisableAppUpdate = true;
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "flowmouse@52pojie.cn" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/flowmouse/latest.xpi";
        };
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        };
      };
      "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite.filterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "plowe-0"
        "VIE-1"
      ];
    };
  };
in {
  home.packages = [zen];
}
