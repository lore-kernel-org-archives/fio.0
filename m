Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <2ce17fe4-3e39-a19e-b049-cd550d77a76d@eafit.edu.co>
In-Reply-To: <2ce17fe4-3e39-a19e-b049-cd550d77a76d@eafit.edu.co>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 16 Jun 2020 06:21:02 +0100
Message-ID: <CALjAwxiUY9TLKNsBKuDLk2aBwTAJJh9FkRSjqvmu7r1+SSKrnQ@mail.gmail.com>
Subject: Re: [io_uring] Performance analysis
Content-Type: text/plain; charset="UTF-8"
To: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

On Tue, 16 Jun 2020 at 04:57, Hamilton Tobon Mosquera
<htobonm@eafit.edu.co> wrote:
>
> I've been using and analyzing io_uring's performance with fio. I'm
> trying to replicate the results that Jens Axboe shows when he presents
> io uring in Kernel Recipes 2019. The problem is that I'm not even closer
> to that, nor that behavior. I have a server with two Intel Optanes (he
> mentions that he had to use two devices), but I think the problem is
> that I'm not using the proper fio parameter combination. Can you please
> tell me what fio configuration is needed to get 1.6 million iops with
> only one thread?, or at least that same behavior, not necesarily the 1.6
> million iops. I'm comparing io_uring in polling mode vs libaio, but I
> get the same iops with both of them, about 400K iops, issuing requests
> to both devices through separate files.

Have you seen https://itpeernetwork.intel.com/tuning-performance-intel-optane-ssds-linux-operating-systems/
by Intel's Frank Ober? For polling to actually do its work you need to
ensure your kernel has been configured to do polling too. It would
also be good to see what you were using as your fio command line (and
I guess which kernel you are using).

-- 
Sitsofe | http://sucs.org/~sits/

