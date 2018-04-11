Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:51115 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbeDKIx2 (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Wed, 11 Apr 2018 04:53:28 -0400
Subject: Re: help about how to use latency options
References: <1df8fc47-5ac6-fa99-ee0b-16abfc6a76bb@suse.com>
 <CAFx+24URv6jkah0rqkcyccA8uQ9+PBSnODUg3S3P-QsFY3+e4g@mail.gmail.com>
From: Larry Chen <lchen@suse.com>
Message-ID: <3a6cf9f6-ee23-0f9a-8d6f-e3fc35a03eb2@suse.com>
Date: Wed, 11 Apr 2018 16:53:16 +0800
MIME-Version: 1.0
In-Reply-To: <CAFx+24URv6jkah0rqkcyccA8uQ9+PBSnODUg3S3P-QsFY3+e4g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?5L2V6JKZ?= <mengh.1988@gmail.com>
Cc: fio@vger.kernel.org

Hi 何蒙,

Thanks for your reply, your explain on latency_window is excellent.

The docs says it "will attempt to find the max performance point",
but it doesn't say any attempt to make some changed to fit in the 
latency_target.

Thanks
Larry


On 04/11/2018 03:28 PM, 何蒙 wrote:
> Hi Larry
> It is my understanding that:
> If latency_target=100ms, latency_target=90, fio will attempt to make 
> 90% of all IOs lower than latency_target，
> If lantency_window=1s，fio will calculate all IOs in the 1st second，if 
> don't meet the target (90% latency less than 100ms)
> fio will do some changes to meet the target in next seconde.
>
> 2018-04-11 14:48 GMT+08:00 Larry Chen <lchen@suse.com 
> <mailto:lchen@suse.com>>:
>
>     Hi list,
>
>     I referred to the docs and examples but I'm still hard to
>     understand how to use latency_target, latency_window and
>     latency_percentile.
>     Could any one help explain it in detail?
>     Thanks in advance
>
>     Sorry for that this letter might be resent to the list because my
>     misoperation of subscribing fio mail list.
>
>     Regards,
>     Larry
>     --
>     To unsubscribe from this list: send the line "unsubscribe fio" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>     <http://vger.kernel.org/majordomo-info.html>
>
>

