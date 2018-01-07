Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:46074 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbeAGKCd (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 7 Jan 2018 05:02:33 -0500
Received: by mail-ua0-f176.google.com with SMTP id e39so5095852uae.12
        for <fio@vger.kernel.org>; Sun, 07 Jan 2018 02:02:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmQP8GcH9Rt4W5FaTi+Y8qeVUYiEkwJkRvPXw59sPZ+1QQ@mail.gmail.com>
References: <CALjAwxg0oUu7Lf235M-g1eZKJxCuSpnQJVBwTLYJ-ma0GJY+wg@mail.gmail.com>
 <CALjAwxivGi9xdT8VTx9Eb0Ar+Zb7C3e5vc6OM8mpkRQ8g5Jisw@mail.gmail.com> <CAPSTwmQP8GcH9Rt4W5FaTi+Y8qeVUYiEkwJkRvPXw59sPZ+1QQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 7 Jan 2018 10:02:01 +0000
Message-ID: <CALjAwxhKHbgMgVf7Fqx8d4cnDvp_-pdA-FCEEANvtcnncR5aSA@mail.gmail.com>
Subject: Re: Verify mismatch with buffer_pattern and verify_pattern
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio@vger.kernel.org

On 6 January 2018 at 14:35, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> If I wanted the pattern written to be random, is it correct to specify
> option -random_generator.

Probably not - random_generator only controls which algorithm is used
to generate random numbers so in this case it's not the option you're
after.

>
> If random_generator is the option to use which option should I specify

If you don't enable a fixed pattern and you enable verification at
write time then the data fio writes into each block will be random bar
the verification header.

$ rm -f /tmp/fio.tmp
$ fio --rw=write --filename=/tmp/fio.tmp --bs=64 --size=512
--verify=crc32c --name=write_then_verify
[...]
$ hexdump -C /tmp/fio.tmp
00000000  ca ac 05 00 40 00 00 00  3c 54 09 c5 01 cc a4 00  |....@...<T......|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  01 00 00 00 d5 4b 36 f6  4b ae d6 e9 6c c7 4e 18  |.....K6.K...l.N.|
00000030  ce d0 f8 3c 26 d8 f1 17  19 1a 38 5f 88 1c 0d 11  |...<&.....8_....|
00000040  ca ac 05 00 40 00 00 00  2e 56 db f6 8c 0a bb 88  |....@....V......|
00000050  40 00 00 00 00 00 00 00  0a 42 05 00 b2 44 0d 00  |@........B...D..|
00000060  01 00 01 00 1a d5 68 80  17 a8 c3 55 3b 05 d3 1f  |......h....U;...|
00000070  60 95 97 0f 3d cc 06 05  ac f2 42 d7 bb 51 22 18  |`...=.....B..Q".|
00000080

The above shows that when you get past the verification header (which
is at the beginning of the blocks and in this case is 44 bytes big)
the rest of the 128 byte blocks are different to each other. Note: the
random sequence that is used is based off a seed controlled by
randseed (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-randseed
). By default, fio uses the same seed each time you run it but this is
controllable - see randrepeat
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-randrepeat
) and related options.

> during verify. Will FIO keep track of random patterns written to verify

Sort of yes but what it uses to do so depends on how and when you
choose to do the verification.

If you are happy to do writes and let fio immediately do a
verification pass within the same job then you will fine with the
example above (also see
https://github.com/axboe/fio/blob/master/examples/basic-verify.fio ).

If you want to split things into entirely separate jobs then the
second job will have to be a read job (or a verify_only write job).
fio will entirely determine a block's correctness by using the data in
that block's verification header:

$ ./fio --rw=write --filename=/tmp/fio.tmp --bs=64 --size=128
--verify=crc32c --do_verify=0 --name=write_with_verify_headers
$ ./fio --rw=read --filename=/tmp/fio.tmp --bs=64 --size=128
--verify=crc32c --name=verify
$ # Following generates a spurious error about no I/O but actually works fine
$ ./fio --rw=write --filename=/tmp/fio.tmp --bs=64 --size=128
--verify=crc32c --verify_only=1 --name=verify
$ # Damage the end of the second block so we can show verification failure
$ dd if=/dev/zero of=/tmp/fio.tmp bs=1 seek=127 count=1
$ ./fio --rw=read --filename=/tmp/fio.tmp --bs=64 --size=128
--verify=crc32c --name=verify_failure

See the verification section of the documentation (e.g.
http://fio.readthedocs.io/en/latest/fio_doc.html#verification ) for
more verification details and options.

-- 
Sitsofe | http://sucs.org/~sits/
