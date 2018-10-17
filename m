Return-Path: <axboe@kernel.dk>
Subject: Re: Cannot verify dedupe data, is it a bug?
References: <319f5589.a4d1.1668201794f.Coremail.feng_changyu@126.com>
 <CALjAwxiqYiErO0uh9E4oL8ub_jMQ2MDPgNiCon51s_yaWVrcUA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3cce6ba4-cfe3-1309-9852-f8cecff4131b@kernel.dk>
Date: Wed, 17 Oct 2018 13:05:33 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxiqYiErO0uh9E4oL8ub_jMQ2MDPgNiCon51s_yaWVrcUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, feng_changyu@126.com
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/17/18 12:32 PM, Sitsofe Wheeler wrote:
> On Wed, 17 Oct 2018 at 13:31, Changyu <feng_changyu@126.com> wrote:
>>
>> Hi,
>>
>> I set "dedupe_percentage " to let FIO generate some duplicated data.  I also want read these data back and verify it.
>> But, there is no duplicated data after setting "verify" parameter.
>>
>> checking the source code, I found that  function do_io  in file backend.c fill the buffer twice. the source code is as below.
>>
>> do_io()
>> {
>>     io_u = get_io_u(td);
>>     .....
>>     if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY)
>>         populate_verify_io_u(td, io_u);
>> }
>>
>> In function get_io_u, the buffer is filled with data as the "dedupe_percentage " specified.
>> In function populate_verify_io_u, the buffer is refilled with random data. So, there would be no duplicated data.
>>
>> Is this a bug?
> 
> If it's not (and I'd say it is) then the current behaviour needs to it
> needs to print a "conflicting options" error rather than silently not
> doing what was asked. Someone else has reported something similar over
> on https://github.com/axboe/fio/issues/449 ...

They should definitely be using the same fill methods.

-- 
Jens Axboe


