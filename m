Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:35419 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaBXObU (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 24 Feb 2014 09:31:20 -0500
Message-ID: <530B57B5.10505@enovance.com>
Date: Mon, 24 Feb 2014 15:31:17 +0100
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: strange discrepancy
References: <CAFTxqD9pJB62TkFNAS+Ex=KyS0E=7PWyzWZatFK03ef22yQ7CA@mail.gmail.com>	<CAFTxqD-PMRbo9M+DsDtZznx9VebYk5t5vbeSyhra3=hQ9Yn1_A@mail.gmail.com>	<A7A1D348E34E024BBC74480FB93A2EAB0C0919@DAGN05A-E6.exg6.exghost.com>	<CAFTxqD-HGbv8nYXPKfU_7ct_6jGtbBoX951_=T1tGd-XB9TBYg@mail.gmail.com> <CAFTxqD_UdtAqhXPjopzHg6FKw25JPzoE-BeXhSuD9NLRhNMyeg@mail.gmail.com>
In-Reply-To: <CAFTxqD_UdtAqhXPjopzHg6FKw25JPzoE-BeXhSuD9NLRhNMyeg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Pal, Laszlo" <vlad@vlad.hu>, Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 24/02/2014 12:55, Pal, Laszlo wrote:
> Hi,
>
> I've modified the .fio file according to the suggestions. Now, it
> looks like this
>
>
I'm pretty sure you are making a mistake here.
You shall use the 'stonewall' instruction of your jobs if you want to 
make them one after the other unless you are running all of them at the 
same time.

My genfio script inside the tools/ directory would have surely help you 
avoiding this mistake.... but I'm not yet supporting the filesystems 
with it... I have to spend some time on it.

At least, generate an output with it and change then after the block 
device by your filesystem stuff.

The nice stuff is that genfio is easy to "pipe" with fio2gnuplot. Btw, 
I'm glad some are using it ;o)))

Erwan,
