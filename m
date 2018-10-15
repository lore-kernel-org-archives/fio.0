Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f179.google.com ([209.85.215.179]:40335 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbeJPEWH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Oct 2018 00:22:07 -0400
Received: by mail-pg1-f179.google.com with SMTP id n31-v6so9704006pgm.7
        for <fio@vger.kernel.org>; Mon, 15 Oct 2018 13:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <CA+zhgFRC+POb+WouXuMRmVq9+RU9iA7aeoPowZGpHskijdmWmg@mail.gmail.com>
 <18e69925-71ad-c735-e65a-80dcb1728af1@gmail.com>
In-Reply-To: <18e69925-71ad-c735-e65a-80dcb1728af1@gmail.com>
From: smitha sunder <sundersmitha@gmail.com>
Date: Mon, 15 Oct 2018 13:35:04 -0700
Message-ID: <CA+zhgFROhypEEhFfwywCa722EjYAE5Hcau55ow=EF4bGN-G7wA@mail.gmail.com>
Subject: Re: JSON versus terse : latency_us : "2"
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: vincentfu@gmail.com
Cc: fio <fio@vger.kernel.org>

On Mon, Oct 15, 2018 at 12:09 PM Vincent Fu <vincentfu@gmail.com> wrote:
>
> On 10/11/2018 01:51 PM, smitha sunder wrote:
> >>From the JSON output :
> >        "latency_us" : {
> >          "2" : 11.500203, <----
> >          "4" : 40.336987,
> >          "10" : 2.821762,
> >          "20" : 0.121803,
> >          "50" : 0.020300,
> >          "100" : 0.000000,
> >          "250" : 0.000000,
> >          "500" : 0.000000,
> >          "750" : 0.000000,
> >          "1000" : 0.000000
> >        },
> >
> > Terse output :
> > lat_2us 56.70% <---
> > lat_4us 40.34%
> > lat_10us 2.82%
> > lat_20us 0.12%
> > lat_50us 0.02%
> > lat_100us 0.00%
> > lat_250us 0.00%
> > lat_500us 0.00%
> > lat_750us 0.00%
> > lat_1000us 0.00%
>
> This is because the terse output has no nanosecond latency values. So
> the terse lat_2us bucket includes everything below 2us.
>
> The JSON latency_us 2 bucket includes only the percentage from 1-2us.
> There should also be a "latency_ns" JSON object with the percentage
> distribution for latencies under 1us. If you add up all those along with
> the latency_us 2 value of 11.5, you should get 56.7%.

Thanks Vicent! Appreciate the help!



Here it is :

      "latency_ns" : {

        "2" : 0.000000,

        "4" : 0.000000,

        "10" : 0.000000,

        "20" : 0.000000,

        "50" : 0.000000,

        "100" : 0.030451,

        "250" : 1.421031,

        "500" : 4.496549,

        "750" : 3.664231,

        "1000" : 35.586683

      },

      "latency_us" : {

        "2" : 11.500203,

        "4" : 40.336987,

        "10" : 2.821762,

        "20" : 0.121803,

        "50" : 0.020300,

        "100" : 0.000000,

        "250" : 0.000000,

        "500" : 0.000000,

        "750" : 0.000000,

        "1000" : 0.000000

      },

      "latency_ms" : {

        "2" : 0.000000,

        "4" : 0.000000,

        "10" : 0.000000,

        "20" : 0.000000,

        "50" : 0.000000,

        "100" : 0.000000,

        "250" : 0.000000,

        "500" : 0.000000,

        "750" : 0.000000,

        "1000" : 0.000000,

        "2000" : 0.000000,

        ">=2000" : 0.000000

      },



Thanks

smitha

