Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53BFCF22.8020407@kernel.dk>
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
 <53BE5286.2060203@kernel.dk> <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
 <53BEF29E.3040500@kernel.dk> <CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>
 <53BFCF22.8020407@kernel.dk>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Fri, 11 Jul 2014 09:19:36 -0700
Message-ID: <CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com>
Subject: Re: fio hangs with --status-interval
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hey,
This system will be busy over the weekend with other work, I'll get
this to you at the next window or try reproduce it on a different
system. Do you want the trace with or without the patch you sent?

Thanks!
Michael

On Fri, Jul 11, 2014 at 4:48 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-10 23:27, Michael Mattsson wrote:
>>
>> Hey,
>> I don't get any kernel messages about stuck processes. echo t >
>> /proc/sysrq-trigger gives the following related to fio:
>>
>> fio           S 0000000000000004     0  4189   3638 0x00000080
>>   ffff8817a0fd5bf8 0000000000000086 0000000000000000 ffffffff8111f867
>>   ffff8817a0fd5d01 00007fa2f43b6000 ffff8817a0fd5bd8 ffffffff810aec10
>>   ffff88186b867ab8 ffff8817a0fd5fd8 000000000000fbc8 ffff88186b867ab8
>> Call Trace:
>>   [<ffffffff8111f867>] ? unlock_page+0x27/0x30
>>   [<ffffffff810aec10>] ? get_futex_key+0x180/0x2b0
>>   [<ffffffff810ae559>] futex_wait_queue_me+0xb9/0xf0
>>   [<ffffffff810af668>] futex_wait+0x1f8/0x380
>>   [<ffffffff8100988e>] ? __switch_to+0x26e/0x320
>>   [<ffffffff810b0f31>] do_futex+0x121/0xb50
>>   [<ffffffff8109f491>] ? lock_hrtimer_base+0x31/0x60
>>   [<ffffffff810a010f>] ? hrtimer_try_to_cancel+0x3f/0xd0
>>   [<ffffffff810a01c2>] ? hrtimer_cancel+0x22/0x30
>>   [<ffffffff8152a413>] ? do_nanosleep+0x93/0xc0
>>   [<ffffffff810a0294>] ? hrtimer_nanosleep+0xc4/0x180
>>   [<ffffffff810b19db>] sys_futex+0x7b/0x170
>>   [<ffffffff810e1e87>] ? audit_syscall_entry+0x1d7/0x200
>>   [<ffffffff810e1c7e>] ? __audit_syscall_exit+0x25e/0x290
>>   [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
>
>
> OK, so nothing unexpected there. But it's all still very weird. Could you
> try and attach gdb to a fio process that is stuck like this, and generate
> 'bt' backtraces?
>
> --
> Jens Axboe
>

