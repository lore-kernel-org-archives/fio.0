Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:54116 "EHLO
        wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934168AbdGTHUm (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 20 Jul 2017 03:20:42 -0400
Subject: Re: iSCSI write performance issues
References: <8b6ac1f2-a6e6-54a2-a439-339df8860e55@bisect.de>
 <CALjAwxi_CdQ1ffu8zADbiKof_c4Q0cTrDax1LWUZzL+onDbhQA@mail.gmail.com>
 <6528223f-0962-240c-2ded-5799412131ae@bisect.de>
Reply-To: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
From: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Message-ID: <4670b734-04c1-dcc6-9b84-19e835967aa0@bisect.de>
Date: Thu, 20 Jul 2017 09:20:40 +0200
MIME-Version: 1.0
In-Reply-To: <6528223f-0962-240c-2ded-5799412131ae@bisect.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Am 20.07.2017 um 07:49 schrieb Danny Al-Gaaf:
> Am 19.07.2017 um 23:16 schrieb Sitsofe Wheeler:
[..]
>> Is fio's output (see "And finally, the disk statistics are printed" in
>> http://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
>> ) saying that merges took place?
> 
> No, it says merge=0/248086. Thats why I was puzzled with the situation.
> It seems there is a small bug in fio. I will take a look at it.

My fault: these are read/write merges. Then everything is right.

Danny
