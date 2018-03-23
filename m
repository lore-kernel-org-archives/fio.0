Return-Path: <axboe@kernel.dk>
Subject: Re: valgrind spews
References: <a7527854-7ed3-a074-278e-e75f75cec4e7@kernel.dk>
 <CALjAwxgaVddxmgzkM6S7d6SP0FTdBT9y6QeO58L870qxBYDqAg@mail.gmail.com>
 <ed74b20d-cd3b-2b0a-89d1-188be58a5dae@kernel.dk>
 <1521738727.2637.14.camel@sandisk.com>
 <3e6568da-0dfe-7d4a-138d-f04e43a3dd7b@kernel.dk>
 <1521739678.2637.16.camel@wdc.com>
 <baec1170-03fc-7b43-85e6-8e80f2d11006@kernel.dk>
 <CALjAwxhOT1NJX556Y19_mMoY53sOf6V=-Q79FVfa8eX39vBJew@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <afb83e62-4b15-358f-c54e-012a80e7aa95@kernel.dk>
Date: Fri, 23 Mar 2018 08:49:35 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxhOT1NJX556Y19_mMoY53sOf6V=-Q79FVfa8eX39vBJew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/23/18 8:39 AM, Sitsofe Wheeler wrote:
> On 22 March 2018 at 17:29, Jens Axboe <axboe@kernel.dk> wrote:
>> On 3/22/18 11:27 AM, Bart Van Assche wrote:
>>> On Thu, 2018-03-22 at 11:23 -0600, Jens Axboe wrote:
>>>> On 3/22/18 11:12 AM, Bart Van Assche wrote:
>>>>> Where is the sk_out structure allocated? Can Valgrind know whether or not
>>>>> that structure has been initialized?
>>>>
>>>> In server.c:accept_loop() and that structure is memset at alloc
>>>> time as it's coming out of smalloc().
>>>
>>> Would you be OK with changing that smalloc() call into scalloc() such that
>>> Valgrind knows that that structure is initialized? On my laptop the following
>>> is sufficient to suppress the complaints mentioned in my previous e-mail:
>>
>> Sure, done.
> 
> Even with that patch I'm still seeing problems with that job when I do this:
> 
> for i in {1..5}; do ./fio --client=localhost null.fio; done
> 
> Here's what the valgrind is saying for the server:
> 
> ==2532== Warning: set address range perms: large range [0x14f90000,
> 0x2dce1000) (defined)
> ==2532== Invalid write of size 8
> ==2532==    at 0x4C34514: memset (vg_replace_strmem.c:1239)
> ==2532==    by 0x45E98A: smalloc_pool (smalloc.c:434)
> ==2532==    by 0x45E3D1: __smalloc (smalloc.c:452)
> ==2532==    by 0x45E346: smalloc (smalloc.c:478)
> ==2532==    by 0x485FA3: flow_init (flow.c:112)
> ==2532==    by 0x42CEA4: setup_thread_area (init.c:391)
> ==2532==    by 0x426B43: get_new_job (init.c:468)
> ==2532==    by 0x4273B8: __parse_jobs_ini (init.c:1928)
> ==2532==    by 0x426D77: parse_jobs_ini (init.c:2082)
> ==2532==    by 0x46FB6E: handle_job_cmd (server.c:792)
> ==2532==    by 0x46F756: handle_command (server.c:1000)
> ==2532==    by 0x46F15C: handle_connection (server.c:1242)
> ==2532==  Address 0x636f650 is 0 bytes inside a block of size 64 free'd
> ==2532==    at 0x45E151: sfree (smalloc.c:349)
> ==2532==    by 0x46DFE1: finish_entry (server.c:1100)
> ==2532==    by 0x46DE3E: handle_sk_entry (server.c:1159)
> ==2532==    by 0x46F640: handle_xmits (server.c:1181)
> ==2532==    by 0x46F02B: handle_connection (server.c:1209)
> ==2532==    by 0x46E92A: accept_loop (server.c:1389)
> ==2532==    by 0x46D17F: fio_server (server.c:2468)
> ==2532==    by 0x46CF9B: fio_start_server (server.c:2552)
> ==2532==    by 0x429081: parse_cmd_line (init.c:2876)
> ==2532==    by 0x42A114: parse_options (init.c:2927)
> ==2532==    by 0x4AABCD: main (fio.c:42)
> ==2532==  Block was alloc'd at
> ==2532==    at 0x45E43D: __smalloc (smalloc.c:456)
> ==2532==    by 0x45E346: smalloc (smalloc.c:478)
> ==2532==    by 0x46BE58: fio_net_prep_cmd (server.c:528)
> ==2532==    by 0x469F6A: fio_net_queue_cmd (server.c:571)
> ==2532==    by 0x46FFB0: handle_probe_cmd (server.c:877)
> ==2532==    by 0x46F778: handle_command (server.c:1006)
> ==2532==    by 0x46F15C: handle_connection (server.c:1242)
> ==2532==    by 0x46E92A: accept_loop (server.c:1389)
> ==2532==    by 0x46D17F: fio_server (server.c:2468)
> ==2532==    by 0x46CF9B: fio_start_server (server.c:2552)
> ==2532==    by 0x429081: parse_cmd_line (init.c:2876)
> ==2532==    by 0x42A114: parse_options (init.c:2927)

Right, this is identical to what I reported. I get tons of these with
the patch, not without.

-- 
Jens Axboe


