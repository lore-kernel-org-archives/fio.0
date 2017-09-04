Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:37913 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753953AbdIDToQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Sep 2017 15:44:16 -0400
Received: by mail-ua0-f179.google.com with SMTP id l24so3574566uaa.5
        for <fio@vger.kernel.org>; Mon, 04 Sep 2017 12:44:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=WPcxuUQyV1HSBkE07vJhtKfseQiZ2JEG81bVpYV7GENw@mail.gmail.com>
References: <CAOfm_=VLQ0cVZPwDHtnzNO1Hj395z+2rq4AQvzhCyT9j75EqWw@mail.gmail.com>
 <CAOfm_=WPcxuUQyV1HSBkE07vJhtKfseQiZ2JEG81bVpYV7GENw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 4 Sep 2017 20:43:44 +0100
Message-ID: <CALjAwxj_SpfuX7XmLiSy3i7pUCv4gtC=ywr8gbN0jY6pQLx+KQ@mail.gmail.com>
Subject: Re: Corrupted json file
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Udi-Yehuda Tamar <udi@excelero.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 4 September 2017 at 10:29, Udi-Yehuda Tamar <udi@excelero.com> wrote:
>
> we're using the latest stable 2.99GA FIO for our product testing ,
> when trying to setup fio to write on ext4 mount we got a line that
> failing our code to load the json file .
> mt exe cmd:
>
> fio --verify=md5 --randrepeat 0 --direct=1 --rw write --thread=32

Thread doesn't take a parameter (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-thread
)...

>  --exitall_on_error=1 --directory /mnt/v1 --verify_interval=4096
> --buffered 0 --output-format=json --size 1M --iodepth 1 --name FioJob
> --rwmixread 100 --verify_dump=1 --norandommap --verify_fatal=1
> --output /var/opt/executions/None/FioFS_f12f9c_1504448587_None.log
> --runtime 0 --fill_fs 0 --do_verify=1 --numjobs 20 --blocksize 4K
> --verify_pattern=0xaa --time_based=0 --ioengine libaio
>
>
> output file:
>
> Multiple writers may overwrite blocks that belong to other jobs. This
> can cause verification failures.

Does git fio still generate this warning? If it's gone it mean the
general problem of warnings interfering with json has been solved but
it might mean you don't trigger that particular warning with this
particular job...

-- 
Sitsofe | http://sucs.org/~sits/
