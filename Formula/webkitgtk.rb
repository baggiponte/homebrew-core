class Webkitgtk < Formula
  desc "GTK interface to WebKit"
  homepage "https://webkitgtk.org"
  url "https://webkitgtk.org/releases/webkitgtk-2.40.2.tar.xz"
  sha256 "96898870d994da406ee7a632816dcde9a3bb395ee5f344fcb3f3b8cc8a77e000"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://webkitgtk.org/releases/"
    regex(/webkitgtk[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "99a1439b13abfe2bcac3e84a7580a6f763a8ce8e2b25491de53b460209ab319d"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.11" => :build
  depends_on "cairo"
  depends_on "enchant"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libgcrypt"
  depends_on "libnotify"
  depends_on "libpng"
  depends_on "libsecret"
  depends_on "libsoup"
  depends_on "libwpe"
  depends_on "libxcomposite"
  depends_on "libxt"
  depends_on :linux # Use JavaScriptCore.Framework on macOS.
  depends_on "little-cms2"
  depends_on "mesa"
  depends_on "openjpeg"
  depends_on "systemd"
  depends_on "webp"
  depends_on "woff2"
  depends_on "wpebackend-fdo"

  uses_from_macos "perl" => :build
  uses_from_macos "ruby" => :build
  uses_from_macos "unifdef" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # patch to fix `BWRAP_EXECUTABLE` undefailed failure
  patch do
    url "https://github.com/WebKit/WebKit/commit/4977290ab4ab35258a6da9b13795c9b0f7894bf4.patch?full_index=1"
    sha256 "5d5fa4af5ae355ee1ea93aebb15d232cdb508c9804e31fe30c768ff4d330120d"
  end

  def install
    args = %w[
      -DPORT=GTK
      -DENABLE_BUBBLEWRAP_SANDBOX=OFF
      -DENABLE_DOCUMENTATION=OFF
      -DENABLE_GAMEPAD=OFF
      -DENABLE_MINIBROWSER=ON
      -DUSE_AVIF=ON
      -DUSE_GSTREAMER_GL=OFF
      -DUSE_JPEGXL=ON
      -DUSE_LIBHYPHEN=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>
      #include <webkit2/webkit2.h>

      static void destroyWindowCb(GtkWidget* widget, GtkWidget* window);
      static gboolean closeWebViewCb(WebKitWebView* webView, GtkWidget* window);

      int main(int argc, char* argv[])
      {
          // Initialize GTK+
          gtk_init(&argc, &argv);

          // Create an 800x600 window that will contain the browser instance
          GtkWidget *main_window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
          gtk_window_set_default_size(GTK_WINDOW(main_window), 800, 600);

          // Create a browser instance
          WebKitWebView *webView = WEBKIT_WEB_VIEW(webkit_web_view_new());

          // Put the browser area into the main window
          gtk_container_add(GTK_CONTAINER(main_window), GTK_WIDGET(webView));

          // Set up callbacks so that if either the main window or the browser instance is
          // closed, the program will exit
          g_signal_connect(main_window, "destroy", G_CALLBACK(destroyWindowCb), NULL);
          g_signal_connect(webView, "close", G_CALLBACK(closeWebViewCb), main_window);

          // Load a web page into the browser instance
          webkit_web_view_load_uri(webView, "http://www.webkitgtk.org/");

          // Make sure that when the browser area becomes visible, it will get mouse
          // and keyboard events
          gtk_widget_grab_focus(GTK_WIDGET(webView));

          // Make sure the main window and all its contents are visible
          gtk_widget_show_all(main_window);

          // Run the main GTK+ event loop
          gtk_main();

          return 0;
      }

      static void destroyWindowCb(GtkWidget* widget, GtkWidget* window)
      {
          gtk_main_quit();
      }

      static gboolean closeWebViewCb(WebKitWebView* webView, GtkWidget* window)
      {
          gtk_widget_destroy(window);
          return TRUE;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.1").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    # While we cannot open a browser window in CI, we can make sure that the test binary runs
    # and produces the expected warning.
    assert_match "cannot open display", shell_output("#{testpath}/test 2>&1", 1)

    # Test the JavaScriptCore interpreter.
    assert_match "Hello World", shell_output("#{libexec}/webkit2gtk-4.1/jsc -e \"debug('Hello World');\" 2>&1")
  end
end
