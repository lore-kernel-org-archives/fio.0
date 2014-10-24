Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5449E0EF.7040402@kernel.dk>
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
 <53BE5286.2060203@kernel.dk> <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
 <53BEF29E.3040500@kernel.dk> <CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>
 <53BFCF22.8020407@kernel.dk> <CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com>
 <53C0F4EC.9010107@kernel.dk> <CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com>
 <53CCCA96.7010703@kernel.dk> <CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com>
 <53D20AA8.6020700@kernel.dk> <53D20DB8.10100@kernel.dk> <CAFTzLMPE+h_v8ydUP+iuCwJErQLuU=ZNcuKKcuxuZztandp+mQ@mail.gmail.com>
 <53D61053.9030902@kernel.dk> <CAFTzLMMP1tWNQ0tHj62enk-emhtX9sHv5wq+UCJpXO71RhB_NQ@mail.gmail.com>
 <53D6A95B.8020307@kernel.dk> <CAE56cDvVtc3kqw-BiEBwM2a34WB-csYMfR6TKjCtS9D=AUnJcw@mail.gmail.com>
 <54492656.5050805@kernel.dk> <CAE56cDtNaV6OodpXHmSJsYYj0U7CaQdW+ZBxhv-XPiNAwbU+2A@mail.gmail.com>
 <5449E0EF.7040402@kernel.dk>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Fri, 24 Oct 2014 08:33:13 -0700
Message-ID: <CAE56cDv+C8Bg4QZHg_88G-wzhFJkZk1AYG69f2Fjsvsf6MLDWA@mail.gmail.com>
Subject: Re: fio hangs with --status-interval
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Vasily Tarasov <tarasov@vasily.name>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hey,
This seems to be fixed now. I successfully finished 1500+ runs over
night in my rig without issues (it would have a hanging fio thread
about every other or second or so between eight clients).

The stumbling output issue on the second status interval thread I've
got still remain inconsistent.

Regards
Michael

On Thu, Oct 23, 2014 at 10:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-10-23 15:58, Michael Mattsson wrote:
>>
>> Hi,
>> I got some new traces of the stuck fio process.
>>
>> This is 2.1.13:
>> (gdb) bt
>> #0  0x00007f53cbb085bc in pthread_cond_wait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>> #1  0x0000000000430339 in fio_mutex_down (mutex=0x7f53c24ce000) at
>> mutex.c:155
>> #2  0x0000000000411950 in stat_exit () at stat.c:1905
>> #3  0x000000000044c756 in fio_backend () at backend.c:2094
>> #4  0x00007f53cb583d1d in __libc_start_main () from /lib64/libc.so.6
>> #5  0x0000000000409e49 in _start ()
>> (gdb)
>>
>> With fio-2.1.13-88-gb2ee7:
>> (gdb) bt
>> #0  0x00007f871e9de22d in pthread_join () from /lib64/libpthread.so.0
>> #1  0x0000000000411939 in wait_for_status_interval_thread_exit () at
>> stat.c:1939
>> #2  0x000000000044ce2a in fio_backend () at backend.c:2084
>> #3  0x00007f871e45cd1d in __libc_start_main () from /lib64/libc.so.6
>> #4  0x000000000040a529 in _start ()
>
>
> OK, I think I see what this is. Please update to current -git again and see
> if that doesn't fix up this issue.
>
> --
> Jens Axboe
>

