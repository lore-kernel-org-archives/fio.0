Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:34540 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbbEVAGp (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 May 2015 20:06:45 -0400
Received: by yhom41 with SMTP id m41so821781yho.1
        for <fio@vger.kernel.org>; Thu, 21 May 2015 17:06:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555C752C.20806@micxer.de>
References: <55551D18.2000405@micxer.de>
	<CALjAwxgWOokmtXWtN3GvZnvNoC-FTCJX=c3xFiuH5PrB97_kBw@mail.gmail.com>
	<55590055.1080005@micxer.de>
	<CALjAwxjze_LWfTgp=PTn3uOfYwF_cUq3uDZoB1Q8QffCwpdojQ@mail.gmail.com>
	<555C752C.20806@micxer.de>
Date: Thu, 21 May 2015 17:06:44 -0700
Message-ID: <CAKXScpWbCQ_ASFutzWNMPcjyDUHVnGg_LauDAVSV7z5WBhyNvQ@mail.gmail.com>
Subject: Re: Testing write master and multiple read clients on NFS share
From: "danielabuggie ." <danielabuggie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael Weinrich <micxer@micxer.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

I'd add the time_based option in there.  May not be needed now but if
you start tweaking things it could come up later.

Daniel

On Wed, May 20, 2015 at 4:51 AM, Michael Weinrich <micxer@micxer.de> wrote:
> Yeah, well, I needed a process that writes to the same files the others are
> reading from to somehow simulate expiring local caches (and to see, if NFS
> handles that the right way). And yes, it took me quite some time to dig
> through most of the options to tailor the tests to my needs
>
> But I'm also glad to hear, that it doesn't look completely wrong for a first
> try :-)
>
>
> Am 20.05.2015 um 11:03 schrieb Sitsofe Wheeler:
>>
>> On 17 May 2015 at 21:55, Michael Weinrich <micxer@micxer.de> wrote:
>>>
>>> Thanks for the hint. I also found another mistake in limiting the reads
>>> and
>>> writes where I only wanted to limit the writes and have the reads as fast
>>> as
>>> possible. But in general this is a viable approach to my problem?
>>
>> I can't say for sure whether it models your workload (your example
>> made use of options I had to look up!) but it does look like an
>> interesting approach...
>>
>
>
