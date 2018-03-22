Return-Path: <axboe@kernel.dk>
Subject: Re: valgrind spews
References: <a7527854-7ed3-a074-278e-e75f75cec4e7@kernel.dk>
 <CALjAwxgaVddxmgzkM6S7d6SP0FTdBT9y6QeO58L870qxBYDqAg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ed74b20d-cd3b-2b0a-89d1-188be58a5dae@kernel.dk>
Date: Thu, 22 Mar 2018 11:01:18 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxgaVddxmgzkM6S7d6SP0FTdBT9y6QeO58L870qxBYDqAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/22/18 10:53 AM, Sitsofe Wheeler wrote:
> On 22 March 2018 at 16:14, Jens Axboe <axboe@kernel.dk> wrote:
>> Hi Bart,
>>
>> After your commit:
>>
>> commit 0ffccc21fcd67d1e1d2a360e90f3fe8efc0d6b52
>> Author: Bart Van Assche <bart.vanassche@wdc.com>
>> Date:   Thu Mar 8 13:41:36 2018 -0800
>>
>>     Improve Valgrind instrumentation of memory allocations
>>
>> running valgrind on a fio spews a lot of warnings:
>>
>> ==14331== Invalid write of size 8
>> ==14331==    at 0x4C3451F: memset (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
>> ==14331==    by 0x4595F8: memset (string3.h:90)
>> ==14331==    by 0x4595F8: smalloc_pool (smalloc.c:434)
>> ==14331==    by 0x4595F8: __smalloc (smalloc.c:452)
>> ==14331==    by 0x4727CD: flow_init (flow.c:112)
>> ==14331==    by 0x421886: setup_thread_area (init.c:391)
>> ==14331==    by 0x42552A: get_new_job (init.c:468)
>> ==14331==    by 0x42552A: __parse_jobs_ini (init.c:1928)
>> ==14331==    by 0x42585F: parse_jobs_ini (init.c:2082)
>> [...]
>>
>> Basically off any path that ends up in smalloc, on the memset()
>> that we do:
>>
>>         ptr = __smalloc_pool(pool, alloc_size);
>>         if (ptr) {
>>                 struct block_hdr *hdr = ptr;
>>
>>                 hdr->size = alloc_size;
>>                 fill_redzone(hdr);
>>
>>                 ptr += sizeof(*hdr);
>>                 memset(ptr, 0, size);
>>                 ^^^
>>         }
>>
>> for every alloc. From configure:
>>
>> Valgrind headers              yes
> 
> I can't reproduce that one here with the following:
> 
> valgrind ./fio --ioengine=libaio --thread --rw=read
> --filename=/tmp/fio.tmp --size=1M  --flow=2 --stonewall --name=test
> --name=test2
> 
> My configure says this:
> 
> Valgrind headers              yes
> 
> Additionally after a
> make clean
> do you find that
> git clean -xn
> still finds built files to remove?

Run it as a server:

$ valgrind ./fio --server
$ ./fio --client=localhost null.fio

$ cat null.fio
[null]
bs=4k
ioengine=null
size=1g
rw=read

The above was supposed to say "fio server", but apparently I missed
putting that in...

-- 
Jens Axboe


