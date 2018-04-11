Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:54821 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752754AbeDKJBy (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Wed, 11 Apr 2018 05:01:54 -0400
Subject: Re: help about how to use latency options
References: <1df8fc47-5ac6-fa99-ee0b-16abfc6a76bb@suse.com>
 <CALjAwxj56y_2eFaqz0aXpT3Pixgcy2QGgndhqTmnwB9g4ixj3w@mail.gmail.com>
From: Larry Chen <lchen@suse.com>
Message-ID: <86719d5b-6a45-91f5-112a-d95d5159ff05@suse.com>
Date: Wed, 11 Apr 2018 17:01:42 +0800
MIME-Version: 1.0
In-Reply-To: <CALjAwxj56y_2eFaqz0aXpT3Pixgcy2QGgndhqTmnwB9g4ixj3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Sitsofe,
Thanks for your explain.
I found that if latency_target is specified, latency_window must be 
along with latency_target option.
If not, fio will exit immediately.
Why the case is like that?

Thanks
Larry

On 04/11/2018 03:59 PM, Sitsofe Wheeler wrote:
> Hi,
>
> On 11 April 2018 at 07:48, Larry Chen <lchen@suse.com> wrote:
>> I referred to the docs and examples but I'm still hard to understand how to
>> use latency_target, latency_window and latency_percentile.
>> Could any one help explain it in detail?
>> Thanks in advance
>>
>> Sorry for that this letter might be resent to the list because my
>> misoperation of subscribing fio mail list.
> These options are used to probe the highest iodepth usable such that
> the I/Os still have a latency equal to or below that of latency_target
> on the basis that more asynchronous I/Os being sent at the same time
> the higher each I/Os latency will be (this is what
> http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-latency-window
> is trying to say). latency_window controls the time window that I/Os
> are considered over. latency_percentile is used to adjust the
> sensitivity to outlier I/Os during this process so a single moment
> high spike is ignored.
>
> Any clearer?
>

