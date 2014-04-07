Return-Path: <axboe@kernel.dk>
Message-ID: <5342DFEE.1010608@kernel.dk>
Date: Mon, 07 Apr 2014 11:27:10 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --status-interval option doesn't work in 2.1.6.1 version
References: <CAEyTGCdvCouz3O-ohfq-Cj9+0X4FkShmZg7gfzE4p+PwHuaDZA@mail.gmail.com>
In-Reply-To: <CAEyTGCdvCouz3O-ohfq-Cj9+0X4FkShmZg7gfzE4p+PwHuaDZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/07/2014 11:26 AM, Lakshmi wrote:
> Hi Jens,
>
>
> The --status-interval option used to work in 2.1.4 , but when I tried
> this in 2.1.6.1 it doesnt work anymore.
> below is the command I run,
>
> fio --status-interval=10 FIO_Random.job > test_interval.txt

It's fixed in the 2.1.7 release.

-- 
Jens Axboe


