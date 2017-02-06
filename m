Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45755 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752115AbdBFWFN (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Feb 2017 17:05:13 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1carPE-0004ZA-SO
        for fio@vger.kernel.org; Mon, 06 Feb 2017 23:05:04 +0100
From: Slow bucks <frankwhitebe@gmail.com>
Subject: Re: fio exit run on timeout of device?
Date: Mon, 6 Feb 2017 16:01:45 -0600
Message-ID: <o7aro3$gmq$1@blaine.gmane.org>
References: <o72kkc$v07$2@blaine.gmane.org> <CALjAwxiuMVc3tMpb6U5Jw=i+szdj+hwY1gsV_5HmcW1mRr=AaA@mail.gmail.com> <o72pn8$7ip$1@blaine.gmane.org> <CALjAwxgStfwH=9kP95g+JctZpunRZ_+zWN2kbzLgXBXLD7ytwQ@mail.gmail.com> <o73g1o$ioa$1@blaine.gmane.org> <CALjAwxiBCU0a0TMFGNO1-55W2c-ohXwOdX92K4s0_YMvT_hHbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Thanks!
On 2017-02-04 07:41:33 +0000, Sitsofe Wheeler said:

> Hi,
> 
> The answer to that is within the value "1s" itself :-) See
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-max_latency
> and http://fio.readthedocs.io/en/latest/fio_doc.html#parameter-types
> for why.
> 
> On 4 February 2017 at 02:59, Slow bucks 
> <frankwhitebe@gmail.com> wrote:
>> max_latency=1s -> Is that in seconds or milliseconds?
>> 
>> On 2017-02-03 22:44:31 +0000, Sitsofe Wheeler said:
>> 
>>> max_latency=1s



