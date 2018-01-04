Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38987 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbeADHQR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Jan 2018 02:16:17 -0500
Received: by mail-wm0-f46.google.com with SMTP id i11so1595619wmf.4
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 23:16:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxg0oUu7Lf235M-g1eZKJxCuSpnQJVBwTLYJ-ma0GJY+wg@mail.gmail.com>
References: <CALjAwxg0oUu7Lf235M-g1eZKJxCuSpnQJVBwTLYJ-ma0GJY+wg@mail.gmail.com>
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Thu, 4 Jan 2018 00:16:16 -0700
Message-ID: <CAPSTwmTRuT8N78A8ZZF6BpHLDv=8WGEmupFhzmD=k0AgT6mYPg@mail.gmail.com>
Subject: Re: Verify mismatch with buffer_pattern and verify_pattern
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org

Sure. Agreed. Didn't mean to skip the group, mistakenly hit reply
instead of reply all. Sent the same email again to the mailing list
but received your response around the same time

Even with addition of --verify=pattern, I step into the failure

$ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
--iodepth=1 --name=bs128k_rwread_rsmixr0_qd256 --bs=4096
--percentage_random=0 --rw=write --filename=/dev/nvme0n1 -o
/home/temp.log --buffer_pattern=0 --size=409600


$ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
--iodepth=1 --bs=4096 --percentage_random=0 --filename=/dev/nvme0n1 -o
/home/temp.log --name=bs4096_rwverify_qd256 --size=409600 --rw=read
--verify_pattern=0x1 --verify=pattern
fio: got pattern '00', wanted '01'. Bad bits 1
fio: bad pattern block offset 0
pattern: verify failed at file /dev/nvme0n1 offset 0, length 0
fio: verify type mismatch (0 media, 18 given)


Haven't thought of a new mail thread. Good suggestion. Will create a new thread

Regards,
Gnana

On Thu, Jan 4, 2018 at 12:03 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> Can you ensure fio questions are sent to the mailing list and not just
> me? Others often benefit from the answers when using search engines
> and it gives people other than myself a chance to answer your question
> too! :-)
>
> The value of verify_pattern is only used when verify=pattern (see
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify
> ) is set. It's interesting that you got a verifying run without that
> option though :-) Also note you can arrange for runs with verify
> options to only do the write part by using do_verify=0 (see
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-do-verify
> ).
>
> (PS: it would have also been nicer to have started a new mail thread
> for this continue the existing one)
>
> On 4 January 2018 at 06:44, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>>
>> I am running into error in verify after I do a write and verify. I am
>> running these commands from the shell and not in parallel. Below are
>> the parameters I am passing to FIO
>> Please let me know if you find something obvious
>>
>> $ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
>> --iodepth=1 --name=bs128k_rwread_rsmixr0_qd256 --bs=4096
>> --percentage_random=0 --rw=write --filename=/dev/nvme0n1 -o
>> /home/temp.log --buffer_pattern=1 --size=76815
>>
>>
>> $ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
>> --iodepth=1 --bs=4096 --percentage_random=0 --filename=/dev/nvme0n1 -o
>> /home/temp.log --name=bs4096_rwverify_qd256 --size=76815 --rw=read
>> --verify_pattern=0x1 --debug=all
>>
>> verify: bad magic header 101, wanted acca at file /dev/nvme0n1 offset
>> 0, length 4096
>
> --
> Sitsofe | http://sucs.org/~sits/
