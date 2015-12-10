Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5669B23C.1020001@kernel.dk>
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
	<5669B23C.1020001@kernel.dk>
Date: Thu, 10 Dec 2015 17:58:03 +0000
Message-ID: <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
Subject: Re: Exit all jobs on error
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10 December 2015 at 17:11, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/10/2015 12:01 AM, Sitsofe Wheeler wrote:
>>
>> Hi,
>>
>> Is there an option to exit all jobs but only on error? If I have a job
>> like this
>>
>> [global]
>> stonewall=1
>> verify=crc32
>> rw=write
>> [pass1]
>> bs=4k
>> [pass2]
>> bs=8k
>>
>> I want fio to stop if pass1 fails verification and for pass2 not to be
>> performed at all. I'm aware of "exitall" but using that will make fio
>> quit even if pass1 is successful.
>
>
> That doesn't exist, but we could add a exitall_on_error to have that
> behavior. Should be pretty easy to add.

That would work for me - that way it could be put in the global
section or per (stonewall) group.

-- 
Sitsofe | http://sucs.org/~sits/

