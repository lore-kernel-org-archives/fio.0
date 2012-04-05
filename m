Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58853 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2DEOqH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Apr 2012 10:46:07 -0400
Message-ID: <4F7DB025.10802@kernel.dk>
Date: Thu, 05 Apr 2012 08:45:57 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de> <4F7CA5F1.2050309@kernel.dk> <4F7CABC5.7090109@kernel.dk> <4F7D64D2.2040407@suse.de>
In-Reply-To: <4F7D64D2.2040407@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: fio@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-04-05 03:24, Danny Kukawka wrote:
> Am 04.04.2012 22:15, schrieb Jens Axboe:
>> On 2012-04-04 13:50, Jens Axboe wrote:
>>>> 2) fio 2.0.6 and also the current git tends to fail with this error:
>>
>>>>    fio 2.0.6
>>>>    Starting 1 process
>>>>    fio: iolog.c:242: log_io_piece: Assertion `ipo->len == __ipo->len'
>>>>    failed.:08m:31s]
>>
>>>> It seems that we can prevent it when we use the --size parameter, but we
>>>> would like to prevent the usage of the parameter, if possible
>>
>>> Strangely, I had two reports of this today. Did a bit of digging, and
>>> it's due to this commit:
>>
>>> commit c04e4661e4da3b6079f415897e4507cf8e610c54
>>> Author: Daniel Ehrenberg <dehrenberg@google.com>
>>> Date:   Fri Mar 16 18:54:15 2012 +0100
>>
>>>     time_based: Avoid restarting main I/O loop
>>
>>> I think what is going on here is that your job is time based, and when
>>> we fail getting a new offset, we clear the offset bitmap. But we could
>>> have verifies pending at this point, we'd need to prune this out as
>>> well.
>>
>> Actually, since it happens so rarely, I think the better approach is
>> just to ignore it. I've updated fio to reflect that.
> 
> Btw. I can suppress the error if I add --size with a high number e.g.
> --size=1p.

It'll still happen eventually, it just takes longer. But the fix is
committed, so you should be fine going forward.

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPfbAlAAoJEPfTWPspceCmNBYP/2L5T6H/2rqy7VKEJgSCR+VW
ky/P+kEIPslWPgGK3yyy4A+c/uIaYpXZux2LSeXG0eoEsFNMv4Bp+bHEmm33G9SP
uJMieUK4F0yif0OrSNgeSFLLhYc86t6WgkBZCS+d/KFKH0VfHnUTD+MZY/6O24sd
A6+fXX3xXriYeThkIM+ffzKpsLiH7uxWtRpUN+1n9XhrhOqmIpuRZSOWPdh37R9D
81mbPwnLkicLyknji9jaIiZn7NrXR988wsxumKrPe27+acSg9pE/xbynks3OEBUU
A+LlwNw9//5q0iyF0sxFMmGs5hOp8Fl5atjYwUs9S2R3ZODOgUeONpHO3RNAAwsZ
5446gs+2HwCzZuSpSLbEQa4FSJH8IPV9b2z/RgOpVmMb2dnIuiOKGvpdOhwqikpE
S7TQ1Mq+uF/H+30VyEbnErYoKE7DdfJWok0C7V5yDVlnMQaV8BM+l40jLWfEiH0C
9FcmDKjNeI3imeHIwan/TCcQxLB/QG6RdVt6801bJN8Ol+HdpOiMRiT5yAaECTl0
oBMs5k4MYlcy1dkKOdzBKu7MbXYYzpT42dOzwvtTX6Wq+2SIyPnci/qcBCpEpsjo
of6Arl3mqgimCvtScqZTgeSviGUrkD7JtonYGYDm5MciDtFT8zWCcxnIKq7M9Wot
mXMTCXuPdaajyco2DBiH
=O8h4
-----END PGP SIGNATURE-----
