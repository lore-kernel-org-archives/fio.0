Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7ADCC433EF
	for <fio@archiver.kernel.org>; Sat,  2 Oct 2021 10:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94F361AE0
	for <fio@archiver.kernel.org>; Sat,  2 Oct 2021 10:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhJBKag (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 2 Oct 2021 06:30:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57222 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbhJBKag (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Oct 2021 06:30:36 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4836B224F8;
        Sat,  2 Oct 2021 10:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633170529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JPu2gFZah2O7cXslGNAFgI3g75K1fy86R4XkdO5Wk0Q=;
        b=ypGmtm5e8Cpy9XCSaCcMjkgQgtKd8V6pRUeYnlH6l3TZ0OmbWtDxO7Ka1CJQtsQtJltOxH
        8hN1sAQrf6HZoUAlMVZ5naqsTzePPh3rj7ELv205uQXaxuWeQk0iV1kp8cbnhPcWvRz0g/
        FFl8Y7gXgmK35JxwmeffJ3MMkoRprlA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633170529;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JPu2gFZah2O7cXslGNAFgI3g75K1fy86R4XkdO5Wk0Q=;
        b=cPKXOZDhGgyIVVDDmh2kILeroQPSepPeEVO6TIEJkb7SpyvDG6BWyDlGu74MUG8AKdM43C
        u+UJcUiPET5mtpDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D6C9913B4E;
        Sat,  2 Oct 2021 10:28:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id a2HTMGA0WGGOZAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Sat, 02 Oct 2021 10:28:48 +0000
Received: from localhost (orpheus.olymp [local])
        by orpheus.olymp (OpenSMTPD) with ESMTPA id 8b6d3ca2;
        Sat, 2 Oct 2021 11:16:00 +0100 (WEST)
From:   Luis Henriques <lhenriques@suse.de>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Jens Axboe <axboe@kernel.dk>, fstests@vger.kernel.org,
        fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
References: <YVdBVdOjPLCayG1k@suse.de>
        <882f4c20-2e21-219b-0ca3-7e215e2d7cfa@kernel.dk>
        <YVeE2ZVkpGbTKZpG@mit.edu>
Date:   Sat, 02 Oct 2021 11:16:00 +0100
In-Reply-To: <YVeE2ZVkpGbTKZpG@mit.edu> (Theodore Ts'o's message of "Fri, 1
        Oct 2021 17:59:53 -0400")
Message-ID: <86ee93vijj.fsf@orpheus.olymp>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

"Theodore Ts'o" <tytso@mit.edu> writes:

> On Fri, Oct 01, 2021 at 02:46:09PM -0600, Jens Axboe wrote:
>> 
>> Hmm, do older versions fail? I see Ted suggested that 3.27 doesn't, can
>> you give that a go? If that does work, would be great if you could try
>> and bisect it.
>
> I just tried fio 3.28, and it worked for me.  So I don't think it's
> fio.

Awesome, thank you both for checking it out.  So, it's definitely
something in my test environment.

> Luis, could it be related to a  kernel config option?

Yeah, it could be.  I've tested this on a rolling release (openSUSE TW),
so it's definitely quite different from Debian 10.  It may take me a bit
to figure out what's going on, but I'll start with this kernel config and
report back any finding.

Again, thank you both for confirming it's working on your side.

Cheers,
-- 
Luis

>
> Here's the kernel config that I'm using.  Can you try copying the
> attached file to your .config, and then run "make olddefconfig", and
> then rebuild your kernel, and see if that works for you?  If so, then
> we'll try to narrow down which kernel config is making the difference.
>
> The other potential difference is that my test appliance is currently
> built using Debian 10 ("Buster").  There can be glibc or other
> userspace dependencies which make be making a difference, but that
> seems unlikely given that generic/095 is a pretty old test, and it's
> not trying to use anything new/exotic like io_uring.
>
>       	     	    	       	      	     - Ted
>
> CONFIG_LOCALVERSION="-xfstests"
> CONFIG_SYSVIPC=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_CGROUPS=y
> CONFIG_MEMCG=y
> CONFIG_BLK_CGROUP=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_CGROUP_PIDS=y
> CONFIG_CGROUP_RDMA=y
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CPUSETS=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_BPF=y
> CONFIG_USER_NS=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_BPF_SYSCALL=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_SLAB=y
> CONFIG_SMP=y
> CONFIG_X86_X2APIC=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_SPINLOCKS=y
> CONFIG_PARAVIRT_TIME_ACCOUNTING=y
> CONFIG_MCORE2=y
> CONFIG_NR_CPUS=48
> # CONFIG_X86_MCE_AMD is not set
> # CONFIG_MICROCODE is not set
> CONFIG_NUMA=y
> # CONFIG_AMD_NUMA is not set
> CONFIG_X86_PMEM_LEGACY=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_EFI=y
> CONFIG_EFI_STUB=y
> CONFIG_HZ_300=y
> CONFIG_KEXEC=y
> # CONFIG_SUSPEND is not set
> # CONFIG_ACPI_REV_OVERRIDE_POSSIBLE is not set
> # CONFIG_ACPI_TABLE_UPGRADE is not set
> # CONFIG_PCI_MMCONFIG is not set
> CONFIG_IA32_EMULATION=y
> # CONFIG_DMIID is not set
> CONFIG_EFI_VARS=y
> CONFIG_JUMP_LABEL=y
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTREMOVE=y
> CONFIG_ZONE_DEVICE=y
> CONFIG_NET=y
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> CONFIG_UNIX_DIAG=y
> CONFIG_INET=y
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_UDP_DIAG=y
> CONFIG_NETLINK_DIAG=y
> # CONFIG_WIRELESS is not set
> CONFIG_NET_9P=y
> CONFIG_NET_9P_VIRTIO=y
> CONFIG_PCI=y
> CONFIG_PCI_MSI=y
> CONFIG_DEVTMPFS=y
> CONFIG_MTD=y
> CONFIG_MTD_BLOCK2MTD=y
> CONFIG_MTD_UBI=y
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_VIRTIO_BLK=y
> CONFIG_BLK_DEV_NVME=y
> CONFIG_SCSI=y
> # CONFIG_SCSI_PROC_FS is not set
> CONFIG_BLK_DEV_SD=y
> CONFIG_SCSI_VIRTIO=y
> CONFIG_MD=y
> CONFIG_BLK_DEV_DM=y
> CONFIG_DM_SNAPSHOT=y
> CONFIG_DM_THIN_PROVISIONING=y
> CONFIG_DM_ZERO=y
> CONFIG_DM_FLAKEY=y
> CONFIG_NETDEVICES=y
> CONFIG_VIRTIO_NET=y
> # CONFIG_ETHERNET is not set
> # CONFIG_WLAN is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=32
> # CONFIG_HW_RANDOM_INTEL is not set
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_HW_RANDOM_VIRTIO=y
> CONFIG_RANDOM_TRUST_CPU=y
> # CONFIG_HWMON is not set
> # CONFIG_X86_PKG_TEMP_THERMAL is not set
> # CONFIG_HID is not set
> # CONFIG_USB_SUPPORT is not set
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_DRV_CMOS is not set
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO_PCI=y
> CONFIG_VIRTIO_BALLOON=y
> # CONFIG_X86_PLATFORM_DEVICES is not set
> # CONFIG_IOMMU_SUPPORT is not set
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> CONFIG_EXT4_DEBUG=y
> CONFIG_JBD2_DEBUG=y
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> CONFIG_JFS_SECURITY=y
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_OCFS2_FS=y
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> CONFIG_BTRFS_DEBUG=y
> CONFIG_BTRFS_ASSERT=y
> CONFIG_NILFS2_FS=y
> CONFIG_F2FS_FS=y
> CONFIG_F2FS_FS_SECURITY=y
> CONFIG_F2FS_CHECK_FS=y
> CONFIG_FS_DAX=y
> CONFIG_FS_ENCRYPTION=y
> CONFIG_FS_VERITY=y
> CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> # CONFIG_PRINT_QUOTA_WARNING is not set
> CONFIG_QFMT_V2=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> CONFIG_VIRTIO_FS=y
> CONFIG_OVERLAY_FS=y
> CONFIG_UDF_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_UTF8=y
> CONFIG_NTFS_FS=y
> CONFIG_NTFS_RW=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_CHILDREN=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_UBIFS_FS=y
> CONFIG_NFS_FS=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> CONFIG_NFSD=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_9P_FS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_UTF8=y
> CONFIG_UNICODE=y
> CONFIG_SECURITY=y
> CONFIG_FORTIFY_SOURCE=y
> CONFIG_INTEGRITY_SIGNATURE=y
> CONFIG_IMA=y
> CONFIG_IMA_WRITE_POLICY=y
> CONFIG_IMA_APPRAISE=y
> CONFIG_EVM=y
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_ADIANTUM=y
> CONFIG_CRYPTO_ESSIV=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_PRINTK_TIME=y
> CONFIG_DYNAMIC_DEBUG=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_INFO_REDUCED=y
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_DEBUG_WX=y
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y
> CONFIG_PANIC_TIMEOUT=5
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_WQ_WATCHDOG=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LIST=y
> CONFIG_DEBUG_SG=y
> CONFIG_RCU_EQS_DEBUG=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_PROFILER=y
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAIL_MAKE_REQUEST=y
> CONFIG_FAULT_INJECTION_DEBUG_FS=y
