Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab1IAOTw (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Sep 2011 10:19:52 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Linux I/O stack design question
References: <1314880418.11001.6.camel@werner-t410>
Date: Thu, 01 Sep 2011 10:19:50 -0400
In-Reply-To: <1314880418.11001.6.camel@werner-t410> (Werner Fischer's message
	of "Thu, 01 Sep 2011 14:33:38 +0200")
Message-ID: <x494o0w1h15.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Werner Fischer <devlists@wefi.net> writes:

> Dear fio users and developers,
>
> I have a question regarding the Linux I/O stack (not directly regarding
> fio, but I think fio user's and developers have a lot of knowledge
> here):
>
> I'm trying to better understand the different layers of the Linux I/O
> stack and how they play together. So I have started a diagram showing
> the different layers of the I/O stack:
> http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png
>
> Is this diagram correct or are there any errors in there?

That's a nice diagram.  :)  A few of things of note:
1) O_DIRECT I/O can bypass the page cache
2) request-based dm targets sit below the I/O scheduler (currently, that
   just means dm-multipath)
3) the fusion IO device driver can hook itself in where you put it, or
   also up above the I/O scheduler (based on a module load option).
4) not sure if you want to cover I/O directly to the device (no file
   system involved)

Cheers,
Jeff
