Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3KZSzh (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Nov 2013 13:55:37 -0500
Message-ID: <5294EE7F.2080609@kernel.dk>
Date: Tue, 26 Nov 2013 11:54:55 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Kernel message "BUG:soft lockup" during fio runs
References: <CA+C06oQ5fOZ5ND-3Tzcyd-DnbG_XQGCoppW74NHWMbF_wKV0Tg@mail.gmail.com>
In-Reply-To: <CA+C06oQ5fOZ5ND-3Tzcyd-DnbG_XQGCoppW74NHWMbF_wKV0Tg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saritha Vinod <sarithavn@gmail.com>, fio@vger.kernel.org

On 11/26/2013 11:14 AM, Saritha Vinod wrote:
> While running fio on RHEL 6.4, ppc_64, got the below error:
> BUG: soft lockup - CPU#0 stuck for 68s! [fio:49580]
> 
> The system does not respond during this interval. Observed this
> occurring multiple times.
> Has anyone faced this before? Could anyone please help me with this?
> 
> The dmesg output is pasted below.
> BUG: soft lockup - CPU#0 stuck for 68s! [fio:49580]
> Modules linked in: autofs4 sunrpc ipt_REJECT nf_conntrack_ipv4
> nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6
> nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6
> dm_round_robin dm_multipath shpchp ses enclosure sg be2net ext4 jbd2
> mbcache sd_mod crc_t10dif ipr lpfc scsi_transport_fc scsi_tgt
> dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
> NIP: c0000000002cefa8 LR: c0000000002cf548 CTR: d00000000d3a1120
> REGS: c000001f1ffcb790 TRAP: 0901   Not tainted  (2.6.32-358.el6.ppc64)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24002448  XER: 00000000
> TASK = c000001eb1a459b0[49580] 'fio' THREAD: c000001eb1d4c000 CPU: 0
> GPR00: c0000000002cf548 c000001f1ffcba10 c000000000f37e78 c000000f4cc64c60
> GPR04: 0000000000000000 0000000000001000 0000000000000000 0000000001327f78
> GPR08: c000001f02bd13c8 c000001effab9b00 c000001f1ffcbe90 ffffffffffffffff
> GPR12: 0000000024002442 c000000001002500
> NIP [c0000000002cefa8] .blk_update_request+0x38/0x5b0
> LR [c0000000002cf548] .blk_update_bidi_request+0x28/0xd0
> Call Trace:
> [c000001f1ffcba10] [0000000024002448] 0x24002448 (unreliable)
> [c000001f1ffcbae0] [c0000000002cf548] .blk_update_bidi_request+0x28/0xd0
> [c000001f1ffcbb70] [c0000000002d0a4c] .blk_end_bidi_request+0x2c/0x90
> [c000001f1ffcbc10] [c0000000003e2e48] .scsi_io_completion+0xc8/0x680
> [c000001f1ffcbce0] [c0000000003d7e68] .scsi_finish_command+0x128/0x190
> [c000001f1ffcbd80] [c0000000003e35e8] .scsi_softirq_done+0x1d8/0x210
> [c000001f1ffcbe20] [c0000000002d9b80] .blk_done_softirq+0xb0/0xe0
> [c000001f1ffcbeb0] [c00000000009c428] .__do_softirq+0x118/0x290
> [c000001f1ffcbf90] [c000000000032da8] .call_do_softirq+0x14/0x24
> [c000001eb1d4f810] [c00000000000e700] .do_softirq+0xf0/0x110
> [c000001eb1d4f8b0] [c00000000009c144] .irq_exit+0xb4/0xc0
> [c000001eb1d4f930] [c00000000000e964] .do_IRQ+0x144/0x230
> [c000001eb1d4f9e0] [c000000000004898] hardware_interrupt_entry+0x18/0x80
> --- Exception: 501 at .do_munmap+0x344/0x3d0
>     LR = .do_munmap+0x318/0x3d0
> [c000001eb1d4fd90] [c000000000187d54] .SyS_munmap+0x54/0x90
> [c000001eb1d4fe30] [c000000000008564] syscall_exit+0x0/0x40
> Instruction dump:
> fba1ffe8 fbc1fff0 fbe1fff8 fae1ffb8 fb01ffc0 f8010010 fb21ffc8 fb41ffd0
> fb61ffd8 f821ff31 ebc2c0c8 7c7d1b78 <7c9c2378> 7cbf2b78 e8030060 38600000
> INFO: task fio:49522 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> fio           D 00000080d6b76340     0 49522  49230 0x00008080
> Call Trace:
> [c000001eb30730b0] [c000001eb3073160] 0xc000001eb3073160 (unreliable)
> [c000001eb3073280] [c0000000000142d8] .__switch_to+0xf8/0x1d0
> [c000001eb3073310] [c0000000005ba5c8] .schedule+0x3f8/0xd30
> [c000001eb3073610] [c0000000005baf90] .io_schedule+0x90/0x110
> [c000001eb30736a0] [c000000000209100] .__blockdev_direct_IO_newtrunc+0xaa0/0xc70
> [c000001eb30737d0] [c00000000020932c] .__blockdev_direct_IO+0x5c/0x110
> [c000001eb30738a0] [c000000000206098] .blkdev_direct_IO+0x48/0x60
> [c000001eb3073940] [c00000000015002c] .generic_file_aio_read+0x72c/0x780
> [c000001eb3073a90] [c00000000020536c] .blkdev_aio_read+0x5c/0xf0
> [c000001eb3073b40] [c0000000001c2594] .do_sync_read+0xd4/0x160
> [c000001eb3073ce0] [c0000000001c36cc] .vfs_read+0xec/0x1f0
> [c000001eb3073d80] [c0000000001c38f8] .SyS_read+0x58/0xb0
> [c000001eb3073e30] [c000000000008564] syscall_exit+0x0/0x40
> INFO: task fio:49538 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> fio           D 00000080d6b76340     0 49538  49230 0x00008080

You'll want to report this to Red Hat, it's not a fio issue. It might
still be my issue, however, as it could be a bug in the block stack in
Linux... But please report it to RH first, it might be something they
are already aware of.

-- 
Jens Axboe

