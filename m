Return-Path: <axboe@kernel.dk>
Subject: Re: Error during sequential read
References: <CAFrY4nQGgOkNK+wtEoXcY3FU36k-5U1eOne51RucDdjSnnV6ug@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ff68daac-1f7a-339c-f4c8-69b3c6470413@kernel.dk>
Date: Mon, 22 Aug 2016 15:22:04 -0600
MIME-Version: 1.0
In-Reply-To: <CAFrY4nQGgOkNK+wtEoXcY3FU36k-5U1eOne51RucDdjSnnV6ug@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: subrat dash <subratndash@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/22/2016 03:12 PM, subrat dash wrote:
> Hello,
>
> Hope you are well..!!
>
> I have a question regarding the verify test that is done using FIO.
>
> I am trying to run the --rw=read test using FIO. However, I am getting
> an error #84. Please find attached the output file.
>
> *err=84 (file:io_u.c:1805, func=io_u_sync_complete, error=Invalid or
> incomplete multibyte or wide character)*
>
> If you see in the output file, I ran the test with and without the
> verify_pattern argument. The test PASSES when I don't use this option
> but FAILs when I do.
>
> Also, This happens only when the Sequential READ test is done. The test
> does not FAIL when I use any other option such as mix write and read or
> random read, etc etc..
>
> Can you please tell me what exactly happens with this test? Does the
> command actually write the pattern to the drive first and then try to
> read it back or does it just try to read the pattern without writing
> anything? Does the test check for any ECC errors?

You really need to have a write phase first, not just a read phase. The
basic file layout will just happen to work with some read verification,
but don't rely on it.

-- 
Jens Axboe

