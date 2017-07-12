Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:35259 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdGLG7c (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Jul 2017 02:59:32 -0400
Received: by mail-vk0-f49.google.com with SMTP id f68so4183227vkg.2
        for <fio@vger.kernel.org>; Tue, 11 Jul 2017 23:59:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMHrwcRkq0vEiuqgqgZwN7djaJDS6=U1f6QPRWH2YDQpWf588w@mail.gmail.com>
References: <CAMHrwcRkq0vEiuqgqgZwN7djaJDS6=U1f6QPRWH2YDQpWf588w@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 12 Jul 2017 09:58:50 +0300
Message-ID: <CAHndrBksa9=vc8cZL0NW52U8XQVYwekdttm6e50dk920=OTpfQ@mail.gmail.com>
Subject: Re: unexpected stonewall parsing led jobs separated by stonewall to
 run concurrently
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ido Ben-Tsion <idob@infinidat.com>
Cc: fio@vger.kernel.org

Run with --debug=process and see if there is
"<name>: stonewall wait"
for <name> which you expect to be stonewall'd.

2017-07-12 8:13 GMT+03:00 Ido Ben-Tsion <idob@infinidat.com>:
> fio version: fio-2.21-37-ga2c9
>
> fio file excerpt:
> [global]
> ioengine=sg
> invalidate=1
> ramp_time=5
> iodepth=16
> runtime=300
> time_based
> bs=64k
> norandommap
> loops=5
>
> [seq_read-2-jobs]
> rw=read
> numjobs=2
> stonewall
>
> [randread]
> rw=randread
> [seq_write]
> rw=write
> stonewall
> ...
>
> In the report, I see jobs with groupid 0 which are not supposed to be
> on same group:
> ...,jobname,groupid,...
> ...,seq_read-2-jobs,0,...
> ...,seq_read-2-jobs,0,...
> ...,randread,0,...
> ...,seq_write,1,...
>
>
> thanks,
> Ido Ben-Tsion
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
