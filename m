Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5342DFEE.1010608@kernel.dk>
References: <CAEyTGCdvCouz3O-ohfq-Cj9+0X4FkShmZg7gfzE4p+PwHuaDZA@mail.gmail.com>
	<5342DFEE.1010608@kernel.dk>
Date: Mon, 7 Apr 2014 12:37:30 -0500
Message-ID: <CAEyTGCfLjxcHHh7s6RC3u2ekH5A_OXOqJ3mxyEpEQZ70-umudQ@mail.gmail.com>
Subject: Re: --status-interval option doesn't work in 2.1.6.1 version
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Checked in 2.1.7 , still doesn't work

Thanks
Lakshmi

On Mon, Apr 7, 2014 at 12:27 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/07/2014 11:26 AM, Lakshmi wrote:
>>
>> Hi Jens,
>>
>>
>> The --status-interval option used to work in 2.1.4 , but when I tried
>> this in 2.1.6.1 it doesnt work anymore.
>> below is the command I run,
>>
>> fio --status-interval=10 FIO_Random.job > test_interval.txt
>
>
> It's fixed in the 2.1.7 release.
>
> --
> Jens Axboe
>

