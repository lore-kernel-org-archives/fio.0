Return-Path: <axboe@kernel.dk>
Subject: Re: valgrind spews
References: <a7527854-7ed3-a074-278e-e75f75cec4e7@kernel.dk>
 <CALjAwxgaVddxmgzkM6S7d6SP0FTdBT9y6QeO58L870qxBYDqAg@mail.gmail.com>
 <ed74b20d-cd3b-2b0a-89d1-188be58a5dae@kernel.dk>
 <1521738727.2637.14.camel@sandisk.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3e6568da-0dfe-7d4a-138d-f04e43a3dd7b@kernel.dk>
Date: Thu, 22 Mar 2018 11:23:21 -0600
MIME-Version: 1.0
In-Reply-To: <1521738727.2637.14.camel@sandisk.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "sitsofe@gmail.com" <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/22/18 11:12 AM, Bart Van Assche wrote:
> On Thu, 2018-03-22 at 11:01 -0600, Jens Axboe wrote:
>> Run it as a server:
>>
>> $ valgrind ./fio --server
>> $ ./fio --client=localhost null.fio
>>
>> $ cat null.fio
>> [null]
>> bs=4k
>> ioengine=null
>> size=1g
>> rw=read
>>
>> The above was supposed to say "fio server", but apparently I missed
>> putting that in...
> 
> If I run that test, Valgrind only reports the following on my laptop:
> 
> ==17458== Conditional jump or move depends on uninitialised value(s)
> ==17458==    at 0x463FFD: __sk_out_drop (server.c:142)
> ==17458==    by 0x463FFD: handle_connection (server.c:1257)
> ==17458==    by 0x463FFD: accept_loop (server.c:1389)
> ==17458==    by 0x463FFD: fio_server (server.c:2468)
> ==17458==    by 0x464894: fio_start_server (server.c:2552)
> ==17458==    by 0x426F8E: parse_cmd_line (init.c:2880)
> ==17458==    by 0x427602: parse_options (init.c:2931)
> ==17458==    by 0x41134A: main (fio.c:42)
> ==17458== 
> ==17458== Conditional jump or move depends on uninitialised value(s)
> ==17458==    at 0x46400F: __sk_out_drop (server.c:146)
> ==17458==    by 0x46400F: handle_connection (server.c:1257)
> ==17458==    by 0x46400F: accept_loop (server.c:1389)
> ==17458==    by 0x46400F: fio_server (server.c:2468)
> ==17458==    by 0x464894: fio_start_server (server.c:2552)
> ==17458==    by 0x426F8E: parse_cmd_line (init.c:2880)
> ==17458==    by 0x427602: parse_options (init.c:2931)
> ==17458==    by 0x41134A: main (fio.c:42)
> 
> Where is the sk_out structure allocated? Can Valgrind know whether or not
> that structure has been initialized?

In server.c:accept_loop() and that structure is memset at alloc
time as it's coming out of smalloc().

-- 
Jens Axboe


