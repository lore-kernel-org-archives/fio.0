Return-Path: <fio-owner@vger.kernel.org>
Received: from server506c.appriver.com ([50.56.144.127]:54172 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988AbaBXUQc convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 24 Feb 2014 15:16:32 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: strange discrepancy
Date: Mon, 24 Feb 2014 20:16:30 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB0CA6EB@DAGN05A-E6.exg6.exghost.com>
References: <CAFTxqD9pJB62TkFNAS+Ex=KyS0E=7PWyzWZatFK03ef22yQ7CA@mail.gmail.com>
	<CAFTxqD-PMRbo9M+DsDtZznx9VebYk5t5vbeSyhra3=hQ9Yn1_A@mail.gmail.com>
	<A7A1D348E34E024BBC74480FB93A2EAB0C0919@DAGN05A-E6.exg6.exghost.com>
	<CAFTxqD-HGbv8nYXPKfU_7ct_6jGtbBoX951_=T1tGd-XB9TBYg@mail.gmail.com>
 <CAFTxqD_UdtAqhXPjopzHg6FKw25JPzoE-BeXhSuD9NLRhNMyeg@mail.gmail.com>,<530B57B5.10505@enovance.com>
 <A7A1D348E34E024BBC74480FB93A2EAB0C85DB@DAGN05A-E6.exg6.exghost.com>
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB0C85DB@DAGN05A-E6.exg6.exghost.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Pal, Laszlo" <vlad@vlad.hu>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

> From: Pal, Laszlo [mailto:vlad@vlad.hu] 
> Sent: Monday, February 24, 2014 11:27 AM

> thank you. if I stonewalling sync engine is a good approach ? The main goal is to tell our customers what iops they have to provide to get the same or similar io performance as they have when using the appliances.

I'm not sure what you're asking. If you're trying to model a specific workload, well, you have to define what that workload is. If you're trying to see how fast the storage system itself can go, then the tests you've listed are rational -provided- that you don't run them in parallel ('stonewall') and that you don't limit yourself at the client (by using sync i/o).

On the systems I test, I can see a great improvement in the throughput of RAID volumes by increasing the iodepth. Think of it, with sync i/o (iodepth=1) you're doing one operation at a time and to only one drive*. If you have 8 drives in a RAID-0 set, -each- drive can be doing something at the same time, but with iodepth<8, that'll never happen. Likewise, assuming modern drives, each drive can queue up some operations internally and optimize head movement. This also improves performance.  (I usually use iodepth=32 or higher; on linux.)

*I'm ignoring parity RAID configs where each write to the RAID set causes reads and writes to the entire volume. Nothing will help you there :).

z!

