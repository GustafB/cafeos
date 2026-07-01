{ pkgs, ... }:
{
  # C++ toolchain. GCC 15 is the primary compiler and supports all of C++23
  # plus experimental C++26 (compile with `-std=c++26`). It provides the
  # cc/c++/gcc/g++ drivers in the profile.
  #
  # We intentionally do NOT add the full `clang` compiler here: it also ships
  # cc/c++ wrappers and would collide with gcc in the home-manager profile.
  # `clang-tools` gives us clangd/clang-format/clang-tidy without that clash.
  # If you want clang as an actual compiler for a project, pull it into a
  # per-project devShell (nix develop / direnv) instead.
  home.packages = with pkgs; [
    gcc15 # C/C++ compiler (C++23 + experimental C++26)

    # build systems / helpers
    cmake
    ninja
    gnumake
    pkg-config
    ccache

    # debuggers
    gdb
    lldb

    # LSP + formatting/linting for Neovim (clangd, clang-format, clang-tidy)
    clang-tools
  ];
}
