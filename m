Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:46731 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbeCUTAa (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Mar 2018 15:00:30 -0400
Received: by mail-io0-f179.google.com with SMTP id g14so7899122iob.13
        for <fio@vger.kernel.org>; Wed, 21 Mar 2018 12:00:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116B7900CB55CC67D8CF9F781AA0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CAKwzdDrOufV5HjdN3=+Hvr1vbnUrgM8U5G=9Wuk1Lh_kjAiFCw@mail.gmail.com>
 <CAKwzdDqnZE_cEe61Hx-GCzTuc+MDwzpqD_JVwTZF4ky_znNnFA@mail.gmail.com> <CY1PR0401MB1116B7900CB55CC67D8CF9F781AA0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 21 Mar 2018 11:59:49 -0700
Message-ID: <CAKwzdDqnvbRchbKBQ8RK4HMeaDs_qNYYyEcPogna-kcHKhNb6Q@mail.gmail.com>
Subject: Re: FIO latency bin midpoint vs upper limit capture
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: fio <fio@vger.kernel.org>

That is how the tool does by default unless it has been changed in the
3.0+ versions where there are no bins but  completion time vs iops
landing in that zone.
If I recall prior to 3.0, it was bins -> 0 , 1 ...12xx.

On Wed, Mar 21, 2018 at 10:59 AM, Kris Davis <Kris.Davis@wdc.com> wrote:
> What are you doing to see a "report" of the mid latency?
>
> Kris Davis
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of abhishek koundal
> Sent: Wednesday, March 21, 2018 12:55 PM
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
