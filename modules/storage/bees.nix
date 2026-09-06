{ ... }:

{
  services.beesd.filesystems.hp = {
    spec = "/";
    hashTableSizeMB = 256;
    verbosity = "crit";
  };
}
