Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40832 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdBCUiQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2017 15:38:16 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1cZkcR-0002Fc-Oz
        for fio@vger.kernel.org; Fri, 03 Feb 2017 21:38:07 +0100
From: Slow bucks <frankwhitebe@gmail.com>
Subject: Re: fio exit run on timeout of device?
Date: Fri, 3 Feb 2017 14:38:07 -0600
Message-ID: <o72pn8$7ip$1@blaine.gmane.org>
References: <o72kkc$v07$2@blaine.gmane.org> <CALjAwxiuMVc3tMpb6U5Jw=i+szdj+hwY1gsV_5HmcW1mRr=AaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The engine is libaio.  thoughts anyone?

On 2017-02-03 19:39:12 +0000, Sitsofe Wheeler said:

> Hi,
> 
> Good question. From what I've seen, at the moment it partially depends
> on the ioengine. If I/Os somehow timeout from below you might be able
> to use max_latency. If they just hang indefinitely the engine can be
> become stuck waiting forever..
> 
> On 3 February 2017 at 19:11, Slow bucks 
> <frankwhitebe@gmail.com> wrote:
>> Is there a way to tell FIO to immediately exit if a device times out or
>> hangs during a run?
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



