Return-Path: <axboe@kernel.dk>
Subject: Re: Windows: FIO randomly hangs using attached script
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org>
 <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com>
 <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com>
 <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
 <971ECD81-B100-4EEE-98CE-0E578A59BB02@nutanix.com>
 <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
 <CALjAwxgF-2dK+Bc9iwkVsxA4sfWKYSmHe8k3YbpUyDmBWP34ow@mail.gmail.com>
 <CALjAwxirkjduZof+F3prrKX0wp9YS8apS-YdK8+ru1supg1dnA@mail.gmail.com>
 <CALjAwxjPGXSOGwLOSMfVdrmxXsr8ObT6W6E1UBs2LkjttSnduw@mail.gmail.com>
 <e85db28f-da18-e6cc-7eda-1b04d2cc95eb@kernel.dk>
 <CALjAwxg1SzQV9ss9jjqry8_MLgDfPYq9QdbA5eVZi-PkmSEAKA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <406902be-f4ce-c4f4-4e16-ee9caf8c0bcf@kernel.dk>
Date: Fri, 9 Mar 2018 07:55:32 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxg1SzQV9ss9jjqry8_MLgDfPYq9QdbA5eVZi-PkmSEAKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Rob Scheepens <rob.scheepens@nutanix.com>, David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/9/18 7:40 AM, Sitsofe Wheeler wrote:
> On 8 March 2018 at 16:18, Jens Axboe <axboe@kernel.dk> wrote:
>> Does the below patch make a difference?
>>
>>
>> diff --git a/mutex.c b/mutex.c
>> index 63229eda09d6..acc88dc33b98 100644
>> --- a/mutex.c
>> +++ b/mutex.c
>> @@ -240,10 +240,11 @@ void fio_mutex_up(struct fio_mutex *mutex)
>>         if (!mutex->value && mutex->waiters)
>>                 do_wake = 1;
>>         mutex->value++;
>> -       pthread_mutex_unlock(&mutex->lock);
>>
>>         if (do_wake)
>>                 pthread_cond_signal(&mutex->cond);
>> +
>> +       pthread_mutex_unlock(&mutex->lock);
>>  }
>>
>>  void fio_rwlock_write(struct fio_rwlock *lock)
> 
> It pains me to say this (because POSIX says such rejigging just
> changes the scheduling order) but yes your patch makes a difference.
> The following job would trigger the deadlock problem within 10 minutes
> for me:

In some implementations it's actually mandated to have the wakeup
within the lock, which seems to be the case here. It's a shame,
since it's clearly suboptimal (from a scalability point of view)
to have to hold the lock while issuing a wakeup for a process
that's going to grab the same lock.

I'll commit the patch. Thanks a lot for all your hard work on this
one, let's hope that was it...

-- 
Jens Axboe


