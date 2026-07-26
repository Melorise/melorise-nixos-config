{ pkgs-thirdParty, ... }:

{
  # APM 需要系统级初始化、内核设置与桌面会话集成，不能只作为用户包安装。
  programs.amber-pm = {
    enable = true;
    package = pkgs-thirdParty.amber-pm;

    # 当前从空状态安装，首次切换配置时初始化 /var/lib/apm 与 ACE 环境。
    initializeState = true;
  };

  # Spark Store 需要系统级 Polkit 与桌面集成，因此安装到系统 Profile。
  environment.systemPackages = [
    pkgs-thirdParty.spark-store
  ];
}
