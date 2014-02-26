Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57915 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaBZQPF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Feb 2014 11:15:05 -0500
Date: Wed, 26 Feb 2014 16:15:01 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: fio replay
Message-ID: <20140226161451.GA26792@sucs.org>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <20140226153017.GA31124@sucs.org>
 <e7ef163bab6c4f72a53926e0ef9f5ffd@BN1PR07MB437.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ef163bab6c4f72a53926e0ef9f5ffd@BN1PR07MB437.namprd07.prod.outlook.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Cc: David Nellans <david@nellans.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Feb 26, 2014 at 03:48:54PM +0000, Lamkin, Eric wrote:
> 
> Were you replaying on the same host where the blktrace was recorded?

Yes I was.

> I am not.

So long as the target block device is big enough I would hope it would
not make a difference so long as you were using replay_redirect . It
definitely works for me using different devices.

> I'll try with no --iodepth command.  That is all I see different
> between your methodology and mine.

That should not make a difference other than making things slower. The
real command I'm using is
fio --read_iolog=sdd.dump --ioengine=libaio --iodepth=10 --direct=1 --thinktime=15000 --thinktime_blocks=16 --replay_no_stall=1 --replay_redirect=/dev/sdf --name=replay

> What is btreplay?  Does it allow device mapping if the traced devices
> have different names on the replay host?  Will btreplay run
> unconstrained by the original timings?

This is a bit off topic but I'll take stab at answering anyway.
btreplay "recreate[s] IO loads recorded by blktrace"
(http://linux.die.net/man/8/btreplay ). Usage is as follows:
blktrace -d /dev/sdd
btrecord sdd
btreplay sdd 

Device mappings are supported using the -M/--map-devs option. It can be
made to go as fast as possible by using the -N/--no-stalls option.

You may also want to look at blkreplay by Thomas Schoebel-Theuer of 1&1.

-- 
Sitsofe | http://sucs.org/~sits/
