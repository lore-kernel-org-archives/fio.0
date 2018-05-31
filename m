Return-Path: <axboe@kernel.dk>
Subject: Re: time_based not working with randread
References: <F0E1506A-A23F-4C12-B003-9860F71FC91A@linaro.org>
 <CALjAwxiWDecVfJsUr2eiBnL4q4nc_v+XZwjVNiOE0rKj+hc_aQ@mail.gmail.com>
 <42E4AE76-FC46-44EF-9B7A-430B0148E1AD@linaro.org>
 <14c60616-42dd-705a-1617-08c4a70e5a05@kernel.dk>
 <668383BC-4178-41DF-8C20-FED79FD4B262@linaro.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d2ed6296-f9a0-6d5a-7846-db719d90f76d@kernel.dk>
Date: Thu, 31 May 2018 09:07:59 -0600
MIME-Version: 1.0
In-Reply-To: <668383BC-4178-41DF-8C20-FED79FD4B262@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 5/31/18 8:49 AM, Paolo Valente wrote:
> 
> 
>> Il giorno 31 mag 2018, alle ore 16:38, Jens Axboe <axboe@kernel.dk> ha scritto:
>>
>> On 5/31/18 2:55 AM, Paolo Valente wrote:
>>>
>>>
>>>> Il giorno 27 mag 2018, alle ore 16:24, Sitsofe Wheeler <sitsofe@gmail.com> ha scritto:
>>>>
>>>> Hi Paolo!
>>>>
>>>> On 25 May 2018 at 20:20, Paolo Valente <paolo.valente@linaro.org> wrote:
>>>>> Hi,
>>>>> if I run this job (even with the last version GitHub version of fio) on an SSD:
>>>>> [global]
>>>>> ioengine=sync
>>>>> time_based=1
>>>>> runtime=20
>>>>> readwrite=randread
>>>>> size=100m
>>>>> numjobs=1
>>>>> invalidate=1
>>>>> [job1]
>>>>>
>>>>> then, after little time (I think after 100MB have been read), fio reports a nonsensically large value for the throughput, while a simple iostat shows that no I/O is going on. By just replacing time_based with loops, i.e., with a job file like this:
>>>>>
>>>>> [global]
>>>>> ioengine=sync
>>>>> loops=1000
>>>>> readwrite=randread
>>>>> size=100m
>>>>> numjobs=1
>>>>> invalidate=1
>>>>> [job1]
>>>>>
>>>>> the problem disappears.
>>>>
>>>> I've taken a stab at fixing this over in
>>>> https://github.com/sitsofe/fio/tree/random_reinvalidate - does that
>>>> solve the issue for you too?
>>>
>>> Nope :(
>>>
>>>> ...
>>>> I know I'm "Teaching grandmother to suck eggs" given that you're the
>>>> author of BFQ but just in case...
>>>>
>>>> This issue happens on loops=1000 too and I believe it's down to
>>>> readahead.
>>>
>>> I'm afraid there is a misunderstanding on this, grandson :)
>>>
>>> As I wrote, this problem does not occur with loops=1000.  My
>>> impression is that, with loops, as well as with time-based and read,
>>> fio does invalidate the cache every time it restarts reading the same
>>> file, while with time_based and randread it does not (or maybe it
>>> tries to, but fails for some reason).
>>
>> This is basically by design. loop will go through the full
>> open+invalidate, whereas time_based will just keep chugging
>> along. Once your 100mb is in page cache, then no more IO
>> will be done, as reads are just served from there.
>>
> 
> Such a design confused me.  Highlighting somewhere this deviation
> (between loops and time_based) might help other dull people like me.

Actually, I'm misremembering, and we did fix this up. But looks
like I botched the fix, try pulling a new update and it should
work for you. Fix:

http://git.kernel.dk/cgit/fio/commit/?id=80f021501fda6a6244672bb89dd8221a61cee54b

-- 
Jens Axboe


