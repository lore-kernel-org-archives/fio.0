Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:44887 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753188AbdK0Til (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Nov 2017 14:38:41 -0500
Received: by mail-ua0-f173.google.com with SMTP id j14so19817464uag.11
        for <fio@vger.kernel.org>; Mon, 27 Nov 2017 11:38:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk> <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com> <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 27 Nov 2017 19:38:09 +0000
Message-ID: <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
Subject: Re: fio 3.2
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Brian Boylston <brian.boylston@hpe.com>, Robert Elliott <elliott@hpe.com>

Unfortunately I don't have access to a pmem device but let's see how far we get:

On 27 November 2017 at 12:39, Gavriliuk, Anton (HPS Ukraine)
<anton.gavriliuk@hpe.com> wrote:
>
> result=$(fio --name=random-writers --ioengine=mmap --iodepth=32 --rw=randwrite --bs=64k --size=1024m --numjobs=8 --group_reporting=1 --eta=never --time_based --runtime=60 --filename=/dev/dax0.0 | grep WRITE)

Please make your problem scenarios as simple as possible:
1. Just run fio normally so we can see the output it produces on both
stdout and stderr normally.
2. Reduce the job back so it there are only the bare minimum options
that reproduce the problem.
3. Try to avoid changing lots of things.

Here you've switched ioengine introducing another place to look.
Instead how about this:

Was your /dev/dax0.0 device made using ndctl? Assuming yes:

fio --name=dax-mmap --ioengine=mmap --rw=write --bs=64k --eta=never
--time_based --runtime=60 --filename=/dev/dax0.0 --size=2g

(apparently a size has to be specified when you try to use a character
device - see https://nvdimm.wiki.kernel.org/ )

If you run just that by itself what do you see?

Next up:

fio --name=dax-dax --ioengine=dev-dax --rw=write --bs=64k --eta=never
--time_based --runtime=60 --filename=/dev/dax0.0 --size=2g

If you run just that by itself what do you see?

Finally:
Assuming a -o dax mounted filesystem on /pmem0/ :

fio --name=libpmemblk --ioengine=pmemblk --rw=write --bs=64k
--eta=never --time_based --runtime=60
--filename=/pmem0/fio-test,4096,1024 --thread=1

If you run just that by itself what do you see?

(Perhaps the documentation for these ioengines and pmem devices needs
to be improved?)

-- 
Sitsofe | http://sucs.org/~sits/
