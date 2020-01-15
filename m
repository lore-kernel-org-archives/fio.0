Return-Path: <axboe@kernel.dk>
Subject: Re: FIO verify bad header question
References: <CAA6um5PoJSafFa6Xa9ZeZqXUyXPA5b2fGNWA=+OoRVhkkXgogg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7b667f2f-dbe9-7ff1-72f4-d41d0994e21d@kernel.dk>
Date: Wed, 15 Jan 2020 08:31:39 -0700
MIME-Version: 1.0
In-Reply-To: <CAA6um5PoJSafFa6Xa9ZeZqXUyXPA5b2fGNWA=+OoRVhkkXgogg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Michael Chichik <michael.c@excelero.com>
Cc: Matan Ramrazker <matan@excelero.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Please use the fio list for this, CC'ed.

On 1/15/20 8:28 AM, Michael Chichik wrote:
> Hi,
> My name is Michael  and I am SW QA Engineer. I am using FIO v 3.16 as IO generator.
> 
> I executed the following command on a directory mounted on XFS. (centos 7):
> *
> *
> */usr/bin/fio --time_based --runtime=1d --ioengine=libaio --iodepth=32 --rw=randrw --bs=24k --direct=0 --io_size=60G --numjobs=10 --size=1G --rwmixread=0 --verify=md5 --verify_fatal=1 --output-format=json --output=4_randrw_0_10_32_libaio_xfs_1G.json --directory /mnt/test-vol-23206-36 --name host1_test-vol-23206-36
> *
> FIO failed with the following error:
> *
> *
> *verify: bad header rand_seed 1089408830752521594, wanted 7280637923435198810 at file /mnt/test-vol-23206-36/filename offset 776945664, length 24576
> *
> 
> but when we compare the block level data is consistent.
> 
> what is the meaning of the Error? does it really indicate data corruption?
> 
> 
> Thanks,
> Michael.
> 
> 


-- 
Jens Axboe


