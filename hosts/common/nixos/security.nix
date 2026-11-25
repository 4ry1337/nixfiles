{ pkgs, ... }:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    apparmor = {
      enable = false;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };

    # Prevent replacing the running kernel without a reboot
    protectKernelImage = true;
    # Uncomment when using security.acme to auto-issue Let's Encrypt TLS certs
    # acme.acceptTerms = true;
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" = 0;
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk" = "3 3 3 3";
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.yama.ptrace_scope" = 1;
  };
}
