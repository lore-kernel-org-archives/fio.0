Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:59313 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbaCQAfc convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 16 Mar 2014 20:35:32 -0400
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Compressible and Dedupable ratios using fio
Date: Mon, 17 Mar 2014 00:13:31 +0000
Message-ID: <CF4BB600.4797%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <CF43A47E.293D5%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CAF+0mv=suTk2XbOuRyhfVyKFVAjk5mhfpawwqP5Nb7BeQKTu0g@mail.gmail.com>
In-Reply-To: <CAF+0mv=suTk2XbOuRyhfVyKFVAjk5mhfpawwqP5Nb7BeQKTu0g@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D077A75B8DEE340BF32F13E745828AA@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>



On 3/16/14, 7:53 PM, "Matthew Eaton" <m.eaton82@gmail.com> wrote:

>On Mon, Mar 10, 2014 at 2:18 PM, Neto, Antonio Jose Rodrigues
><Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>> Hi All,
>>
>> This is neto from Brazil
>>
>> How are you?
>>
>> I need to know how to control the % of compression and deduplication
>>using
>> fio?
>>
>> My idea is to generate some workload based on:
>>
>> Workload Random
>> 0% compressible and 0% dedupable
>>
>> Workload Mixed
>> 20% compressible and 20% dedupable
>>
>> Workload Easier
>> 100% compressible and 100% dedupable
>>
>> Could you please help me?
>>
>> Thank you very much,
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
>Hi Neto,
>
>Have you tried using buffer_compress_percentage?  Setting this to 100
>would get you 100% compressible data while 0 would be 0% compressible.
> Note that if you use fio prior to version 2.1.6 in git, you will also
>want to set scramble_buffers=0 to get the desired compression.
>
>I don't know how you would control how dedupable the data is, since to
>my knowledge there is no way to specify how repeatable the data
>pattern is.  But I think fully incompressible data is naturally not
>dedupable, while the opposite is true for fully compressible data.

Hi Matthew,

This is neto from Brazil

How are you?

Thank you very much for your reply.

I will try to do some tests this week and I will share the results.

Thanks again,

All the best,

neto

