Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34000 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdILFms (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Sep 2017 01:42:48 -0400
Received: by mail-wr0-f173.google.com with SMTP id v109so18285020wrc.1
        for <fio@vger.kernel.org>; Mon, 11 Sep 2017 22:42:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxid3Bs-6bH+nk2wziLoZ0NeOARzh=TNpYK6Ej7uof-XQg@mail.gmail.com>
References: <CAOfm_=Vbf8fbusKvMQ+_2B7qpvUoCaYFEnoBnNa8Bwpdh__Zgg@mail.gmail.com>
 <CAOfm_=XN7r7h-_epT6OFGzGYvjYekChLk5k+pSQr4LYuN+O64g@mail.gmail.com> <CALjAwxid3Bs-6bH+nk2wziLoZ0NeOARzh=TNpYK6Ej7uof-XQg@mail.gmail.com>
From: Udi-Yehuda Tamar <udi@excelero.com>
Date: Tue, 12 Sep 2017 08:42:47 +0300
Message-ID: <CAOfm_=V8JognC=PZ4VBxwdTigxxVcO9X8o2CNN8swoCoPgWG7Q@mail.gmail.com>
Subject: Re: FIO distinguish data corruption and io errors
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

thx a lot Sitofe

I'm using only libaio and I'm parsing the output Json file
I was looking to see if there is a unique msg for data corruption but
it's look like every other IO error

--Udi

On Mon, Sep 11, 2017 at 10:43 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 11 September 2017 at 18:24, Udi-Yehuda Tamar <udi@excelero.com> wrote:
>> I guess this question answers it's self but I'll give it a try ,
>> Can Fio tell for sure the IO err is a data corruption ? say the drive
>> is busy and the read failed
>> but not necessarily on data corruption can Fio tell that?
>> I guess not! because every IO failure can be a data corruption , but I
>> prefer a pro answer - thx in adv.
>
> This depends on how the ioengine and the layers beneath handle it. For
> example the psync ioengine talks to a filesystem or block device and
> in Linux there's typically some sort of error handling that happens
> below the block layer (see
> http://events.linuxfoundation.org/sites/events/files/slides/SCSI-EH.pdf
> for how this happens for SCSI) so if the kernel (or the disk itself!)
> has handled the error by retrying then all userspace (and thus fio)
> will see is success but the latency for I/Os that get caught up might
> look abnormally high or the I/O will return with an error like EIO.
> fio can be made to abort if an I/O returns with high latency (see the
> max_latency option -
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-max-latency).
>
> Different I/O engines may be able to return different types of error
> depending on what they are talking to and what level they operate at.
> For example the sg ioengine sets a timeout of 30 seconds but it looks
> like this still makes error handling kick in (see
> http://sg.danny.cz/sg/p/sg_v3_ho.html#id2495241 ).
>
> I don't know if this answer is "pro" enough for you though...
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Thanks,
Udi-Yehuda Tamar.
