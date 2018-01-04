Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35332 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbeADHDo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Jan 2018 02:03:44 -0500
Received: by mail-ua0-f169.google.com with SMTP id g16so482437uak.2
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 23:03:43 -0800 (PST)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 4 Jan 2018 07:03:12 +0000
Message-ID: <CALjAwxg0oUu7Lf235M-g1eZKJxCuSpnQJVBwTLYJ-ma0GJY+wg@mail.gmail.com>
Subject: Re: Verify mismatch with buffer_pattern and verify_pattern
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio@vger.kernel.org

Hi,

Can you ensure fio questions are sent to the mailing list and not just
me? Others often benefit from the answers when using search engines
and it gives people other than myself a chance to answer your question
too! :-)

The value of verify_pattern is only used when verify=pattern (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify
) is set. It's interesting that you got a verifying run without that
option though :-) Also note you can arrange for runs with verify
options to only do the write part by using do_verify=0 (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-do-verify
).

(PS: it would have also been nicer to have started a new mail thread
for this continue the existing one)

On 4 January 2018 at 06:44, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> I am running into error in verify after I do a write and verify. I am
> running these commands from the shell and not in parallel. Below are
> the parameters I am passing to FIO
> Please let me know if you find something obvious
>
> $ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
> --iodepth=1 --name=bs128k_rwread_rsmixr0_qd256 --bs=4096
> --percentage_random=0 --rw=write --filename=/dev/nvme0n1 -o
> /home/temp.log --buffer_pattern=1 --size=76815
>
>
> $ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
> --iodepth=1 --bs=4096 --percentage_random=0 --filename=/dev/nvme0n1 -o
> /home/temp.log --name=bs4096_rwverify_qd256 --size=76815 --rw=read
> --verify_pattern=0x1 --debug=all
>
> verify: bad magic header 101, wanted acca at file /dev/nvme0n1 offset
> 0, length 4096

-- 
Sitsofe | http://sucs.org/~sits/
