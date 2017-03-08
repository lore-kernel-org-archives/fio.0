Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:34232 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754462AbdCHUdb (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Mar 2017 15:33:31 -0500
Received: by mail-ua0-f173.google.com with SMTP id f54so51169715uaa.1
        for <fio@vger.kernel.org>; Wed, 08 Mar 2017 12:32:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBZEgd=r9fjn9xG57c08y-xH44sJiK2r==hGcdCHo0x+zw@mail.gmail.com>
References: <CAKV1nBZEgd=r9fjn9xG57c08y-xH44sJiK2r==hGcdCHo0x+zw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 8 Mar 2017 20:23:22 +0000
Message-ID: <CALjAwxiwYOz7a_Yh5QA77xDG6pc6nZvXU2roMH75L96KmGOtuA@mail.gmail.com>
Subject: Re: FIO data integrity - description for different fields
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

How to correctly read the metadata isn't totally straightforward - it
depends upon at least your system's architecture, which verification
you used, which version of fio you are using and possibly other
factors. Since you didn't include any of this information in your
email it's hard to say anything definite about your example. You also
don't include the exact message that fio printed out when it found the
mismatch which again makes it difficult to help...

From some old notes I have:
From fio-2.2.10 onwards (see commit b638d82f882bd8c15cc933ee0b8fa684308e7855
for when it changed), when using a verify other than 'pattern' a generic header
is made at the start of each block written. On Linux x86_64 (see struct
verify_header in verify.h -
https://github.com/axboe/fio/blob/fio-2.18/verify.h#L30) the header
has the following format:

0x0000000 1111 2222 3333 3333 4444 4444 4444 4444
0x0000010 5555 5555 5555 5555 6666 6666 7777 7777
0x0000020 8888 9999 aaaa aaaa 5a5a 5a5a 5a5a 5a5a

1111 = magic number identifying fio header (0xacca)
2222 = verify_type (0x0005 for crc32c/crc32c-intel, 0x000b for xxhash)
3333 = header_len (length of the block)
4444 = rand_seed
5555 = offset
6666 = time_sec (usually (see clocksource=str in the fio HOWTO) based on the
                 CLOCK_MONOTONIC clock which has an unspecified start)
7777 = time_usec
8888 = fio thread number that wrote this block
9999 = numberio (I/O issuance number)
aaaa = crc32 (crc32c of the header before this point)
5a   = verify_type specific data (e.g. block checksum) / data pattern
(poison in this case)

There is checksum specific data that comes after the "aaaa" part of
the header depending on the verify_type you chose (see the verify_type
field which refers to the enum in verify.h -
https://github.com/axboe/fio/blob/ae3a5accfdbe1fbfde6ba4ab583887a7d3d779ac/verify.h#L9).

Be warned that when fio tries to synthesise the "expected" file there
are some areas of the expected header it may not have the information
to fill in.

On 8 March 2017 at 15:07, Saju Nair <saju.mad.nair@gmail.com> wrote:
> Hi FIO community,
> I am doing a data integrity checks to an SSD device (DUT - device under test)
> This is done with FIO using
> -verify=crc32c
> -verify_pattern=0x88888888
>
> block size  =4KB
>
> We get a failure, and there are *53248..expected and *53248.received.
> Could somebody explain the meta information in the beginning of the block data.
> We could locate the LBA (53248 = 0xd000) at location offset = 0x10,
> But a comprehensive explanation would help to identify the issue.
> What is the CRC32 field ?
> Does the CRC32 include the header information as well ?
>
> The Expected file is :
> 0000000: caac 0500 0010 0000 0000 0000 0000 0000  ................
> 0000010: 00d0 0000 0000 0000 0000 0000 0000 0000  ................
> 0000020: 0100 0d00 303c bb47 203f d2f2 8888 8888  ....0<.G ?......
> 0000030: 8888 8888 8888 8888 8888 8888 8888 8888  ................
> 0000040: 8888 8888 8888 8888 8888 8888 8888 8888  ................
> ....
> 0000fe0: 8888 8888 8888 8888 8888 8888 8888 8888  ................
> 0000ff0: 8888 8888 8888 8888 8888 8888 8888 8888  ................
>
>
> Regards,
> - Saju.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sitsofe | http://sucs.org/~sits/
