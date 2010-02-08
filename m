Return-Path: <cjiazhuang@yahoo.com>
Message-ID: <536591.84243.qm@web80808.mail.mud.yahoo.com>
References: <600237.15205.qm@web80807.mail.mud.yahoo.com> <20100208221033.GW1025@kernel.dk>
Date: Mon, 8 Feb 2010 14:47:56 -0800 (PST)
From: charles zhuang <cjiazhuang@yahoo.com>
Subject: Re: libaio ioengine cause initiator crash
In-Reply-To: <20100208221033.GW1025@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>> It's crashing in the kernel, so it should be reported as a kernel issue.

>> If you include the full oops in a reply, I can take a look.
Hi Jens,
Thanks for the quick response.  I have included a few crash (separate by ===== ), let me know if you can tell anything from it, or, need me to reproduce again. 
crash> log
....
sd 2:0:0:1: Attached scsi generic sg2 type 0
Unable to handle kernel paging request at ffffa3fb09d94000 RIP:
 [<ffffffff8000873a>] __handle_mm_fault+0xcf/0xe5c
PGD 0
Oops: 0000 [1] SMP
last sysfs file: /block/sdb/stat
CPU 0
Modules linked in: ib_iser(U) iscsi_tcp(U) libiscsi(U) scsi_transport_iscsi(U) autofs4 hidp rfcomm l2cap bluetooth lockd(U) sunrpc(U) rdma_ucm(U) qlgc_vnic(U) ib_sdp(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ipoib_helper(U) ib_cm(U) ib_sa(U) ipv6 xfrm_nalgo crypto_api ib_uverbs(U) ib_umad(U) iw_nes(U) iw_cxgb3(U) cxgb3(U) ib_ipath(U) mlx4_ib(U) ib_mthca(U) ib_mad(U) ib_core(U) dm_multipath scsi_dh video hwmon backlight sbs i2c_ec i2c_core button battery asus_acpi acpi_memhotplug ac parport_pc lp parport sg tg3 libphy mlx4_core(U) shpchp pcspkr serio_raw dm_raid45 dm_message dm_region_hash dm_mem_cache dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 8637, comm: fio Tainted: G      2.6.18-128.el5 #1
RIP: 0010:[<ffffffff8000873a>]  [<ffffffff8000873a>] __handle_mm_fault+0xcf/0xe5c
RSP: 0018:ffff810067ebbc18  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffa3fb09d94000 RCX: 0000000000000001
RDX: ffffa3fb09d94000 RSI: ffff810067b011e8 RDI: ffff81007df2e100
RBP: ffff810000000000 R08: 0000000000000000 R09: 0000000000000247
R10: ffff81007b103bc0 R11: 000000004b703a70 R12: 00003ffffffff000
R13: ffff810067ebbda8 R14: ffff810067b011e8 R15: ffff810066dbe040
FS:  00002b33483fd0f0(0000) GS:ffffffff803ac000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffa3fb09d94000 CR3: 00000000672e6000 CR4: 00000000000006e0
Process fio (pid: 8637, threadinfo ffff810067eba000, task ffff810066dbe040)
Stack:  ffff810067bbd0a8 0000000100000004 0000000018ef0600 ffff81007df2e100
 0000000000000400 00000000000085d4 0000000000800010 ffffffff8001bd3d
 ffff810066dbe230 0000000480034508 ffff810067eb8ce8 0000000000000007
Call Trace:
 [<ffffffff8001bd3d>] generic_make_request+0x1d2/0x1e9
 [<ffffffff80066b9a>] do_page_fault+0x4cb/0x830
 [<ffffffff800dd928>] bio_set_pages_dirty+0x23/0x38
 [<ffffffff8005be48>] blk_backing_dev_unplug+0x54/0x58
 [<ffffffff80089c4a>] dequeue_task+0x18/0x37
 [<ffffffff8005dde9>] error_exit+0x0/0x84
 [<ffffffff80061e03>] copy_user_generic+0x8f/0x16c
 [<ffffffff800ea594>] sys_io_getevents+0x32b/0x3b0
 [<ffffffff800e9a3b>] timeout_func+0x0/0x10
 [<ffffffff8008a461>] default_wake_function+0x0/0xe
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0


Code: 48 83 3b 00 75 1a 48 8b 54 24 10 48 8b 7c 24 18 48 89 de e8
RIP  [<ffffffff8000873a>] __handle_mm_fault+0xcf/0xe5c
 RSP <ffff810067ebbc18>

crash> bt
PID: 8637   TASK: ffff810066dbe040  CPU: 0   COMMAND: "fio"
 #0 [ffff810067ebb970] crash_kexec at ffffffff800aaa0c
 #1 [ffff810067ebba30] __die at ffffffff8006520f
 #2 [ffff810067ebba70] do_page_fault at ffffffff80066e1c
 #3 [ffff810067ebbb60] error_exit at ffffffff8005dde9
    [exception RIP: __handle_mm_fault+207]
    RIP: ffffffff8000873a  RSP: ffff810067ebbc18  RFLAGS: 00010286
    RAX: 0000000000000000  RBX: ffffa3fb09d94000  RCX: 0000000000000001
    RDX: ffffa3fb09d94000  RSI: ffff810067b011e8  RDI: ffff81007df2e100
    RBP: ffff810000000000   R8: 0000000000000000   R9: 0000000000000247
    R10: ffff81007b103bc0  R11: 000000004b703a70  R12: 00003ffffffff000
    R13: ffff810067ebbda8  R14: ffff810067b011e8  R15: ffff810066dbe040
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #4 [ffff810067ebbc50] generic_make_request at ffffffff8001bd3d
 #5 [ffff810067ebbcf0] bio_set_pages_dirty at ffffffff800dd928
 #6 [ffff810067ebbd10] blk_backing_dev_unplug at ffffffff8005be48
 #7 [ffff810067ebbda0] error_exit at ffffffff8005dde9
    [exception RIP: copy_user_generic+143]
    RIP: ffffffff80061e03  RSP: ffff810067ebbe58  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: 0000000000000008  RCX: 0000000000000004
    RDX: 0000000000000020  RSI: ffff810067ebbf18  RDI: 0000000018ef0600
    RBP: 0000000000000001   R8: 0000000000000000   R9: 0000000000000247
    R10: ffff81007b103bc0  R11: 000000004b703a70  R12: ffff810068253340
    R13: 0000000000000000  R14: 0000000000000001  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffff810067ebbe60] sys_io_getevents at ffffffff800ea594
 #9 [ffff810067ebbf80] tracesys at ffffffff8005d28d (via system_call)
    RIP: 00002b33481fb5b4  RSP: 00007fff628b9c10  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff8005d28d  RCX: ffffffffffffffff
    RDX: 0000000000000001  RSI: 0000000000000001  RDI: 00002b334c8df000
    RBP: 0000000000000001   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000018ef0600  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000001  R14: 0000000000000001  R15: 00007fff628b9c50
    ORIG_RAX: 00000000000000d0  CS: 0033  SS: 002b

==================================================================
crash> log
sd 2:0:0:1: Attached scsi disk sdb
sd 2:0:0:1: Attached scsi generic sg2 type 0
list_del corruption. prev->next should be ffff810061d24548, but was 29b63c9ee4946311
----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at lib/list_debug.c:65
invalid opcode: 0000 [1] SMP
last sysfs file: /block/sdb/stat
CPU 0
Modules linked in: ib_iser(U) iscsi_tcp(U) libiscsi(U) scsi_transport_iscsi(U) autofs4 hidp rfcomm l2cap bluetooth lockd(U) sunrpc(U) rdma_ucm(U) qlgc_vnic(U) ib_sdp(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ipoib_helper(U) ib_cm(U) ib_sa(U) ipv6 xfrm_nalgo crypto_api ib_uverbs(U) ib_umad(U) iw_nes(U) iw_cxgb3(U) cxgb3(U) ib_ipath(U) mlx4_ib(U) ib_mthca(U) ib_mad(U) ib_core(U) dm_multipath scsi_dh video hwmon backlight sbs i2c_ec i2c_core button battery asus_acpi acpi_memhotplug ac parport_pc lp parport sg pcspkr tg3 serio_raw mlx4_core(U) libphy shpchp dm_raid45 dm_message dm_region_hash dm_mem_cache dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 0, comm: swapper Tainted: G      2.6.18-128.el5 #1
RIP: 0010:[<ffffffff8014c5a3>]  [<ffffffff8014c5a3>] list_del+0x21/0x71
RSP: 0018:ffffffff80425d30  EFLAGS: 00010082
RAX: 0000000000000058 RBX: ffff810061d24548 RCX: ffffffff802f7aa8
RDX: ffffffff802f7aa8 RSI: 0000000000000000 RDI: ffffffff802f7aa0
RBP: ffff8100606cf200 R08: ffffffff802f7aa8 R09: 0000000000000046
R10: 0000000000000001 R11: ffffffff80161742 R12: ffff810061d24548
R13: 0000000000000800 R14: 0000000000000000 R15: 0000000000000213
FS:  0000000000000000(0000) GS:ffffffff803ac000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002afdc88d3000 CR3: 000000006230e000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffffffff803dc000, task ffffffff802eeae0)
Stack:  ffff810061d24480 ffffffff800e993e ffff810061d24480 ffff8100606cf200
 ffff8100606cf268 ffffffff800e9e24 0000000000000282 0000000000000000
 ffff8100624f0400 ffff8100624f071c 0000000000000246 0000000000000800
Call Trace:
 <IRQ>  [<ffffffff800e993e>] __aio_put_req+0x4a/0x117
 [<ffffffff800e9e24>] aio_complete+0x18c/0x1c8
 [<ffffffff800ee095>] dio_bio_end_aio+0x9f/0xbf
 [<ffffffff8002ca64>] __end_that_request_first+0x265/0x5df
 [<ffffffff88079fb4>] :scsi_mod:scsi_end_request+0x27/0xcd
 [<ffffffff8807a1a8>] :scsi_mod:scsi_io_completion+0x14e/0x324
 [<ffffffff880a67cd>] :sd_mod:sd_rw_intr+0x21d/0x257
 [<ffffffff8807a43d>] :scsi_mod:scsi_device_unbusy+0x67/0x81
 [<ffffffff800376ff>] blk_done_softirq+0x5f/0x6d
 [<ffffffff80011fbc>] __do_softirq+0x89/0x133
 [<ffffffff8005e2fc>] call_softirq+0x1c/0x28
 [<ffffffff8006cada>] do_softirq+0x2c/0x85
 [<ffffffff8006c962>] do_IRQ+0xec/0xf5
 [<ffffffff80056be3>] mwait_idle+0x0/0x4a
 [<ffffffff8005d615>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80056c19>] mwait_idle+0x36/0x4a
 [<ffffffff80048d19>] cpu_idle+0x95/0xb8
 [<ffffffff803e7801>] start_kernel+0x220/0x225
 [<ffffffff803e722f>] _sinittext+0x22f/0x236


Code: 0f 0b 68 3e 62 2a 80 c2 41 00 48 8b 03 48 8b 50 08 48 39 da
RIP  [<ffffffff8014c5a3>] list_del+0x21/0x71
 RSP <ffffffff80425d30>

crash> bt
PID: 0      TASK: ffffffff802eeae0  CPU: 0   COMMAND: "swapper"
 #0 [ffffffff80425a90] crash_kexec at ffffffff800aaa0c
 #1 [ffffffff80425b50] __die at ffffffff8006520f
 #2 [ffffffff80425b90] die at ffffffff8006bc17
 #3 [ffffffff80425bc0] do_invalid_op at ffffffff8006c1d7
 #4 [ffffffff80425c80] error_exit at ffffffff8005dde9
    [exception RIP: list_del+33]
    RIP: ffffffff8014c5a3  RSP: ffffffff80425d30  RFLAGS: 00010082
    RAX: 0000000000000058  RBX: ffff810061d24548  RCX: ffffffff802f7aa8
    RDX: ffffffff802f7aa8  RSI: 0000000000000000  RDI: ffffffff802f7aa0
    RBP: ffff8100606cf200   R8: ffffffff802f7aa8   R9: 0000000000000046
    R10: 0000000000000001  R11: ffffffff80161742  R12: ffff810061d24548
    R13: 0000000000000800  R14: 0000000000000000  R15: 0000000000000213
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #5 [ffffffff80425d38] __aio_put_req at ffffffff800e993e
 #6 [ffffffff80425d58] aio_complete at ffffffff800e9e24
 #7 [ffffffff80425d98] dio_bio_end_aio at ffffffff800ee095
 #8 [ffffffff80425dc8] __end_that_request_first at ffffffff8002ca64
 #9 [ffffffff80425e58] scsi_io_completion at ffffffff8807a1a8
#10 [ffffffff80425eb8] sd_rw_intr at ffffffff880a67cd
#11 [ffffffff80425f18] blk_done_softirq at ffffffff800376ff
#12 [ffffffff80425f38] __do_softirq at ffffffff80011fbc
#13 [ffffffff80425f68] call_softirq at ffffffff8005e2fc
#14 [ffffffff80425f80] do_softirq at ffffffff8006cada
#15 [ffffffff80425f90] do_IRQ at ffffffff8006c962
--- <IRQ stack> ---
#16 [ffffffff803ddee8] ret_from_intr at ffffffff8005d615
    [exception RIP: mwait_idle+54]
    RIP: ffffffff80056c19  RSP: ffffffff803ddf90  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: 0000000000090000  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff802f0658
    RBP: ffffffff802eecd0   R8: ffffffff803dc000   R9: 000000000000003f
    R10: ffff81005e5ed0c0  R11: 0000000000000050  R12: 00000000005f44fb
    R13: 0000008ef40d85b4  R14: ffff810037fd9080  R15: ffffffff802eeae0
    ORIG_RAX: ffffffffffffffbd  CS: 0010  SS: 0018
#17 [ffffffff803ddf90] cpu_idle at ffffffff80048d19
=====================================================
crash> log
sd 2:0:0:1: Attached scsi generic sg2 type 0
stack segment: 0000 [1] SMP
last sysfs file: /block/sdb/stat
CPU 0
Modules linked in: ib_iser(U) iscsi_tcp(U) libiscsi(U) scsi_transport_iscsi(U) autofs4 hidp rfcomm l2cap bluetooth lockd(U) sunrpc(U) rdma_ucm(U) qlgc_vnic(U) ib_sdp(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ipoib_helper(U) ib_cm(U) ib_sa(U) ipv6 xfrm_nalgo crypto_api ib_uverbs(U) ib_umad(U) iw_nes(U) iw_cxgb3(U) cxgb3(U) ib_ipath(U) mlx4_ib(U) ib_mthca(U) ib_mad(U) ib_core(U) dm_multipath scsi_dh video hwmon backlight sbs i2c_ec i2c_core button battery asus_acpi acpi_memhotplug ac parport_pc lp parport sg mlx4_core(U) serio_raw pcspkr tg3 shpchp libphy dm_raid45 dm_message dm_region_hash dm_mem_cache dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 0, comm: swapper Tainted: G      2.6.18-128.el5 #1
RIP: 0010:[<ffffffff886940fe>]  [<ffffffff886940fe>] :ib_iser:iser_snd_completion+0x1d/0xf7
RSP: 0018:ffffffff80425e90  EFLAGS: 00010297
RAX: 0000000000000000 RBX: ffff810068092440 RCX: 0000000000000000
RDX: 00000000a03c0000 RSI: 0000000000000286 RDI: ffff810068092340
RBP: 60c6a2c052d4011f R08: ffffffff803dc000 R09: 0000000000000000
R10: 0000000000000042 R11: 0000000000000000 R12: ffff810068092340
R13: 000000000000000a R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff803ac000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002ada14c6e000 CR3: 0000000068ae5000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffffffff803dc000, task ffffffff802eeae0)
Stack:  ffff81006b97f860 ffff810068092340 ffff81006e9a0800 000000000000000a
 0000000000000000 ffffffff886934f2 ffff810068092340 0000008000000000
 0000004c7c078780 ffff81006b850600 0000000000000000 0002000000000000
Call Trace:
 <IRQ>  [<ffffffff886934f2>] :ib_iser:iser_cq_tasklet_fn+0x4e/0x14f
 [<ffffffff800923c3>] tasklet_action+0x89/0xfd
 [<ffffffff80011fbc>] __do_softirq+0x89/0x133
 [<ffffffff8005e2fc>] call_softirq+0x1c/0x28
 [<ffffffff8006cada>] do_softirq+0x2c/0x85
 [<ffffffff8006c962>] do_IRQ+0xec/0xf5
 [<ffffffff80056be3>] mwait_idle+0x0/0x4a
 [<ffffffff8005d615>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80056c19>] mwait_idle+0x36/0x4a
 [<ffffffff80048d19>] cpu_idle+0x95/0xb8
 [<ffffffff803e7801>] start_kernel+0x220/0x225
 [<ffffffff803e722f>] _sinittext+0x22f/0x236


Code: 4c 8b 75 00 4d 8b 2e 7e 18 48 89 da 48 c7 c6 a0 63 69 88 48
RIP  [<ffffffff886940fe>] :ib_iser:iser_snd_completion+0x1d/0xf7
 RSP <ffffffff80425e90>

crash> bt
PID: 0      TASK: ffffffff802eeae0  CPU: 0   COMMAND: "swapper"
 #0 [ffffffff80426de0] crash_kexec at ffffffff800aaa0c
 #1 [ffffffff80426ea0] __die at ffffffff8006520f
 #2 [ffffffff80426ee0] die at ffffffff8006bc17
 #3 [ffffffff80426f10] do_stack_segment at ffffffff8006c564
 #4 [ffffffff80426f50] stack_segment at ffffffff8005e221
    [exception RIP: iser_snd_completion+29]
    RIP: ffffffff886940fe  RSP: ffffffff80425e90  RFLAGS: 00010297
    RAX: 0000000000000000  RBX: ffff810068092440  RCX: 0000000000000000
    RDX: 00000000a03c0000  RSI: 0000000000000286  RDI: ffff810068092340
    RBP: 60c6a2c052d4011f   R8: ffffffff803dc000   R9: 0000000000000000
    R10: 0000000000000042  R11: 0000000000000000  R12: ffff810068092340
    R13: 000000000000000a  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #5 [ffffffff80425e90] iser_snd_completion at ffffffff886940fe
 #6 [ffffffff80425eb8] iser_cq_tasklet_fn at ffffffff886934f2
 #7 [ffffffff80425f18] tasklet_action at ffffffff800923c3
 #8 [ffffffff80425f38] __do_softirq at ffffffff80011fbc
 #9 [ffffffff80425f68] call_softirq at ffffffff8005e2fc
#10 [ffffffff80425f80] do_softirq at ffffffff8006cada
#11 [ffffffff80425f90] do_IRQ at ffffffff8006c962
--- <IRQ stack> ---
#12 [ffffffff803ddee8] ret_from_intr at ffffffff8005d615
    [exception RIP: mwait_idle+54]
    RIP: ffffffff80056c19  RSP: ffffffff803ddf90  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: 0000000000090000  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff802f0658
    RBP: ffffffff802eecd0   R8: ffffffff803dc000   R9: 000000000000003f
    R10: ffff81006a3ef1c0  R11: ffff810068b03ee8  R12: 00000000000384db
    R13: 00000102e7100b0e  R14: ffff810037fd9080  R15: ffffffff802eeae0
    ORIG_RAX: ffffffffffffffbd  CS: 0010  SS: 0018
#13 [ffffffff803ddf90] cpu_idle at ffffffff80048d19

===========================================================
crash> log
sd 4:0:0:1: Attached scsi disk sdb
sd 4:0:0:1: Attached scsi generic sg3 type 0
NMI Watchdog detected LOCKUP on CPU 2
CPU 2
Modules linked in: ib_iser(U) iscsi_tcp(U) libiscsi(U) scsi_transport_iscsi(U) autofs4 hidp rfcomm l2cap bluetooth lockd(U) sunrpc(U) cpufreq_ondemand acpi_cpufreq freq_table rdma_ucm(U) qlgc_vnic(U) ib_sdp(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ipoib_helper(U) ib_cm(U) ib_sa(U) ipv6 xfrm_nalgo crypto_api ib_uverbs(U) ib_umad(U) iw_nes(U) iw_cxgb3(U) cxgb3(U) ib_ipath(U) mlx4_ib(U) ib_mthca(U) ib_mad(U) ib_core(U) dm_multipath scsi_dh video hwmon backlight sbs i2c_ec button battery asus_acpi acpi_memhotplug ac parport_pc lp parport snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device sr_mod snd_pcm_oss cdrom snd_mixer_oss fio_driver(PU) shpchp snd_pcm i2c_i801 pcspkr sg snd_timer snd_page_alloc snd_hwdep snd serio_raw i2c_core e1000e soundcore fio_port(PU) mlx4_core(U) dm_raid45 dm_message dm_region_hash dm_mem_cache dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd
 ehci_hcd
Pid: 0, comm: swapper Tainted: P      2.6.18-128.el5 #1
RIP: 0010:[<ffffffff80064cc0>]  [<ffffffff80064cc0>] .text.lock.spinlock+0xe/0x30
RSP: 0018:ffff810104787d98  EFLAGS: 00000086
RAX: 0000000000000246 RBX: 0000000000000000 RCX: ffff8101093c3340
RDX: 0000000000000063 RSI: ffff8101093c3340 RDI: ffff81010915b71c
RBP: ffff81010915b400 R08: 0000000000000286 R09: ffff81010a577800
R10: ffff810110523800 R11: ffffffff800449ab R12: ffff81010915b71c
R13: ffff810108283708 R14: 0000000000000800 R15: 0000000000001800
FS:  0000000000000000(0000) GS:ffff81010475fe40(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000040e000 CR3: 00000001079d0000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffff810104780000, task ffff810104760080)
Stack:  ffffffff800ee02d ffff8101080e235c 0000000000000000 ffff8101093c3340
 ffff8101388ff340 ffff810108283708 ffffffff8002ca64 ffff8101388ff340
 0000000000000001 0000000000000000 0000000000000286 0000000000000001
Call Trace:
 <IRQ>  [<ffffffff800ee02d>] dio_bio_end_aio+0x37/0xbf
 [<ffffffff8002ca64>] __end_that_request_first+0x265/0x5df
 [<ffffffff88079fb4>] :scsi_mod:scsi_end_request+0x27/0xcd
 [<ffffffff8807a1a8>] :scsi_mod:scsi_io_completion+0x14e/0x324
 [<ffffffff880a67cd>] :sd_mod:sd_rw_intr+0x21d/0x257
 [<ffffffff8807a43d>] :scsi_mod:scsi_device_unbusy+0x67/0x81
 [<ffffffff800376ff>] blk_done_softirq+0x5f/0x6d
 [<ffffffff80011fbc>] __do_softirq+0x89/0x133
 [<ffffffff8005e2fc>] call_softirq+0x1c/0x28
 [<ffffffff8006cada>] do_softirq+0x2c/0x85
 [<ffffffff8006c962>] do_IRQ+0xec/0xf5
 [<ffffffff8005d615>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8018d192>] acpi_processor_idle+0x275/0x43a
 [<ffffffff8018d188>] acpi_processor_idle+0x26b/0x43a
 [<ffffffff8018cf1d>] acpi_processor_idle+0x0/0x43a
 [<ffffffff8018cf1d>] acpi_processor_idle+0x0/0x43a
 [<ffffffff80048d19>] cpu_idle+0x95/0xb8
 [<ffffffff80076be6>] start_secondary+0x45a/0x469


Code: 83 3f 00 7e f9 e9 f9 fe ff ff f3 90 83 3f 00 7e f9 e9 f8 fe
BUG: warning at arch/x86_64/kernel/crash.c:148/nmi_shootdown_cpus() (Tainted: P     )

Call Trace:
 <NMI>  [<ffffffff80079d56>] machine_crash_shutdown+0xaa/0xf3
 [<ffffffff800aaa00>] crash_kexec+0xcc/0xe8
 [<ffffffff800449ab>] mempool_free_slab+0x0/0xe
 [<ffffffff80064cc0>] .text.lock.spinlock+0xe/0x30
 [<ffffffff8006535d>] die_nmi+0x46/0xa3
 [<ffffffff80065ac3>] nmi_watchdog_tick+0x157/0x1d3
 [<ffffffff800656e1>] default_do_nmi+0x81/0x225
 [<ffffffff8006594e>] do_nmi+0x43/0x61
 [<ffffffff80064fa7>] nmi+0x7f/0x88
 [<ffffffff800449ab>] mempool_free_slab+0x0/0xe
 [<ffffffff80064cc0>] .text.lock.spinlock+0xe/0x30
 <<EOE>>  <IRQ>  [<ffffffff800ee02d>] dio_bio_end_aio+0x37/0xbf
 [<ffffffff8002ca64>] __end_that_request_first+0x265/0x5df
 [<ffffffff88079fb4>] :scsi_mod:scsi_end_request+0x27/0xcd
 [<ffffffff8807a1a8>] :scsi_mod:scsi_io_completion+0x14e/0x324
 [<ffffffff880a67cd>] :sd_mod:sd_rw_intr+0x21d/0x257
 [<ffffffff8807a43d>] :scsi_mod:scsi_device_unbusy+0x67/0x81
 [<ffffffff800376ff>] blk_done_softirq+0x5f/0x6d
 [<ffffffff80011fbc>] __do_softirq+0x89/0x133
 [<ffffffff8005e2fc>] call_softirq+0x1c/0x28
 [<ffffffff8006cada>] do_softirq+0x2c/0x85
 [<ffffffff8006c962>] do_IRQ+0xec/0xf5
 [<ffffffff8005d615>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8018d192>] acpi_processor_idle+0x275/0x43a
 [<ffffffff8018d188>] acpi_processor_idle+0x26b/0x43a
 [<ffffffff8018cf1d>] acpi_processor_idle+0x0/0x43a
 [<ffffffff8018cf1d>] acpi_processor_idle+0x0/0x43a
 [<ffffffff80048d19>] cpu_idle+0x95/0xb8
 [<ffffffff80076be6>] start_secondary+0x45a/0x469

crash> bt
PID: 0      TASK: ffff810104760080  CPU: 2   COMMAND: "swapper"
 #0 [ffff810104788dc0] crash_kexec at ffffffff800aaa0c
 #1 [ffff810104788e80] die_nmi at ffffffff8006535d
 #2 [ffff810104788ea0] nmi_watchdog_tick at ffffffff80065ac3
 #3 [ffff810104788ef0] default_do_nmi at ffffffff800656e1
 #4 [ffff810104788f40] do_nmi at ffffffff8006594e
 #5 [ffff810104788f50] nmi at ffffffff80064fa7
    [exception RIP: .text.lock.spinlock+14]
    RIP: ffffffff80064cc0  RSP: ffff810104787d98  RFLAGS: 00000086
    RAX: 0000000000000246  RBX: 0000000000000000  RCX: ffff8101093c3340
    RDX: 0000000000000063  RSI: ffff8101093c3340  RDI: ffff81010915b71c
    RBP: ffff81010915b400   R8: 0000000000000286   R9: ffff81010a577800
    R10: ffff810110523800  R11: ffffffff800449ab  R12: ffff81010915b71c
    R13: ffff810108283708  R14: 0000000000000800  R15: 0000000000001800
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #6 [ffff810104787d98] .text.lock.spinlock at ffffffff80064cc0 (via _spin_lock_irqsave)
 #7 [ffff810104787d98] dio_bio_end_aio at ffffffff800ee02d
 #8 [ffff810104787dc8] __end_that_request_first at ffffffff8002ca64
 #9 [ffff810104787e58] scsi_io_completion at ffffffff8807a1a8
#10 [ffff810104787eb8] sd_rw_intr at ffffffff880a67cd
#11 [ffff810104787f18] blk_done_softirq at ffffffff800376ff
#12 [ffff810104787f38] __do_softirq at ffffffff80011fbc
#13 [ffff810104787f68] call_softirq at ffffffff8005e2fc
#14 [ffff810104787f80] do_softirq at ffffffff8006cada
#15 [ffff810104787f90] do_IRQ at ffffffff8006c962
--- <IRQ stack> ---
#16 [ffff810104781df8] ret_from_intr at ffffffff8005d615
    [exception RIP: acpi_processor_idle+629]
    RIP: ffffffff8018d192  RSP: ffff810104781ea8  RFLAGS: 00000282
    RAX: ffff810104781fd8  RBX: ffff81013baf5960  RCX: 0000000000000003
    RDX: ffff81013baf5800  RSI: 0000000000000082  RDI: ffffffff8049fd6c
    RBP: ffff810104781ee8   R8: ffff810104780000   R9: ffff810104781ecc
    R10: 0000000000000046  R11: ffff810104781ee8  R12: ffff810107cb9880
    R13: 0000000010008040  R14: ffff810107cb9880  R15: ffff810107cb9880
    ORIG_RAX: ffffffffffffff85  CS: 0010  SS: 0018
#17 [ffff810104781ea0] acpi_processor_idle at ffffffff8018d188
#18 [ffff810104781ef0] cpu_idle at ffffffff80048d19

=============================================================
crash> log
sd 4:0:0:1: Attached scsi disk sdb
sd 4:0:0:1: Attached scsi generic sg3 type 0
__end_that: dev sdb: flags = REQ_SORTED REQ_CMD REQ_STARTED REQ_DONTPREP REQ_ELVPRIV
sector 756, nr/cnr 4/4
bio ffff8101095435c0, biotail ffff8101095435c0, buffer 0000000000000000, data 0000000000000000, len 0
__end_that_request_first: bio idx 57565 >= vcnt 3573
general protection fault: 0000 [1] SMP
last sysfs file: /block/sdb/stat
CPU 2
Modules linked in: ib_iser(U) iscsi_tcp(U) libiscsi(U) scsi_transport_iscsi(U) autofs4 hidp rfcomm l2cap bluetooth lockd(U) sunrpc(U) cpufreq_ondemand acpi_cpufreq freq_table rdma_ucm(U) qlgc_vnic(U) ib_sdp(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ipoib_helper(U) ib_cm(U) ib_sa(U) ipv6 xfrm_nalgo crypto_api ib_uverbs(U) ib_umad(U) iw_nes(U) iw_cxgb3(U) cxgb3(U) ib_ipath(U) mlx4_ib(U) ib_mthca(U) ib_mad(U) ib_core(U) dm_multipath scsi_dh video hwmon backlight sbs i2c_ec button battery asus_acpi acpi_memhotplug ac parport_pc lp parport snd_hda_intel snd_seq_dummy snd_seq_oss fio_driver(PU) snd_seq_midi_event snd_seq fio_port(PU) snd_seq_device sr_mod snd_pcm_oss i2c_i801 e1000e cdrom snd_mixer_oss i2c_core shpchp snd_pcm serio_raw pcspkr snd_timer snd_page_alloc snd_hwdep snd soundcore mlx4_core(U) sg dm_raid45 dm_message dm_region_hash dm_mem_cache dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd
 ehci_hcd
Pid: 3695, comm: fio Tainted: P      2.6.18-128.el5 #1
RIP: 0010:[<ffffffff8002cc0e>]  [<ffffffff8002cc0e>] __end_that_request_first+0x40f/0x5df
RSP: 0018:ffff810104787dd0  EFLAGS: 00010202
RAX: 00000000000e0dd0 RBX: 0000000000000000 RCX: a0a6be50cb5fe143
RDX: ffff8101095435c0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8101095435c0 R08: ffffffff802f7aa8 R09: 0000000000000046
R10: ffff810104787a70 R11: 0000000000000080 R12: ffff81010892d968
R13: ffff810107c87e78 R14: 0000000000000000 R15: 0000000000000800
FS:  00002b7ea90760f0(0000) GS:ffff81010475fe40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000040e000 CR3: 0000000106eff000 CR4: 00000000000006e0
Process fio (pid: 3695, threadinfo ffff810106c98000, task ffff8101381ac7a0)
Stack:  ffff81010892d968 0000000000000001 0000000000000000 ffffffff8005bd48
 0000000000000001 ffff810107c87e78 ffff81011e9663c0 ffff81010892d968
 0000000000000001 0000000000000001 0000000000000000 ffffffff88079fb4
Call Trace:
 <IRQ>  [<ffffffff8005bd48>] blk_run_queue+0x41/0x72
 [<ffffffff88079fb4>] :scsi_mod:scsi_end_request+0x27/0xcd
 [<ffffffff8807a1a8>] :scsi_mod:scsi_io_completion+0x14e/0x324
 [<ffffffff880a67cd>] :sd_mod:sd_rw_intr+0x21d/0x257
 [<ffffffff8807a43d>] :scsi_mod:scsi_device_unbusy+0x67/0x81
 [<ffffffff800376ff>] blk_done_softirq+0x5f/0x6d
 [<ffffffff80011fbc>] __do_softirq+0x89/0x133
 [<ffffffff8005e2fc>] call_softirq+0x1c/0x28
 [<ffffffff8006cada>] do_softirq+0x2c/0x85
 [<ffffffff8006c962>] do_IRQ+0xec/0xf5
 [<ffffffff8005d615>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff800e95a7>] aio_pread+0x0/0x9b
 [<ffffffff800e9ef3>] aio_run_iocb+0x93/0x18a
 [<ffffffff80126d43>] selinux_file_permission+0x9f/0xb6
 [<ffffffff800eaa84>] io_submit_one+0x29d/0x2ea
 [<ffffffff800eafc3>] sys_io_submit+0x9b/0x108
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0


Code: 8b 44 08 08 c1 e8 09 41 89 45 50 41 89 45 38 0f b7 72 2a 48
RIP  [<ffffffff8002cc0e>] __end_that_request_first+0x40f/0x5df
 RSP <ffff810104787dd0>

crash> bt
PID: 3695   TASK: ffff8101381ac7a0  CPU: 2   COMMAND: "fio"
 #0 [ffff810104787bb0] crash_kexec at ffffffff800aaa0c
 #1 [ffff810104787c70] __die at ffffffff8006520f
 #2 [ffff810104787cb0] die at ffffffff8006bc17
 #3 [ffff810104787ce0] do_general_protection at ffffffff80065657
 #4 [ffff810104787d20] error_exit at ffffffff8005dde9
    [exception RIP: __end_that_request_first+1039]
    RIP: ffffffff8002cc0e  RSP: ffff810104787dd0  RFLAGS: 00010202
    RAX: 00000000000e0dd0  RBX: 0000000000000000  RCX: a0a6be50cb5fe143
    RDX: ffff8101095435c0  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff8101095435c0   R8: ffffffff802f7aa8   R9: 0000000000000046
    R10: ffff810104787a70  R11: 0000000000000080  R12: ffff81010892d968
    R13: ffff810107c87e78  R14: 0000000000000000  R15: 0000000000000800
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #5 [ffff810104787de8] blk_run_queue at ffffffff8005bd48
 #6 [ffff810104787e28] scsi_end_request at ffffffff88079fb4
 #7 [ffff810104787e58] scsi_io_completion at ffffffff8807a1a8
 #8 [ffff810104787eb8] sd_rw_intr at ffffffff880a67cd
 #9 [ffff810104787f18] blk_done_softirq at ffffffff800376ff
#10 [ffff810104787f38] __do_softirq at ffffffff80011fbc
#11 [ffff810104787f68] call_softirq at ffffffff8005e2fc
#12 [ffff810104787f80] do_softirq at ffffffff8006cada
#13 [ffff810104787f90] do_IRQ at ffffffff8006c962
--- <IRQ stack> ---
#14 [ffff810106c99df8] ret_from_intr at ffffffff8005d615
    [exception RIP: aio_run_iocb+147]
    RIP: ffffffff800e9ef3  RSP: ffff810106c99ea8  RFLAGS: 00000282
    RAX: 0000000000000000  RBX: ffff810107c45bf8  RCX: ffffffff800e95a7
    RDX: 0000000000000000  RSI: 0000000000000004  RDI: ffff8101095bcbc0
    RBP: 0000000000000001   R8: ffff810106c99d28   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000048  R12: ffff81010b602118
    R13: ffff8101381ac7a0  R14: ffffffff80124525  R15: ffff810106510ec0
    ORIG_RAX: ffffffffffffff85  CS: 0010  SS: 0018
#15 [ffff810106c99ea0] selinux_file_permission at ffffffff80126d43
#16 [ffff810106c99ec0] io_submit_one at ffffffff800eaa84
#17 [ffff810106c99ef0] sys_io_submit at ffffffff800eafc3
#18 [ffff810106c99f80] tracesys at ffffffff8005d28d (via system_call)
    RIP: 00002b7ea8e74607  RSP: 00007fff01c473d8  RFLAGS: 00000202
    RAX: ffffffffffffffda  RBX: ffffffff8005d28d  RCX: ffffffffffffffff
    RDX: 0000000015bb0e10  RSI: 0000000000000001  RDI: 00002b7ead554000
    RBP: 0000000015bab980   R8: 0000000012c75a91   R9: 00000000001a81fc
    R10: 000000004b704f43  R11: 0000000000000202  R12: 0000000015bb1020
    R13: 0000000000000000  R14: 00002b7ead1ddb00  R15: 00007fff01c47430
    ORIG_RAX: 00000000000000d1  CS: 0033  SS: 002b

==================================================================



-- 
Jens Axboe


      

