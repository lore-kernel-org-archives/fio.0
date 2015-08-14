Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55CE1025.6080009@kernel.dk>
References: <CALjAwxh7sx3OHw9Gb=gBwet+YqpJNNDzZusNZK7X7bGK0Z06pQ@mail.gmail.com>
	<55CE0DA9.6050204@kernel.dk>
	<55CE1025.6080009@kernel.dk>
Date: Fri, 14 Aug 2015 20:11:10 +0100
Message-ID: <CALjAwxjk6TG+UO6d3L_7Fq=Ucm5WBtkMLLQwSqx+F_J9f=gReg@mail.gmail.com>
Subject: Re: server mode and verify_dump
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 14 August 2015 at 16:58, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/14/2015 09:47 AM, Jens Axboe wrote:
>>
>> On 08/03/2015 03:12 PM, Sitsofe Wheeler wrote:
>>>
>>> Hi,
>>>
>>> I've noticed that when running fio in server mode it's not possible to
>>> get a dump of using verify_dump when a verify mismatch occurs. Is it
>>> possible to add a mode where the server process saves the mismatch
>>> files to its current working directory for inspection later?
>>
>>
>> That sounds like an oversight. To save time, can you let me know how you
>> are invoking fio and with what job file? Should not be that hard to
>> fixup, it should just work.
>
>
> Just tested this, and the fio backend does dump the files if verify_dump=1
> is set:
>
> [...]
> <lenny> write3: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=sync,
> iodepth=1
> <lenny> Starting 1 process
> <lenny> crc16: verify failed at file file offset 2023424, length 4096
> <lenny>        Expected CRC: 5b54
> <lenny>        Received CRC: c1aa
> <lenny>        received data dumped as file.2023424.received
> <lenny>        expected data dumped as file.2023424.expected

You're absolutely right. I think I got fooled because of two things:
1. I was trying to use dd to stomp zeros while also using the sync
ioengine on a file in /dev/shm and just getting a file I/O error.
2. If fio encounters an error while trying to read the header (even if
the blocks are all of the same size) it doesn't dump anything at all
(even in non-server circumstances)...

-- 
Sitsofe | http://sucs.org/~sits/

