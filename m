Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:38313 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdILWDy (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Sep 2017 18:03:54 -0400
Received: by mail-vk0-f48.google.com with SMTP id x85so14321789vkx.5
        for <fio@vger.kernel.org>; Tue, 12 Sep 2017 15:03:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=V8JognC=PZ4VBxwdTigxxVcO9X8o2CNN8swoCoPgWG7Q@mail.gmail.com>
References: <CAOfm_=Vbf8fbusKvMQ+_2B7qpvUoCaYFEnoBnNa8Bwpdh__Zgg@mail.gmail.com>
 <CAOfm_=XN7r7h-_epT6OFGzGYvjYekChLk5k+pSQr4LYuN+O64g@mail.gmail.com>
 <CALjAwxid3Bs-6bH+nk2wziLoZ0NeOARzh=TNpYK6Ej7uof-XQg@mail.gmail.com> <CAOfm_=V8JognC=PZ4VBxwdTigxxVcO9X8o2CNN8swoCoPgWG7Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 12 Sep 2017 23:03:23 +0100
Message-ID: <CALjAwxhkHBdyN6H2wZQGbN6NhzuoxZ-Tp66M0Xfx2QHTskXg-g@mail.gmail.com>
Subject: Re: FIO distinguish data corruption and io errors
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Udi-Yehuda Tamar <udi@excelero.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Perhaps I answered the wrong question.

If *fio is doing I/O verification for itself* (i.e.
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify
is set etc.) then when fio verification fails it will report EILSEQ
(which with glibc will be reported as "Invalid or incomplete multibyte
or wide character" - see
https://www.spinics.net/lists/fio/msg04977.html for details) whereas
other errors will turn up as a different error message (e.g. EIO).

For example:
$ dd if=/dev/zero of=/tmp/fiofile bs=16k count=1
$ ./fio --name=verifymismatch --ioengine=sync --rw=read
--verify=crc32c --filename=/tmp/fiofile --verify_fatal=1
verifymismatch: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=sync, iodepth=1
fio-3.0-48-g83a9
Starting 1 process
verify: bad magic header 0, wanted acca at file /tmp/fiofile offset 0,
length 4096
verifymismatch: No I/O performed by sync, perhaps try --debug=io
option for details?
fio: pid=3702, err=84/file:io_u.c:1991, func=io_u_sync_complete,
error=Invalid or incomplete multibyte or wide character

verifymismatch: (groupid=0, jobs=1): err=84 (file:io_u.c:1991,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3702: Tue Sep 12 22:55:51 2017
   read: IOPS=62, BW=250KiB/s (256kB/s)(4096B/16msec)
[...]

Is that what you were after?

On 12 September 2017 at 06:42, Udi-Yehuda Tamar <udi@excelero.com> wrote:
>
> I'm using only libaio and I'm parsing the output Json file
> I was looking to see if there is a unique msg for data corruption but
> it's look like every other IO error
>
> On Mon, Sep 11, 2017 at 10:43 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> Different I/O engines may be able to return different types of error
>> depending on what they are talking to and what level they operate at.
>> For example the sg ioengine sets a timeout of 30 seconds but it looks
>> like this still makes error handling kick in (see
>> http://sg.danny.cz/sg/p/sg_v3_ho.html#id2495241 ).

-- 
Sitsofe | http://sucs.org/~sits/
