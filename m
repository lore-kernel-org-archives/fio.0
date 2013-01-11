Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50665 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3AKJLt (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Jan 2013 04:11:49 -0500
Date: Fri, 11 Jan 2013 10:11:46 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Running Fio to Particular LBA's
Message-ID: <20130111091146.GB32674@kernel.dk>
References: <CANUChTws0KGNRVQ=N_WH70LeoN-Kv2V6wjFbnf_VCA4OU9D8wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUChTws0KGNRVQ=N_WH70LeoN-Kv2V6wjFbnf_VCA4OU9D8wQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Fri, Jan 11 2013, Gavin Martin wrote:
> I'm using Fio to run to raw devices in both Linux & Windows, one thing
> that I am unable to do is to specify an LBA range to run to.
> 
> I know that there are the 'zonesize' and 'zoneskip' arguments, but I'm
> struggling to see how they work. In essence I would like to have a
> number of jobs running to different parts of the disk.
> 
> In a basic example:  from LBA 0 to 1/2 of MaxLBA I would like to run a
> sequential workload and from 1/2 MaxLBA+1 to MaxLBA I would like to
> run a random workload.
> 
> Can this be done with existing arguments?

If maxlba is 10G, then you would do:

[global]
size=5G

[seq]
offset=0
rw=write

[rand]
offset=5G
rw=randwrite

Fill in other parameters as needed

-- 
Jens Axboe

