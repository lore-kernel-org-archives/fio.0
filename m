Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod7og127.obsmtp.com ([64.18.2.210]:59291 "HELO
	exprod7og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756985Ab1HaSB4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Aug 2011 14:01:56 -0400
Received: by mail-yi0-f47.google.com with SMTP id 28so827431yia.20
        for <fio@vger.kernel.org>; Wed, 31 Aug 2011 11:01:55 -0700 (PDT)
MIME-Version: 1.0
From: Brian Fallik <bfallik@bamboom.com>
Date: Wed, 31 Aug 2011 13:53:23 -0400
Message-ID: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com>
Subject: fio file test patterns
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Apologies if this is documented somewhere else but I couldn't find it
in the fio man page, example job files, or list archives.

I'm exploring fio as a testing tool and it seems very well suited for
my needs.  I'm currently running experiments with N sequential writers
all writing at 200k.  The jobs file is very simple:
    [global]
    size=10m
    directory=.

    [foo1]
    rw=write
    rate=200k

    [foo2]
    ...
fio creates various foo* files as part of its test but they all seem
to contain the same content.  I would have expected fio to generate
random data in each file to avoid potential optimizations like
deduplication.   Am I missing the flag to generate random test
patterns or is this behavior intentional?

I'm currently using fio 1.57.

Thanks,
brian
