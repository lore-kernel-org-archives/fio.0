Return-Path: <rjevskiy@gmail.com>
Sender: Dmitry Monakhov <rjevskiy@gmail.com>
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] core: Actually EIO is a fatal error
In-Reply-To: <505C4EB1.4090800@kernel.dk>
References: <1348225456-21811-1-git-send-email-dmonakhov@openvz.org> <505C4EB1.4090800@kernel.dk>
Date: Fri, 21 Sep 2012 15:42:51 +0400
Message-ID: <87haqry538.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Fri, 21 Sep 2012 13:25:37 +0200, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/21/2012 01:04 PM, Dmitry Monakhov wrote:
> > As soon as i understand this is just a mistype.
> 
> It's not a typo. By that logic, EILSEQ is fatal too, since it is a
> verification failure of read data (so might as well have been an EIO).
> Fatal, in this context, means errors that fio can recover from and
> continue doing work.
Ohh i ment to say that both errors are fatal, but function called
td_NON_fatal_error, and it result true in case of EIO or EILSEQ
this result continue_on_error logic broken because 
io_u.c 1440:
       if (icd->error && td_non_fatal_error(icd->error) &&
           (td->o.continue_on_error & td_error_type(io_u->ddir,
           icd->error))) {
                         /*                                                                         
                 * If there is a non_fatal error, then add to the error
                 count              
                 * and clear all the errors.                                               
                 */
                update_error_count(td, icd->error);
                td_clear_error(td);
                icd->error = 0;
                io_u->error = 0;
           }
that's why i've inverted result.

FYI right after i've changed this my test which continuously hit ENOSPC
goes forward and provoke panic :)
WARNING: at lib/list_debug.c:62 __list_del_entry+0x1ee/0x250()
Hardware name:         
list_del corruption. next->prev should be ffff88022d5c1a30, but was
ffff880231f3e558
Modules linked in: ext4 jbd2 cpufreq_ondemand acpi_cpufreq freq_table
mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode
sg xhci_hcd ext3 jbd mbcache sd_mod crc_t10dif aesni_intel ablk_helper
cryptd aes_x86_64 aes_generic ahci libahci pata_acpi ata_generic
dm_mirror dm_region_hash dm_log dm_mod
Pid: 241, comm: kworker/u:3 Not tainted 3.6.0-rc1+ #62
Call Trace:
 [<ffffffff81074523>] warn_slowpath_common+0xc3/0xf0
 [<ffffffff81074606>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff8135eace>] __list_del_entry+0x1ee/0x250
 [<ffffffff8109d4de>] move_linked_works+0x4e/0xd0
 [<ffffffff810a0070>] cwq_activate_first_delayed+0xf0/0x120
 [<ffffffff810a0819>] ? process_one_work+0x619/0x770
 [<ffffffff810a0147>] cwq_dec_nr_in_flight+0xa7/0x160
 [<ffffffff810a0819>] ? process_one_work+0x619/0x770
 [<ffffffff810a08c9>] process_one_work+0x6c9/0x770
 [<ffffffff810a0541>] ? process_one_work+0x341/0x770
 [<ffffffffa03d0850>] ? put_io_page+0x60/0x60 [ext4]
 [<ffffffff810a171c>] worker_thread+0x1cc/0x330
 [<ffffffff810a1550>] ? manage_workers+0x140/0x140
 [<ffffffff810a9d39>] kthread+0xc9/0xe0
 [<ffffffff8175f6c4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81752f70>] ? retint_restore_args+0x13/0x13
 [<ffffffff810a9c70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8175f6c0>] ? gs_change+0x13/0x13
---[ end trace abc6d2e3c8581c4a ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:33 __list_add+0xdc/0x180()
Hardware name:         
list_add corruption. prev->next should be next (ffff880229a1e260), but
was ffff880231f3e558. (prev=ffff880231f3e558).
Modules linked in: ext4 jbd2 cpufreq_ondemand acpi_cpufreq freq_table
mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode
sg xhci_hcd ext3 jbd mbcache sd_mod crc_t10dif aesni_intel ablk_helper
cryptd aes_x86_64 aes_generic ahci libahci pata_acpi ata_generic
dm_mirror dm_region_hash dm_log dm_mod
Pid: 0, comm: swapper/3 Tainted: G        W    3.6.0-rc1+ #62
Call Trace:
 <IRQ>  [<ffffffff81074523>] warn_slowpath_common+0xc3/0xf0
 [<ffffffff81074606>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff8135de3e>] ? __spin_lock_debug+0xae/0x110
 [<ffffffff8135ec4c>] __list_add+0xdc/0x180
 [<ffffffff8109fa10>] insert_work+0x80/0xd0
 [<ffffffff810a2536>] __queue_work+0x4d6/0x5a0
 [<ffffffffa03d0a04>] ? ext4_add_complete_io+0x54/0xc0 [ext4]
 [<ffffffff810a2752>] queue_work_on+0x32/0x40
 [<ffffffff810a27b8>] queue_work+0x38/0x50
 [<ffffffffa03d0a34>] ext4_add_complete_io+0x84/0xc0 [ext4]
 [<ffffffff817527e5>] ? _raw_spin_unlock_irqrestore+0x65/0x90
 [<ffffffffa03c6c1d>] ext4_end_io_dio+0xdd/0xf0 [ext4]
 [<ffffffff81261e95>] dio_complete+0x125/0x1a0
 [<ffffffff81261fba>] dio_bio_end_aio+0xaa/0x100
 [<ffffffff81185da7>] ? mempool_free_slab+0x17/0x20
 [<ffffffff8125aba6>] bio_endio+0x76/0x80
 [<ffffffffa0002bd9>] dec_pending+0x279/0x340 [dm_mod]
 [<ffffffffa000360f>] clone_endio+0x12f/0x150 [dm_mod]
 [<ffffffff8125aba6>] bio_endio+0x76/0x80
 [<ffffffff812fe0cc>] req_bio_endio+0x15c/0x180
 [<ffffffff81301fa6>] blk_update_request+0x216/0x630
 [<ffffffff813023f5>] blk_update_bidi_request+0x35/0xf0
 [<ffffffff813024dc>] blk_end_bidi_request+0x2c/0x90
 [<ffffffff81302610>] blk_end_request+0x10/0x20
 [<ffffffff8148cc80>] scsi_end_request+0x40/0xf0
 [<ffffffff8148d0cc>] scsi_io_completion+0x32c/0x850
 [<ffffffff8147f32b>] scsi_finish_command+0x1bb/0x1e0
 [<ffffffff8148cb48>] scsi_softirq_done+0x158/0x1d0
 [<ffffffff8130d5ac>] blk_done_softirq+0x8c/0xa0
 [<ffffffff81080dfa>] __do_softirq+0x1ba/0x3e0
 [<ffffffff8175283b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff8175f7bc>] call_softirq+0x1c/0x30
 [<ffffffff810206c4>] do_softirq+0x94/0x1d0
 [<ffffffff8108136a>] irq_exit+0x7a/0x140
 [<ffffffff817600c5>] do_IRQ+0xd5/0x100
 [<ffffffff81752eaf>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff813a3bfc>] ? intel_idle+0x19c/0x1f0
 [<ffffffff813a3bf8>] ? intel_idle+0x198/0x1f0
 [<ffffffff815c75a9>] cpuidle_enter+0x19/0x20
 [<ffffffff815c7c47>] cpuidle_enter_state+0x17/0x60
 [<ffffffff815c7f3f>] cpuidle_idle_call+0x2af/0x4e0
 [<ffffffff8113f97a>] ? rcu_idle_enter+0x19a/0x1d0
 [<ffffffff8102b0ef>] cpu_idle+0xff/0x190
 [<ffffffff8102affd>] ? cpu_idle+0xd/0x190
 [<ffffffff81724beb>] start_secondary+0xcd/0xcf
---[ end trace abc6d2e3c8581c4b ]---
 
> 
> 
> -- 
> Jens Axboe
> 

