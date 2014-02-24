Return-Path: <fio-owner@vger.kernel.org>
Received: from server506j.appriver.com ([50.56.144.148]:55293 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752815AbaBXQxV convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 24 Feb 2014 11:53:21 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: strange discrepancy
Date: Mon, 24 Feb 2014 16:53:19 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB0C85DB@DAGN05A-E6.exg6.exghost.com>
References: <CAFTxqD9pJB62TkFNAS+Ex=KyS0E=7PWyzWZatFK03ef22yQ7CA@mail.gmail.com>
	<CAFTxqD-PMRbo9M+DsDtZznx9VebYk5t5vbeSyhra3=hQ9Yn1_A@mail.gmail.com>
	<A7A1D348E34E024BBC74480FB93A2EAB0C0919@DAGN05A-E6.exg6.exghost.com>
	<CAFTxqD-HGbv8nYXPKfU_7ct_6jGtbBoX951_=T1tGd-XB9TBYg@mail.gmail.com>
 <CAFTxqD_UdtAqhXPjopzHg6FKw25JPzoE-BeXhSuD9NLRhNMyeg@mail.gmail.com>,<530B57B5.10505@enovance.com>
In-Reply-To: <530B57B5.10505@enovance.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>, "Pal, Laszlo" <vlad@vlad.hu>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


Couple of things-
If you want to test the -storage- system, use async IO with a good size queue depth. Sync will be very slow comparatively.
As mentioned, all tests will run in parallel unless you stonewall them.
Don't make logs that you don't really need; you probably don't need any of those.

Give the HOWTO file a really close read.

z!
writing without full benefit of the morning coffee
