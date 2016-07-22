Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <nmthlt$4m6$1@ger.gmane.org>
References: <nmthlt$4m6$1@ger.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 22 Jul 2016 19:58:38 +0100
Message-ID: <CALjAwxiuy1sN6W-NVFRiqWONT0esJj=MQv5i_Nkw157mr6ON2A@mail.gmail.com>
Subject: Re: "errror=Invalid or incomplete multibyte or wide character" &
 "verify: bad header numberio" errors
Content-Type: text/plain; charset=UTF-8
To: Saeed <ionictea@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 22 July 2016 at 17:29, Saeed <ionictea@gmail.com> wrote:
> Has anyone seen these errors before?
[...]
> fio-2.12
> Starting 40 processes
> fio: pid=5809, err=84/file:io_u.c:1968, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character

This frequently happens when a header is bad during verification. For
example if the initial verification header magic bytes are bad then
verify_header()  (from verify.c - see
https://github.com/axboe/fio/blob/fio-2.12/verify.c#L788 ) will end up
doing the following:

        return EILSEQ;

EILSEQ is defined as 84.
http://man7.org/linux/man-pages/man3/errno.3.html says this represents
"Illegal byte sequence". However deep in glibc this is mapped to
"Invalid or incomplete multibyte or wide character" when using
strerror (see https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/gnu/errlist.c;h=a9a5960503a97e78143a0c795e7255f418a22933;hb=HEAD#l929
). This seems to stem from its frequent usage with multibyte functions
(see http://www.lysator.liu.se/c/na1.html ).

So glibc has given EILSEQ a narrow error message ("Invalid or
incomplete multibyte or wide character") even though it originally had
a general meaning ("Illegal byte sequence") and fio is uses EILSEQ to
indicate to indicate it has found a corrupt header. I'm not sure
there's all that much that can be done about this...

-- 
Sitsofe | http://sucs.org/~sits/

