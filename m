Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34556 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbdBFV5x (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Feb 2017 16:57:53 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1carIA-0003JB-8o
        for fio@vger.kernel.org; Mon, 06 Feb 2017 22:57:46 +0100
From: Slow bucks <frankwhitebe@gmail.com>
Subject: Re: randrepeat false for ssds
Date: Mon, 6 Feb 2017 15:57:44 -0600
Message-ID: <o7argi$b4c$1@blaine.gmane.org>
References: <o7a678$p7c$1@blaine.gmane.org> <CALjAwxhRGvFh=t60=OJ6s0dpuJ=z1waPQF=OpKVZZtwsjZtaOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

My primary objective is to really have consistent results with the same 
jobfile with any ssd drive test.
It sounds like setting randrepeat to false makes sense for ssd drives

On 2017-02-06 20:14:18 +0000, Sitsofe Wheeler said:

> Depends on your objective (are you trying to dodge tricks your SSD
> might do?) but bear in you can't control where the SSD ultimately
> chooses to put the data or how much it chooses to stuff into each
> erase block size. Additionally randrepeat only has an impact when an
> entire run is repeated. Some modern SSDs do compression/de-duplication
> so if you want to try defeat that you might want to look at the
> refill_buffers/scramble_buffers parameters
> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-refill_buffers
> ).
> 
> On 6 February 2017 at 15:54, Slow bucks 
> <frankwhitebe@gmail.com> wrote:
>> Does it make sense to disable randrepeat on SSDs with the way data is
>> written (always write to new block with empty pages)?
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



