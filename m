Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53BEF29E.3040500@kernel.dk>
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
 <53BE5286.2060203@kernel.dk> <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
 <53BEF29E.3040500@kernel.dk>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Thu, 10 Jul 2014 14:27:47 -0700
Message-ID: <CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>
Subject: Re: fio hangs with --status-interval
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hey,
I don't get any kernel messages about stuck processes. echo t >
/proc/sysrq-trigger gives the following related to fio:

fio           S 0000000000000004     0  4189   3638 0x00000080
 ffff8817a0fd5bf8 0000000000000086 0000000000000000 ffffffff8111f867
 ffff8817a0fd5d01 00007fa2f43b6000 ffff8817a0fd5bd8 ffffffff810aec10
 ffff88186b867ab8 ffff8817a0fd5fd8 000000000000fbc8 ffff88186b867ab8
Call Trace:
 [<ffffffff8111f867>] ? unlock_page+0x27/0x30
 [<ffffffff810aec10>] ? get_futex_key+0x180/0x2b0
 [<ffffffff810ae559>] futex_wait_queue_me+0xb9/0xf0
 [<ffffffff810af668>] futex_wait+0x1f8/0x380
 [<ffffffff8100988e>] ? __switch_to+0x26e/0x320
 [<ffffffff810b0f31>] do_futex+0x121/0xb50
 [<ffffffff8109f491>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffff810a010f>] ? hrtimer_try_to_cancel+0x3f/0xd0
 [<ffffffff810a01c2>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff8152a413>] ? do_nanosleep+0x93/0xc0
 [<ffffffff810a0294>] ? hrtimer_nanosleep+0xc4/0x180
 [<ffffffff810b19db>] sys_futex+0x7b/0x170
 [<ffffffff810e1e87>] ? audit_syscall_entry+0x1d7/0x200
 [<ffffffff810e1c7e>] ? __audit_syscall_exit+0x25e/0x290
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
fio           S 0000000000000004     0  4191   3638 0x00000080
 ffff88186bccde68 0000000000000086 0000000000000000 ffffffff8109fdd3
 0000000000000004 0000000100000286 ffff88186bccde08 ffffffff8109f491
 ffff8818680c7af8 ffff88186bccdfd8 000000000000fbc8 ffff8818680c7af8
Call Trace:
 [<ffffffff8109fdd3>] ? __hrtimer_start_range_ns+0x1a3/0x460
 [<ffffffff8109f491>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffff8100bb8e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8152a40b>] do_nanosleep+0x8b/0xc0
 [<ffffffff810a0294>] hrtimer_nanosleep+0xc4/0x180
 [<ffffffff8109f0f0>] ? hrtimer_wakeup+0x0/0x30
 [<ffffffff810a00c4>] ? hrtimer_start_range_ns+0x14/0x20
 [<ffffffff810a03be>] sys_nanosleep+0x6e/0x80
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
fio           S 0000000000000002     0  4270   3638 0x00000080
 ffff88186a503bf8 0000000000000086 ffff88186a503b68 ffffffff8111f867
 ffff88186a503d01 00007fa2f39b2000 ffff88186a503bd8 ffffffff810aec10
 ffff88186a747058 ffff88186a503fd8 000000000000fbc8 ffff88186a747058
Call Trace:
 [<ffffffff8111f867>] ? unlock_page+0x27/0x30
 [<ffffffff810aec10>] ? get_futex_key+0x180/0x2b0
 [<ffffffff810ae559>] futex_wait_queue_me+0xb9/0xf0
 [<ffffffff810af668>] futex_wait+0x1f8/0x380
 [<ffffffff810b0f31>] do_futex+0x121/0xb50
 [<ffffffff810b19db>] sys_futex+0x7b/0x170
 [<ffffffff810e1e87>] ? audit_syscall_entry+0x1d7/0x200
 [<ffffffff810e1c7e>] ? __audit_syscall_exit+0x25e/0x290
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b

Above output is without the stat.patch, below is with the patch:

fio           S 0000000000000004     0  4189   3638 0x00000080
 ffff8817a0fd5bf8 0000000000000086 0000000000000000 ffffffff8111f867
 ffff8817a0fd5d01 00007fa2f43b6000 ffff8817a0fd5bd8 ffffffff810aec10
 ffff88186b867ab8 ffff8817a0fd5fd8 000000000000fbc8 ffff88186b867ab8
Call Trace:
 [<ffffffff8111f867>] ? unlock_page+0x27/0x30
 [<ffffffff810aec10>] ? get_futex_key+0x180/0x2b0
 [<ffffffff810ae559>] futex_wait_queue_me+0xb9/0xf0
 [<ffffffff810af668>] futex_wait+0x1f8/0x380
 [<ffffffff8100988e>] ? __switch_to+0x26e/0x320
 [<ffffffff810b0f31>] do_futex+0x121/0xb50
 [<ffffffff8109f491>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffff810a010f>] ? hrtimer_try_to_cancel+0x3f/0xd0
 [<ffffffff810a01c2>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff8152a413>] ? do_nanosleep+0x93/0xc0
 [<ffffffff810a0294>] ? hrtimer_nanosleep+0xc4/0x180
 [<ffffffff810b19db>] sys_futex+0x7b/0x170
 [<ffffffff810e1e87>] ? audit_syscall_entry+0x1d7/0x200
 [<ffffffff810e1c7e>] ? __audit_syscall_exit+0x25e/0x290
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
fio           S 0000000000000004     0  4191   3638 0x00000080
 ffff88186bccde68 0000000000000086 0000000000000000 ffffffff8109fdd3
 0000000000000004 0000000100000286 ffff88186bccde08 ffffffff8109f491
 ffff8818680c7af8 ffff88186bccdfd8 000000000000fbc8 ffff8818680c7af8
Call Trace:
 [<ffffffff8109fdd3>] ? __hrtimer_start_range_ns+0x1a3/0x460
 [<ffffffff8109f491>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffff8100bb8e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8152a40b>] do_nanosleep+0x8b/0xc0
 [<ffffffff810a0294>] hrtimer_nanosleep+0xc4/0x180
 [<ffffffff8109f0f0>] ? hrtimer_wakeup+0x0/0x30
 [<ffffffff810a00c4>] ? hrtimer_start_range_ns+0x14/0x20
 [<ffffffff810a03be>] sys_nanosleep+0x6e/0x80
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
fio           S 0000000000000002     0  4270   3638 0x00000080
 ffff88186a503bf8 0000000000000086 ffff88186a503b68 ffffffff8111f867
 ffff88186a503d01 00007fa2f39b2000 ffff88186a503bd8 ffffffff810aec10
 ffff88186a747058 ffff88186a503fd8 000000000000fbc8 ffff88186a747058
Call Trace:
 [<ffffffff8111f867>] ? unlock_page+0x27/0x30
 [<ffffffff810aec10>] ? get_futex_key+0x180/0x2b0
 [<ffffffff810ae559>] futex_wait_queue_me+0xb9/0xf0
 [<ffffffff810af668>] futex_wait+0x1f8/0x380
 [<ffffffff810b0f31>] do_futex+0x121/0xb50
 [<ffffffff810b19db>] sys_futex+0x7b/0x170
 [<ffffffff810e1e87>] ? audit_syscall_entry+0x1d7/0x200
 [<ffffffff810e1c7e>] ? __audit_syscall_exit+0x25e/0x290
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b


Thanks!
Michael

On Thu, Jul 10, 2014 at 1:07 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-10 16:55, Michael Mattsson wrote:
>>
>> Hey,
>> Thanks for the patch. I got log output but I had two clients hanging
>> in the same way with the attached patch.
>>
>> $ patch -p0 < stat.patch
>> patching file b/stat.c
>> patching file b/stat.h
>> Hunk #1 succeeded at 213 (offset -5 lines).
>>
>> I was using --output <filename>
>>
>> Worth mentioning here is that on the NFS server the output file is
>> written to is issuing a stat(1) on the above output file once per
>> second. Could it cause any prolems?
>
>
> OK, so next question. If you leave it long enough, do you get "stuck
> process" dumps from the kernel? In any case, a:
>
> # echo t > /proc/sysrq-trigger
>
> dump would be handy to see for all the fio processes, this doesn't smell
> like a fio issue.
>
> --
> Jens Axboe
>

