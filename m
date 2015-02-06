Return-Path: <sendtold@gmail.com>
Return-Path: <sendtold@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: io_u->flags & IO_U_F_FLIGHT failed errors when using libaio
From: Of <sendtold@gmail.com>
In-Reply-To: <54D52E8C.4060803@kernel.dk>
Date: Fri, 6 Feb 2015 17:32:13 -0600
Content-Transfer-Encoding: 7bit
Message-Id: <94D849AD-CCC8-4DE5-842D-A5AA16F789CA@gmail.com>
References: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com> <54D52E8C.4060803@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Yes Jens it is ppc64

Sent from my iPhone

> On Feb 6, 2015, at 3:13 PM, Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 02/06/2015 01:03 PM, Lakshmi wrote:
>> Hi Jens,
>>   I have a job file that looks like below and it keeps giving errors
>> like attached in screen shot. I am using fio-2.2.4
>> 
>> cmd="$FIO --name=test  --group_reporting=1 --ioengine=libaio
>> --invalidate=1 --iodepth=32 --bs=4K --filename=/dev/sde --rw=randread
>> --direct=1 --buffered=0 --time_based --runtime=300 --numjobs=64"
>> 
>> Any idea what is causing this?
> 
> Is this on ppc64?
> 
> 
> -- 
> Jens Axboe
> 

