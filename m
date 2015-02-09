Return-Path: <axboe@kernel.dk>
Message-ID: <54D8D1EC.5080008@kernel.dk>
Date: Mon, 09 Feb 2015 08:27:40 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] verify: Fix latency log for verify commands.
References: <1423454000-7730-1-git-send-email-gwendal@chromium.org> <CANvN+emftqHL8e9NUyYvCQQbKPgxhOWsZNZvNgz-txgW-Qpkdg@mail.gmail.com> <54D8CF9D.6050402@kernel.dk> <CANvN+e=KcRLWA3XsBtkgmpcSZcAoa7VdyD5wT-_mCJbFH_c+2w@mail.gmail.com>
In-Reply-To: <CANvN+e=KcRLWA3XsBtkgmpcSZcAoa7VdyD5wT-_mCJbFH_c+2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Gwendal Grignou <gwendal@chromium.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/09/2015 08:25 AM, Andrey Kuzmin wrote:
> On Mon, Feb 9, 2015 at 6:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 02/09/2015 02:39 AM, Andrey Kuzmin wrote:
>>>
>>> On Mon, Feb 9, 2015 at 6:53 AM, Gwendal Grignou <gwendal@chromium.org>
>>> wrote:
>>>>
>>>> When commands when requeued for the verify operation,
>>>> their start time was not reset, resulting in bogus latency graphs.
>>>
>>>
>>> Does it really make sense to account for the verification pass in the
>>> latency profile?
>>
>>
>> Why not? If you are doing a full write then verification, you get a full set
>> of separate read and write latencies.
>
> I'd rather get them on a per-pass basis. Imagine an r/w workload being
> done with verification pass (just to be on the safe side): I'd rather
> keep read-only verification pass latencies separate from the primary
> workload latency profile. YMMW :).

Sure, if it's a mixed read/write workload and you verify after the fact, 
then it could be handy to have the two "different" kinds of reads 
separate. But that's really orthogonal to the issue being fixed by 
Gwendals patch...


-- 
Jens Axboe


