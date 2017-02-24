Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:34612 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdBXBY4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Feb 2017 20:24:56 -0500
Received: by mail-ua0-f181.google.com with SMTP id 60so3132959uah.1
        for <fio@vger.kernel.org>; Thu, 23 Feb 2017 17:24:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CY4PR10MB1494804E84709ACA355AE6AE8C530@CY4PR10MB1494.namprd10.prod.outlook.com>
References: <CY4PR10MB1494804E84709ACA355AE6AE8C530@CY4PR10MB1494.namprd10.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 24 Feb 2017 01:24:24 +0000
Message-ID: <CALjAwxjoaJpLoFxW9YO2C=RSnzbZK_pm9QadRJzLcJbBKkUkmA@mail.gmail.com>
Subject: Re: FIO log averaging issue with --write_bw_log and --write_iops_log
 using > 1000 log_avg_msec values
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Taylor <ctaylor@pivot3.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 23 February 2017 at 20:55, Chris Taylor <ctaylor@pivot3.com> wrote:
> There is an issue in FIO when using the detailed bandwidth and iops logging with averaging over a period of time > 1 second.
> It seems that usecs overflows which later causes negative time diff values resulting in skewed toward 0 results.
> I have attached a potential fix that should prevent usecs from going beyond 1000000.

Is this problem shown by the following job:

./fio --ioengine=null --write_bw_log=/dev/null --log_avg_msec=2000
--size=100M --runtime=10s --time_based --name=overflow

Among Clang's undefined behaviour sanitizer output was this for the above:
stat.c:2265:43: runtime error: unsigned integer overflow: 1999 - 2000
cannot be represented in type 'unsigned long'
stat.c:2265:28: runtime error: unsigned integer overflow: 3999 -
4294967295 cannot be represented in type 'unsigned long'

> diff --git a/time.c b/time.c
> index f5dc049..c748bee 100644
> --- a/time.c
> +++ b/time.c
> @@ -8,11 +8,18 @@ static unsigned long ns_granularity;
>
> void timeval_add_msec(struct timeval *tv, unsigned int msec)
> {
> -       tv->tv_usec += 1000 * msec;
> -       if (tv->tv_usec >= 1000000) {
> -               tv->tv_usec -= 1000000;
> -               tv->tv_sec++;
> -       }
> +       int adj_usec = 1000 * msec;
> +       int adj_sec = 0;
> +       tv->tv_usec +=  adj_usec;
> +       if (adj_usec >= 1000000) {
> +               adj_sec = adj_usec / 1000000;
> +               tv->tv_usec -=  adj_sec * 1000000;
> +               tv->tv_sec += adj_sec;
> +    }
> +    if (tv->tv_usec >= 1000000){
> +            tv->tv_usec -= 1000000;
> +            tv->tv_sec++;
> +    }
> }

Is it still safe to use int if you're targeting a 32 bit platform?

-- 
Sitsofe | http://sucs.org/~sits/
