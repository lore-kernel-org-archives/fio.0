Return-Path: <axboe@kernel.dk>
Message-ID: <5346C30A.30006@kernel.dk>
Date: Thu, 10 Apr 2014 10:12:58 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio on AIX - fallocate error
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net> <5346A3FE.10106@kernel.dk> <E2B4022DB0264A4B90C5F1B01B8E677D733228A3@LIVP3MMBX13.mail.aig.net> <5346B9FE.10409@kernel.dk> <E2B4022DB0264A4B90C5F1B01B8E677D73322909@LIVP3MMBX13.mail.aig.net>
In-Reply-To: <E2B4022DB0264A4B90C5F1B01B8E677D73322909@LIVP3MMBX13.mail.aig.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Carino, Mario" <Mario.Carino@AIG.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/10/2014 09:56 AM, Carino, Mario wrote:
> Here's the job file:
>
> [4ktest]
> fallocate=1
> direct=1
> rw=randwrite
> refill_buffers
> norandommap
> randrepeat=0
> size=2G
> bs=4k
> iodepth=16
> numjobs=16
> runtime=60
> group_reporting
>
> This job file was created based on a sample command line I was given:
>
> fio --filename=/oradata2/o18g2/IO/fiotest4 --direct=1 --rw=randwrite --refill_buffers --norandommap --randrepeat=0 --size=2G --bs=4k  --iodepth=16 --numjobs=16 --runtime=60 --group_reporting --name=4ktest
>
> I think I understand enough that I need to run a rw=write job first before running the above job, correct?

No, you should not have to run rw=write first, you can run it as-is and 
fio should setup the files appropriately.

Can you try and delete any leftover 4ktest.* files from the job, and 
then re-run the job and add --debug=file? Then just break it when it 
starts going and send the output in a reply here.

-- 
Jens Axboe


