Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab1HaSap (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Aug 2011 14:30:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: fio file test patterns
References: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com>
Date: Wed, 31 Aug 2011 14:30:41 -0400
In-Reply-To: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com>
	(Brian Fallik's message of "Wed, 31 Aug 2011 13:53:23 -0400")
Message-ID: <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brian Fallik <bfallik@bamboom.com>
Cc: fio@vger.kernel.org

Brian Fallik <bfallik@bamboom.com> writes:

> Hi,
>
> Apologies if this is documented somewhere else but I couldn't find it
> in the fio man page, example job files, or list archives.
>
> I'm exploring fio as a testing tool and it seems very well suited for
> my needs.  I'm currently running experiments with N sequential writers
> all writing at 200k.  The jobs file is very simple:
>     [global]
>     size=10m
>     directory=.
>
>     [foo1]
>     rw=write
>     rate=200k
>
>     [foo2]
>     ...
> fio creates various foo* files as part of its test but they all seem
> to contain the same content.  I would have expected fio to generate
> random data in each file to avoid potential optimizations like
> deduplication.   Am I missing the flag to generate random test
> patterns or is this behavior intentional?

       refill_buffers
              If this option is given, fio will refill the IO buffers on every
              submit. The default is to only fill it at init  time and reuse
              that  data.  Only  makes  sense if zero_buffers isn't specified,
              naturally. If data verification is  enabled, refill_buffers is
              also automatically enabled.

Looks like what you want.

Cheers,
Jeff
