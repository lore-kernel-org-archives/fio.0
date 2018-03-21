Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:42867 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753029AbeCUUqy (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Mar 2018 16:46:54 -0400
Received: by mail-io0-f180.google.com with SMTP id d5so8267282iob.9
        for <fio@vger.kernel.org>; Wed, 21 Mar 2018 13:46:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB11165355ED1A3A585208B0B081AA0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CAKwzdDrOufV5HjdN3=+Hvr1vbnUrgM8U5G=9Wuk1Lh_kjAiFCw@mail.gmail.com>
 <CAKwzdDqnZE_cEe61Hx-GCzTuc+MDwzpqD_JVwTZF4ky_znNnFA@mail.gmail.com>
 <CY1PR0401MB1116B7900CB55CC67D8CF9F781AA0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CAKwzdDqnvbRchbKBQ8RK4HMeaDs_qNYYyEcPogna-kcHKhNb6Q@mail.gmail.com> <CY1PR0401MB11165355ED1A3A585208B0B081AA0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 21 Mar 2018 13:46:13 -0700
Message-ID: <CAKwzdDotMCruY0XS-xEF6BsJxpXvLE-NpO_i5GyZ+dK1NkgkHg@mail.gmail.com>
Subject: Re: FIO latency bin midpoint vs upper limit capture
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: fio <fio@vger.kernel.org>

Hi Kris,
I am mentioning for the bins that get generated in the json+ fille or
the clat_hist files. Clat_hit still has all the bins listed even if
they are empty while JSON+ now just fills/reports which are being seen
for a given run.

FIO 3.1+.
bins
6816 = 1  ==> 6816ns  1 IOP took.
7817 = 10 ==> 7817ns 10 IOP took ..
.......

FIO2.18
bins
0 = 1  ==> 1us 1 IOP took
1 = 50 ==> 2us 50 IO took
......
1216 = x

When the tool reports the IOP completion latency for the given bin, it
will report it as the "median" value of time not the "max" value of
the time. So when you are plotting or reporting the data that is not
the "max" value of the latency for that reported bin.

This will result in two things:
1) multiple runs on the same workload config will have deviations .
2) higher deviation will be observed for the 5-9s + if you use the
"max" value wrt to "median".

I hope this helps in clearing the things and clear the confusion.

On Wed, Mar 21, 2018 at 12:17 PM, Kris Davis <Kris.Davis@wdc.com> wrote:
> I'm sorry, I don't think I'm on the same page...  Are you referring to the latency percentages given in the summary output, or the latency log files, or the clat hist log file?
> Thanks
>
> Kris Davis
> Western Digital Coporation
> Email: kris.davis@wdc.com
> Office:: +1-507-322-2376
>
> -----Original Message-----
> From: abhishek koundal [mailto:akoundal@gmail.com]
> Sent: Wednesday, March 21, 2018 2:00 PM
> To: Kris Davis <Kris.Davis@wdc.com>
> Cc: fio <fio@vger.kernel.org>
> Subject: Re: FIO latency bin midpoint vs upper limit capture
>
> That is how the tool does by default unless it has been changed in the 3.0+ versions where there are no bins but  completion time vs iops landing in that zone.
> If I recall prior to 3.0, it was bins -> 0 , 1 ...12xx.
>
> On Wed, Mar 21, 2018 at 10:59 AM, Kris Davis <Kris.Davis@wdc.com> wrote:
>> What are you doing to see a "report" of the mid latency?
>>
>> Kris Davis
>>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of abhishek koundal
>> Sent: Wednesday, March 21, 2018 12:55 PM
>> To: fio <fio@vger.kernel.org>
>> Subject: Re: FIO latency bin midpoint vs upper limit capture
>>
>> Checking back if there is any feedback on the above request for reporting max latency in the bins.
>> Appreciate the support.
>>
>> On Wed, Mar 14, 2018 at 2:07 PM, abhishek koundal <akoundal@gmail.com> wrote:
>>> All,
>>> Currently the FIO latency  bins does the i/o count and but then as
>>> per Lower bound, midpoint (rounded off), upper limit
>>>
>>> The reported latency is the based on the "midpoint".
>>> Is there a way to report it based on the "upper limit"? e.g. compile
>>> fio with some switch etc.
>>>
>>> Appreciate your support always :).
>>>
>>> --
>>> Life is too short for silly things so invest your time in some
>>> productive outputs!!
>>
>>
>>
>> --
>> Life is too short for silly things so invest your time in some productive outputs!!
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in the
>> body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Life is too short for silly things so invest your time in some productive outputs!!



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
