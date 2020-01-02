Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt1-f170.google.com ([209.85.160.170]:35976 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbgABUEh (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Jan 2020 15:04:37 -0500
Received: by mail-qt1-f170.google.com with SMTP id q20so35438853qtp.3
        for <fio@vger.kernel.org>; Thu, 02 Jan 2020 12:04:37 -0800 (PST)
Subject: Re: Running FIO until DUT leaves steadystate
References: <CANbyPNfpV0dazkiyviWs1yZtnGkjC-3zYBZt6QCr2wGgnGv1jw@mail.gmail.com>
 <CALjAwxjuA71m-FdOb=gpFDt8mrgedgcgEikB62gUjv0M248nrA@mail.gmail.com>
 <06dee952d2214867863d4423127553b8@AUSX13MPS306.AMER.DELL.COM>
 <CALjAwxg03oE0h43NX7PSz7qxe4VWkoUwxMQ0YO32X7fUxnyAtg@mail.gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Message-ID: <299afd0f-3fb2-7aa7-4af5-007da387699e@gmail.com>
Date: Thu, 2 Jan 2020 15:04:35 -0500
MIME-Version: 1.0
In-Reply-To: <CALjAwxg03oE0h43NX7PSz7qxe4VWkoUwxMQ0YO32X7fUxnyAtg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, Charles.Colburn@dell.com
Cc: Mike Kingsbury <mike.kingsbury@cacheio.com>, fio <fio@vger.kernel.org>

On 12/29/19 4:16 PM, Sitsofe Wheeler wrote:
> (CC'ing Vincent for comment)
> 
> On Thu, 19 Dec 2019 at 17:34, <Charles.Colburn@dell.com> wrote:
>>
>> Sitsofe
>>
>> Is there an example of using the steadystate option to do random preconditioning of and SSD? - I assume that is what it is for. I tried to use the featured a while back but never got it to work as expected.
>>
>> Chuck Colburn
>>
>>
>>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf Of Sitsofe Wheeler
>> Sent: Thursday, December 19, 2019 1:11 AM
>> To: Mike Kingsbury
>> Cc: fio
>> Subject: Re: Running FIO until DUT leaves steadystate
>>
>>
>> [EXTERNAL EMAIL]
>>
>> Hi,
>>
>> On Fri, 13 Dec 2019 at 16:29, Mike Kingsbury <mike.kingsbury@cacheio.com> wrote:
>>>
>>> Reading through the docs and looked at some examples, its not clear if
>>> its possible to accomplish this. In our case, we're attempting to
>>> evaluate SSDs and determine when they start internal garbage
>>> collection and how much performance drops.  Is there a way to detect
>>> steadystate, and then exit when the DUT performance leaves that
>>> steadystate?
>>
>> Not really. You can use the steadystate option (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-steadystate
>> ) to try and determine when you're in the steadystate but then you're kind of stuck. Maybe once you knew what expected latencies were, you could then use max_latency (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-max-latency
>> ) to allow a job to exit if one got obviously too high? You would have to do a fair bit of intermediate storage and processing to make this work and it's not clear how reliable it would be though...
> 

Chuck, I don't understand why one would need to engage steady state 
detection to randomly precondition an SSD. Why not just use an LFSR to 
write the device's logical capacity? Is there something you mean by 
"random preconditioning" that isn't being communicated to me?

Mike, as for your original question, I do not believe that the 
steadystate feature is suitable for detecting when garbage collection 
has started. Garbage collection presumably will begin at the point where 
the total amount of write IO approaches the device's physical capacity.

Vincent

