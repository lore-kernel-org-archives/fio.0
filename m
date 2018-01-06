Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:47055 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbeAFLVG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 6 Jan 2018 06:21:06 -0500
Received: by mail-ua0-f172.google.com with SMTP id j4so1831341ual.13
        for <fio@vger.kernel.org>; Sat, 06 Jan 2018 03:21:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxg0oUu7Lf235M-g1eZKJxCuSpnQJVBwTLYJ-ma0GJY+wg@mail.gmail.com>
References: <CALjAwxg0oUu7Lf235M-g1eZKJxCuSpnQJVBwTLYJ-ma0GJY+wg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 6 Jan 2018 11:20:34 +0000
Message-ID: <CALjAwxivGi9xdT8VTx9Eb0Ar+Zb7C3e5vc6OM8mpkRQ8g5Jisw@mail.gmail.com>
Subject: Re: Verify mismatch with buffer_pattern and verify_pattern
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Gnana Sekhar <kgsgnana2020@gmail.com>

Just correcting my prior wrong explanation for the record: the problem
wasn't that verify_pattern's value "is only used when verify=pattern"
it was because verify_pattern without verify=pattern means only the
non-header parts of the block are expected to match the verify_pattern
value but the verification header is still expected to be present and
correct. A strict "headerless" verify (by adding verify=pattern)
solved the problem because the original write job didn't write a
verification header.

On 4 January 2018 at 07:03, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> The value of verify_pattern is only used when verify=pattern (see
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify
> ) is set. It's interesting that you got a verifying run without that
> option though :-) Also note you can arrange for runs with verify
> options to only do the write part by using do_verify=0 (see
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-do-verify
> ).
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

-- 
Sitsofe | http://sucs.org/~sits/
