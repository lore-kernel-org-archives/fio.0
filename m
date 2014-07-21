Return-Path: <gwendal@google.com>
MIME-Version: 1.0
Sender: gwendal@google.com
In-Reply-To: <53CCCF60.9090208@kernel.dk>
References: <CAMHSBOXb0f9iZFLiJSXPiT+8yXe8QbF-bS_4KA1c1+=Wps_K_A@mail.gmail.com>
 <53C8D124.60202@kernel.dk> <53CCCF60.9090208@kernel.dk>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Mon, 21 Jul 2014 10:49:36 -0700
Message-ID: <CAMHSBOW1g2y9nCMQs=qJ-ggWZEG_MiG27BgpttPFsk1tdUQy5g@mail.gmail.com>
Subject: Re: [fio-2.1.9] verify and bssplit do not work together
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens,

Without the patch, experimental_verify=1 produced more error, it looks
like every 64k.

With the patch above, fio behaves as expected: do_verify and
experimental_verify works for mixed writes.

There is still a problem when bs is mixed and one argument is less
than the verify interval.
For instance:
bssplit=4k/50:1M/50
...
verify_interval=64k


But looking at the code, it won't be possible to fix, because we can
not guarantee to always have 16 4K write contiguous.

Thanks for the patch.

Gwendal.

On Mon, Jul 21, 2014 at 1:29 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-18 09:47, Jens Axboe wrote:
>>
>> On 2014-07-17 22:36, Gwendal Grignou wrote:
>>>
>>> Jens,
>>>
>>> I notice that when I enable bssplit and verify, verify always fails:
>>>
>>> ...
>>> meta: verify failed at file /tmp/test offset 7143424, length 65536
>>> open verify buf file: Read-only file system
>>> ....
>>> In my tests, the offsets that fails are always:
>>> 7143424, 15073280, 2647654, 450397184, 88080384, 88211456
>>>
>>> it does not happen when I set a fixed size with bs, or when I do not
>>> verify.
>>>
>>> Here is the fio control file I use:
>>>
>>> [stress]
>>> filename=/tmp/test
>>> size=107374182
>>>
>>> readwrite=randrw
>>> bssplit=64k/50:1M/50
>>> ;bs=64k
>>>
>>> do_verify=1
>>> verify=meta
>>> verify_interval=64k
>>> verify_dump=1
>>> continue_on_error=verify
>>
>>
>> That does sound like a bug. Out of curiosity, does anything change if
>> you set experimental_verify=1 in the job?
>>
>> I'll take a look at this next week, currently away on vacation.
>>
>>> Also, if I set a verify_interval larger than the smallest io size in
>>> bssplt, I get another kind of error.
>>> Error messages with bssplt=4k/50:1M/50:
>>>
>>> verify: bad magic header a678, wanted acca at file /tmp/test offset
>>> 9097216, length 429524186
>>> verify: bad magic header 84b9, wanted acca at file /tmp/test offset
>>> 25268224, length 21518097
>>> verify: bad magic header ba51, wanted acca at file /tmp/test offset
>>> 26505216, length 536429778
>>> verify: bad magic header 1197, wanted acca at file /tmp/test offset
>>> 42139648, length 373139796
>>> verify: bad magic header 22bf, wanted acca at file /tmp/test offset
>>> 42209280, length 493427719
>>> meta: verify failed at file /tmp/test offset 50462720, length 65536
>>> open verify buf file: Read-only file system
>>> open verify buf file: Read-only file system
>>> verify: bad magic header d1f6, wanted acca at file /tmp/test offset
>>> 52305920, length 322125536
>>> verify: bad magic header 76ee, wanted acca at file /tmp/test offset
>>> 92106752, length 355054425
>>> verify: bad magic header 821, wanted acca at file /tmp/test offset
>>> 94904320, length 460051914
>>>
>>> I don't get these error when I set bs=4k.
>>> Are you aware of such a limitation in fio?
>>
>>
>> Fio doesn't support verify intervals larger than a single written block,
>> so that is something the parser or option checker should catch.
>> Apparently it doesn't. I'll take a look at this too.
>
>
> Looks like it's numberio biting us again... Can you try with this patch? For
> the mixed case, haven't looked into interval > bs yet.
>
> --
> Jens Axboe
>

