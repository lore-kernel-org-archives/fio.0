Return-Path: <axboe@kernel.dk>
Subject: Re: time_based not working with randread
References: <F0E1506A-A23F-4C12-B003-9860F71FC91A@linaro.org>
 <CALjAwxiWDecVfJsUr2eiBnL4q4nc_v+XZwjVNiOE0rKj+hc_aQ@mail.gmail.com>
 <42E4AE76-FC46-44EF-9B7A-430B0148E1AD@linaro.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <14c60616-42dd-705a-1617-08c4a70e5a05@kernel.dk>
Date: Thu, 31 May 2018 08:38:18 -0600
MIME-Version: 1.0
In-Reply-To: <42E4AE76-FC46-44EF-9B7A-430B0148E1AD@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 5/31/18 2:55 AM, Paolo Valente wrote:
> 
> 
>> Il giorno 27 mag 2018, alle ore 16:24, Sitsofe Wheeler <sitsofe@gmail.com> ha scritto:
>>
>> Hi Paolo!
>>
>> On 25 May 2018 at 20:20, Paolo Valente <paolo.valente@linaro.org> wrote:
>>> Hi,
>>> if I run this job (even with the last version GitHub version of fio) on an SSD:
>>> [global]
>>> ioengine=sync
>>> time_based=1
>>> runtime=20
>>> readwrite=randread
>>> size=100m
>>> numjobs=1
>>> invalidate=1
>>> [job1]
>>>
>>> then, after little time (I think after 100MB have been read), fio reports a nonsensically large value for the throughput, while a simple iostat shows that no I/O is going on. By just replacing time_based with loops, i.e., with a job file like this:
>>>
>>> [global]
>>> ioengine=sync
>>> loops=1000
>>> readwrite=randread
>>> size=100m
>>> numjobs=1
>>> invalidate=1
>>> [job1]
>>>
>>> the problem disappears.
>>
>> I've taken a stab at fixing this over in
>> https://github.com/sitsofe/fio/tree/random_reinvalidate - does that
>> solve the issue for you too?
> 
> Nope :(
> 
>> ...
>> I know I'm "Teaching grandmother to suck eggs" given that you're the
>> author of BFQ but just in case...
>>
>> This issue happens on loops=1000 too and I believe it's down to
>> readahead.
> 
> I'm afraid there is a misunderstanding on this, grandson :)
> 
> As I wrote, this problem does not occur with loops=1000.  My
> impression is that, with loops, as well as with time-based and read,
> fio does invalidate the cache every time it restarts reading the same
> file, while with time_based and randread it does not (or maybe it
> tries to, but fails for some reason).

This is basically by design. loop will go through the full
open+invalidate, whereas time_based will just keep chugging
along. Once your 100mb is in page cache, then no more IO
will be done, as reads are just served from there.

-- 
Jens Axboe


