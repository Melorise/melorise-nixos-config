{ ... }:

{
  boot.supportedFilesystems."ntfs-3g" = true;

  # 使用 ntfs-3g 提供的 mount.ntfs，避免 UDisks 优先选择内核 ntfs3 驱动。
  services.udisks2.settings."mount_options.conf".defaults = {
    ntfs_drivers = "ntfs";
  };
}
