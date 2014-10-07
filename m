Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
Date: Tue, 7 Oct 2014 15:00:27 +0000
Message-ID: <D059784E.51EFC%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
 <D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com>
 <D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com>
 <54333D69.7060304@kernel.dk>
 <CADzpL0SQ56xmwT5umYu+OdCMu5YwaV6vngruLzpPyoEu=_iy+w@mail.gmail.com>
 <54334D63.70909@kernel.dk>
 <D05964A6.51EA6%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D05967DE.51EB1%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <5433F5FF.60508@kernel.dk> <5433F8C1.1030100@kernel.dk>
 <D0597430.51EDC%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <5433FEEF.2070402@kernel.dk>
In-Reply-To: <5433FEEF.2070402@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B47B58613703D2449153AFADA49E032D@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Stephen Cameron <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/7/14, 10:55 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 10/07/2014 08:44 AM, Neto, Antonio Jose Rodrigues wrote:
>>=20
>>=20
>> On 10/7/14, 10:29 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>=20
>>> On 10/07/2014 08:17 AM, Jens Axboe wrote:
>>>>> Please see below:
>>>>>
>>>>> Nossa Senhora:fio neto$ make V=3D1 t/dedupe
>>>>> gcc  -std=3Dgnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement
>>>>> -O3 -g
>>>>> -ffast-math  -D_GNU_SOURCE -include config-host.h -DBITS_PER_LONG=3D6=
4
>>>>> -DFIO_VERSION=3D'"fio-2.1.13-31-g15e3"' -o t/dedupe  -ll -lz  -lm
>>>>> -lpthread
>>>>> -ldl
>>>>> Undefined symbols for architecture x86_64:
>>>>>   "_yylex", referenced from:
>>>>>       _main in libl.a(libmain.o)
>>>>> ld: symbol(s) not found for architecture x86_64
>>>>> clang: error: linker command failed with exit code 1 (use -v to see
>>>>> invocation)
>>>>> make: *** [t/dedupe] Error 1
>>>>>
>>>>> Any idea how to fix it?
>>>>
>>>> It's only supported on Linux right now, it will be built automatically
>>>> there. Not really a design problem, it's just that it has the Linux
>>>> method for getting the size of a block device hard wired. I can fix
>>>>that
>>>> pretty quickly.
>>>
>>> I changed it to use the fio supplied blockdev_size(), so it should work
>>> on all platforms now:
>>>
>>>=20
>>>http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3Dd08a6886fa57f819682f055=
48d284
>>>a0
>>> 79a99e77d
>>>
>>> Pull, make clean, and make again. Should work on OSX and others now.
>>>
>>> --=20
>>> Jens Axboe
>>>
>>=20
>> Hi Jens,
>>=20
>> This is neto from Brazil
>>=20
>> How are you?
>>=20
>> :-(
>>=20
>> Trying with the latest commit on my mac.
>>=20
>>     CC lex.yy.o
>> lex.yy.c:1231:3: warning: incompatible pointer types passing 'yy_size_t
>>*'
>>       (aka 'unsigned long *') to parameter of type 'int *'
>>       [-Wincompatible-pointer-types]
>>   ...YY_INPUT( (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
>>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> exp/expression-parser.l:31:25: note: expanded from macro 'YY_INPUT'
>>                 lexer_input((buffer), &(bytes_read), (bytes_requested))
>>                                       ^~~~~~~~~~~~~
>> exp/expression-parser.l:27:43: note: passing argument to parameter
>> 'nbytes' here
>> extern int lexer_input(char* buffer, int *nbytes, int buffersize);
>>                                           ^
>> 1 warning generated.
>>     CC y.tab.o
>>     CC parse.o
>>     CC mutex.o
>>     CC options.o
>>     CC lib/rbtree.o
>>     CC smalloc.o
>>     CC filehash.o
>>     CC profile.o
>>     CC debug.o
>>     CC lib/rand.o
>>     CC lib/num2str.o
>>     CC lib/ieee754.o
>>     CC crc/crc16.o
>>     CC crc/crc32.o
>>     CC crc/crc32c-intel.o
>>     CC crc/crc32c.o
>>     CC crc/crc64.o
>>     CC crc/crc7.o
>>     CC crc/fnv.o
>>     CC crc/md5.o
>>     CC crc/murmur3.o
>>     CC crc/sha1.o
>>     CC crc/sha256.o
>>     CC crc/sha512.o
>>     CC crc/test.o
>>     CC crc/xxhash.o
>>     CC engines/cpu.o
>>     CC engines/mmap.o
>>     CC engines/sync.o
>>     CC engines/null.o
>>     CC engines/net.o
>>     CC memalign.o
>>     CC server.o
>>     CC client.o
>>     CC iolog.o
>>     CC backend.o
>>     CC libfio.o
>>     CC flow.o
>>     CC cconv.o
>>     CC lib/prio_tree.o
>>     CC json.o
>>     CC lib/zipf.o
>>     CC lib/axmap.o
>>     CC lib/lfsr.o
>>     CC gettime-thread.o
>>     CC helpers.o
>>     CC lib/flist_sort.o
>>     CC lib/hweight.o
>>     CC lib/getrusage.o
>>     CC idletime.o
>>     CC td_error.o
>>     CC profiles/tiobench.o
>>     CC profiles/act.o
>>     CC io_u_queue.o
>>     CC filelock.o
>>     CC lib/tp.o
>>     CC lib/bloom.o
>>     CC engines/posixaio.o
>>     CC fio.o
>>   LINK fio
>>     CC t/stest.o
>>     CC t/log.o
>>     CC t/debug.o
>>   LINK t/stest
>>     CC t/ieee754.o
>>   LINK t/ieee754
>>     CC t/genzipf.o
>>   LINK t/genzipf
>>     CC t/axmap.o
>>   LINK t/axmap
>>     CC t/lfsr-test.o
>>   LINK t/lfsr-test
>>     CC t/dedupe.o
>> t/dedupe.c:14:10: fatal error: 'linux/fs.h' file not found
>> #include <linux/fs.h>
>>          ^
>> 1 error generated.
>> make: *** [t/dedupe.o] Error 1
>> Nossa Senhora:fio neto$
>
>t/dedupe should work now if you pull again. There's still some oddity
>around the size_t - ignore that for now, it'll work, and we'll get it
>sorted.
>
>--=20
>Jens Axboe

Hi Jens,

This is neto from Brazil

How are you?

All good with dedupe.

    CC lex.yy.o
lex.yy.c:1231:3: warning: incompatible pointer types passing 'yy_size_t *'
(aka 'unsigned long *') to parameter of type 'int *'
      [-Wincompatible-pointer-types]
                YY_INPUT(
(&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
               =20
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exp/expression-parser.l:31:25: note: expanded from macro 'YY_INPUT'
                lexer_input((buffer), &(bytes_read), (bytes_requested))
                                      ^~~~~~~~~~~~~
exp/expression-parser.l:27:43: note: passing argument to parameter
'nbytes' here
extern int lexer_input(char* buffer, int *nbytes, int buffersize);
                                          ^
1 warning generated.
    CC y.tab.o
    CC parse.o
    CC mutex.o
    CC options.o
    CC lib/rbtree.o
    CC smalloc.o
    CC filehash.o
    CC profile.o
    CC debug.o
    CC lib/rand.o
    CC lib/num2str.o
    CC lib/ieee754.o
    CC crc/crc16.o
    CC crc/crc32.o
    CC crc/crc32c-intel.o
    CC crc/crc32c.o
    CC crc/crc64.o
    CC crc/crc7.o
    CC crc/fnv.o
    CC crc/md5.o
    CC crc/murmur3.o
    CC crc/sha1.o
    CC crc/sha256.o
    CC crc/sha512.o
    CC crc/test.o
    CC crc/xxhash.o
    CC engines/cpu.o
    CC engines/mmap.o
    CC engines/sync.o
    CC engines/null.o
    CC engines/net.o
    CC memalign.o
    CC server.o
    CC client.o
    CC iolog.o
    CC backend.o
    CC libfio.o
    CC flow.o
    CC cconv.o
    CC lib/prio_tree.o
    CC json.o
    CC lib/zipf.o
    CC lib/axmap.o
    CC lib/lfsr.o
    CC gettime-thread.o
    CC helpers.o
    CC lib/flist_sort.o
    CC lib/hweight.o
    CC lib/getrusage.o
    CC idletime.o
    CC td_error.o
    CC profiles/tiobench.o
    CC profiles/act.o
    CC io_u_queue.o
    CC filelock.o
    CC lib/tp.o
    CC lib/bloom.o
    CC engines/posixaio.o
    CC fio.o
  LINK fio
    CC t/stest.o
    CC t/log.o
    CC t/debug.o
  LINK t/stest
    CC t/ieee754.o
  LINK t/ieee754
    CC t/genzipf.o
  LINK t/genzipf
    CC t/axmap.o
  LINK t/axmap
    CC t/lfsr-test.o
  LINK t/lfsr-test
    CC t/dedupe.o
  LINK t/dedupe
Nossa Senhora:fio neto$ cd t
Nossa Senhora:t neto$ ./dedupe
Check for dedupable blocks on a device/file

./dedupe: [options] <device or file>
	-b	Chunk size to use
	-t	Number of threads to use
	-d	Full extent/chunk debug output
	-o	Use O_DIRECT
	-c	Full collision check
	-B	Use probabilistic bloom filter
	-p	Print progress indicator




Thank you,

neto


