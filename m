Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54D8D1EC.5080008@kernel.dk>
References: <1423454000-7730-1-git-send-email-gwendal@chromium.org>
 <CANvN+emftqHL8e9NUyYvCQQbKPgxhOWsZNZvNgz-txgW-Qpkdg@mail.gmail.com>
 <54D8CF9D.6050402@kernel.dk> <CANvN+e=KcRLWA3XsBtkgmpcSZcAoa7VdyD5wT-_mCJbFH_c+2w@mail.gmail.com>
 <54D8D1EC.5080008@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 9 Feb 2015 19:59:23 +0400
Message-ID: <CANvN+ekfTi6DxqEiD9B30tK78nNeHuBDNaThe+B1AV8C=atzmQ@mail.gmail.com>
Subject: Re: [PATCH] verify: Fix latency log for verify commands.
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Gwendal Grignou <gwendal@chromium.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Feb 9, 2015 at 6:27 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 02/09/2015 08:25 AM, Andrey Kuzmin wrote:
>>
>> On Mon, Feb 9, 2015 at 6:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 02/09/2015 02:39 AM, Andrey Kuzmin wrote:
>>>>
>>>>
>>>> On Mon, Feb 9, 2015 at 6:53 AM, Gwendal Grignou <gwendal@chromium.org>
>>>> wrote:
>>>>>
>>>>>
>>>>> When commands when requeued for the verify operation,
>>>>> their start time was not reset, resulting in bogus latency graphs.
>>>>
>>>>
>>>>
>>>> Does it really make sense to account for the verification pass in the
>>>> latency profile?
>>>
>>>
>>>
>>> Why not? If you are doing a full write then verification, you get a full
>>> set
>>> of separate read and write latencies.
>>
>>
>> I'd rather get them on a per-pass basis. Imagine an r/w workload being
>> done with verification pass (just to be on the safe side): I'd rather
>> keep read-only verification pass latencies separate from the primary
>> workload latency profile. YMMW :).
>
>
> Sure, if it's a mixed read/write workload and you verify after the fact,
> then it could be handy to have the two "different" kinds of reads separate.

May be a case for an extra option to control latency profile
aggregation (disable_verify_lat ?)?

> But that's really orthogonal to the issue being fixed by Gwendals patch...

Sure, it has just brought up an earlier point :).


Regards,
Andrey


>
>
> --
> Jens Axboe
>

