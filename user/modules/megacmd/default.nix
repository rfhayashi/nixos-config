{ pkgs, ...}:
{
  home.packages = [ pkgs.megacmd ];

  home.file.".megaCmd/excluded".text = ''
    Thumbs.db
    desktop.ini
    ~.*
  '';
}
