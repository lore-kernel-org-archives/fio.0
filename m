Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51409
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab3DXRTT (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 24 Apr 2013 13:19:19 -0400
Date: Wed, 24 Apr 2013 11:19:16 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: issue with fio on drbd
Message-ID: <20130424171916.GL2354@kernel.dk>
References: <zarafa.5177c85e.7c48.0e2449823a651c6d@blurr.ahrensburg.gg-net.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zarafa.5177c85e.7c48.0e2449823a651c6d@blurr.ahrensburg.gg-net.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tim Rohwedder <tim.rohwedder@gg-net.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Apr 24 2013, Tim Rohwedder wrote:
> Hello,
> 
> i'm getting  unexpected results benchmarking our new storages bandwidth running XFS in a DRBD RAID 1 over Ethernet.
> 
> The two peers are connected via DRBD 8.3 on Debian Wheezy x64.
> I'm running Fio 2.0.8
> The hardware is a hybrid RAID10 on an adaptec 71605Q. Build of 2x 3TB Seagate Conestellation CS SED and 2x Samsung 840 500GB.
> 
> My jobfile:
>  [global]
> disable_lat=1
> disable_clat=1
> disable_slat=1
> clat_percentiles=0
> direct=1
> buffered=0
> create_on_open=1
> 
> [randrw]
> filename=rand.fio
> rw=randrw
> size=1g
> runtime=180
> stonewall
> 
> [randwrite]
> filename=rand.fio
> rw=randwrite
> size=1g
> runtime=180
> stonewall
> 
> [seqwrite]
> filename=seq.fio
> rw=write
> size=2g
> runtime=180
> stonewall
> 
> [dualseqwrite]
> filename=seq.fio
> rw=write
> size=2g
> numjobs=2
> runtime=180
> stonewall
> 
> [seqread]
> filename=seq.fio
> rw=read
> size=2g
> runtime=180
> stonewall
> 
> I'm only measuring the bandwidth.
> 
> The results on the device without drbd are like this:
> Randrw: 5564kb/s
> Randrwr: 5575kb/s
> Randw: 4520kb/s
> Write: 74266kb/s
> Dualwrite thread1: 44761kb/s
> Dualwrite thread2: 44497kb/s
> Read: 74619kb/s
> 
> The moment I start DRBD and set the node to primary the highest result is 500-700kb/s on every test. I tried various performance improving tweaks and even asynchronous sync for drbd.
> 
> Is there any way that these results emerge through the combination of fio and drbd?

You should probably get in touch with the drbd developers about that,
not much I can say about it. This is unlikely to be specific to fio.

-- 
Jens Axboe

