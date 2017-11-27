Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:42709 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752614AbdK0WsE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Nov 2017 17:48:04 -0500
From: Rebecca Cran <rebecca@bluestop.org>
Subject: Re: fio 3.2
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk>
 <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com>
 <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
Message-ID: <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org>
Date: Mon, 27 Nov 2017 15:48:02 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Brian Boylston <brian.boylston@hpe.com>, Robert Elliott <elliott@hpe.com>

If you don’t have a pmem device, Linux can emulate one using RAM and the 
‘memmap’ kernel parameter. See 
http://pmem.io/2016/02/22/pm-emulation.html for more info.

Rebecca

Sent from my iPhone

On Nov 27, 2017, at 12:38 PM, Sitsofe Wheeler <sitsofe@gmail.com 
<mailto:sitsofe@gmail.com>> wrote:

> Unfortunately I don't have access to a pmem device but let's see how 
> far we get:
>
> On 27 November 2017 at 12:39, Gavriliuk, Anton (HPS Ukraine)
> <anton.gavriliuk@hpe.com <mailto:anton.gavriliuk@hpe.com>> wrote:
>>
>> result=$(fio --name=random-writers --ioengine=mmap --iodepth=32 
>> --rw=randwrite --bs=64k --size=1024m --numjobs=8 --group_reporting=1 
>> --eta=never --time_based --runtime=60 --filename=/dev/dax0.0 | grep 
>> WRITE)
>
> Please make your problem scenarios as simple as possible:
> 1. Just run fio normally so we can see the output it produces on both
> stdout and stderr normally.
> 2. Reduce the job back so it there are only the bare minimum options
> that reproduce the problem.
> 3. Try to avoid changing lots of things.
>
> Here you've switched ioengine introducing another place to look.
> Instead how about this:
>
> Was your /dev/dax0.0 device made using ndctl? Assuming yes:
>
> fio --name=dax-mmap --ioengine=mmap --rw=write --bs=64k --eta=never
> --time_based --runtime=60 --filename=/dev/dax0.0 --size=2g
>
> (apparently a size has to be specified when you try to use a character
> device - see https://nvdimm.wiki.kernel.org/ )
>
> If you run just that by itself what do you see?
>
> Next up:
>
> fio --name=dax-dax --ioengine=dev-dax --rw=write --bs=64k --eta=never
> --time_based --runtime=60 --filename=/dev/dax0.0 --size=2g
>
> If you run just that by itself what do you see?
>
> Finally:
> Assuming a -o dax mounted filesystem on /pmem0/ :
>
> fio --name=libpmemblk --ioengine=pmemblk --rw=write --bs=64k
> --eta=never --time_based --runtime=60
> --filename=/pmem0/fio-test,4096,1024 --thread=1
>
> If you run just that by itself what do you see?
>
> (Perhaps the documentation for these ioengines and pmem devices needs
> to be improved?)
>
> -- 
> Sitsofe | http://sucs.org/~sits/ <http://sucs.org/%7Esits/>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org 
> <mailto:majordomo@vger.kernel.org>
> More majordomo info at http://vger.kernel.org/majordomo-info.html
