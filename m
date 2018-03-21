Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:35995 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753266AbeCUS63 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Mar 2018 14:58:29 -0400
Received: by mail-it0-f42.google.com with SMTP id c1-v6so7110803itj.1
        for <fio@vger.kernel.org>; Wed, 21 Mar 2018 11:58:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB406473637173E4C4207EA09F8FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
References: <CAKwzdDrOufV5HjdN3=+Hvr1vbnUrgM8U5G=9Wuk1Lh_kjAiFCw@mail.gmail.com>
 <CAKwzdDqnZE_cEe61Hx-GCzTuc+MDwzpqD_JVwTZF4ky_znNnFA@mail.gmail.com> <SN6PR04MB406473637173E4C4207EA09F8FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 21 Mar 2018 11:57:48 -0700
Message-ID: <CAKwzdDo7g+3pLCogrnz9Af1KqK=nOBxS3Sm5636w051OFmTgGA@mail.gmail.com>
Subject: Re: FIO latency bin midpoint vs upper limit capture
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: fio <fio@vger.kernel.org>

Jeff,
averaging is not the correct way to go for latency measuring. We
should be using json+ or histogram flow for each bucket IOPS landing.

On Wed, Mar 21, 2018 at 11:22 AM, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Not sure I understand the question, but you can record max latency per log_avg_msec interval.  For example, set log_avg_msec=1000 and then set log_max_value=1 to see the max latency per 1000ms.
>
> Regards,
> Jeff
>
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of abhishek koundal
> Sent: Wednesday, March 21, 2018 10:55 AM
> To: fio <fio@vger.kernel.org>
> Subject: Re: FIO latency bin midpoint vs upper limit capture
>
> Checking back if there is any feedback on the above request for reporting max latency in the bins.
> Appreciate the support.
>
> On Wed, Mar 14, 2018 at 2:07 PM, abhishek koundal <akoundal@gmail.com> wrote:
>> All,
>> Currently the FIO latency  bins does the i/o count and but then as per
>> Lower bound, midpoint (rounded off), upper limit
>>
>> The reported latency is the based on the "midpoint".
>> Is there a way to report it based on the "upper limit"? e.g. compile
>> fio with some switch etc.
>>
>> Appreciate your support always :).
>>
>> --
>> Life is too short for silly things so invest your time in some
>> productive outputs!!
>
>
>
> --
> Life is too short for silly things so invest your time in some productive outputs!!
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
