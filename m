Return-Path: <fio-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:20128 "EHLO mx143.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbbCGSaW convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 7 Mar 2015 13:30:22 -0500
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Rate for write IOPS read IOPS
Date: Sat, 7 Mar 2015 18:30:20 +0000
Message-ID: <133A61B0-5726-46BD-B131-A47ADAFDDC80@netapp.com>
References: <D1208B18.10E7D%Antonio.Jose.Rodrigues.Neto@netapp.com>,<CAM8G_BLSbvr322m7y0Q2Z6vcpFMQyRqALNj3q3LPp-dYFtdSEQ@mail.gmail.com>
In-Reply-To: <CAM8G_BLSbvr322m7y0Q2Z6vcpFMQyRqALNj3q3LPp-dYFtdSEQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>





> On Mar 7, 2015, at 1:25 PM, Kulkarni, Vasu <vasu.kulkarni@gmail.com> wrote:
> 
> Wish one could :) and all the storage vendors will be clueless how fio
> got it :) , IOPS is "Per Second" not "Per Hour or Per Year"
> 
> On Sat, Mar 7, 2015 at 8:01 AM, Neto, Antonio Jose Rodrigues
> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>> Hi All,
>> 
>> This is neto from Brazil
>> 
>> How are you?
>> 
>> I need to generate a workload as:
>> 
>> 45,000 IOPS (write)
>> 7,000  IOPS (read)
>> 
>> I have tried to use rate_iops and rwmixread and rxmixwrite. I was able to
>> rate the workload at 52,000 IOPS but no matter the % value that I use at
>> rwmixread and rwmixwrite, I always have 50/50 read/write.
>> 
>> Is there any way to specify: I want 45,000 IOPS writes and 7,000 IOPS
>> reads.
>> 
>> Thank you,
>> 
>> All the best
>> 
>> neto
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> A ship is safer in a harbor.  But that's not what ships are built for.

Hi Vasu

This is neto from Brazil

How are you?

I am sorry but I did not get your point.

I want to rate the write operations per second to X and read operations per second to Y.

Do you know how to do it?

Thanks

neto