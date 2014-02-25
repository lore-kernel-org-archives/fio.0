Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40540 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaBYCRJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 24 Feb 2014 21:17:09 -0500
Received: by mail-vc0-f177.google.com with SMTP id if11so6599363vcb.36
        for <fio@vger.kernel.org>; Mon, 24 Feb 2014 18:17:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFTxqD_AivDhzqnM+seeSAzB=0G3GCint+_ezXVkZFJuCxDPwQ@mail.gmail.com>
References: <CAFTxqD9pJB62TkFNAS+Ex=KyS0E=7PWyzWZatFK03ef22yQ7CA@mail.gmail.com>
	<CAFTxqD-PMRbo9M+DsDtZznx9VebYk5t5vbeSyhra3=hQ9Yn1_A@mail.gmail.com>
	<A7A1D348E34E024BBC74480FB93A2EAB0C0919@DAGN05A-E6.exg6.exghost.com>
	<CAFTxqD-HGbv8nYXPKfU_7ct_6jGtbBoX951_=T1tGd-XB9TBYg@mail.gmail.com>
	<CAFTxqD_UdtAqhXPjopzHg6FKw25JPzoE-BeXhSuD9NLRhNMyeg@mail.gmail.com>
	<530B57B5.10505@enovance.com>
	<A7A1D348E34E024BBC74480FB93A2EAB0C85DB@DAGN05A-E6.exg6.exghost.com>
	<A7A1D348E34E024BBC74480FB93A2EAB0CA6EB@DAGN05A-E6.exg6.exghost.com>
	<CAFTxqD_AivDhzqnM+seeSAzB=0G3GCint+_ezXVkZFJuCxDPwQ@mail.gmail.com>
Date: Mon, 24 Feb 2014 18:17:08 -0800
Message-ID: <CAF+0mvk_xcspdFraAWbHt5RP1iFNWfMLuAfWi_J=Pq_Qn_Yzpg@mail.gmail.com>
Subject: Re: strange discrepancy
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Pal, Laszlo" <vlad@vlad.hu>
Cc: Carl Zwanzig <cpz@coraid.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Feb 24, 2014 at 12:30 PM, Pal, Laszlo <vlad@vlad.hu> wrote:
> Thank you. The workload is mixed read / write , small and big packets,
> and I have raid1 sets in one of the box and raid50 in the big boy. I
> suppose using the iodepth=32 will show me more realistic numbers than
> my original tests. Is this a valid assumption if I increase iodepth
> until I get bigger IOPS values will get me closer and closer to the
> maximum IOPS can provide the config?
>
> Thank you
> Laszlo

You'll want to experiment with different iodepths and use whatever
gives you the best results.  And if you're looking to get a max IOPS
you probably want to stick to 4k transfers.

I would try something like this:

[global]
ioengine=libaio
direct=1
iodepth=128
size=50g
runtime=5m
directory=/mnt/drbd/private/

[random_write]
rw=randwrite
bs=4k
stonewall

[random_read]
rw=randread
bs=4k
stonewall

[seq_write]
rw=write
bs=128k
stonewall

[seq_read]
rw=read
bs=128k
stonewall
