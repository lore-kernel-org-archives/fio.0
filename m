Return-Path: <axboe@kernel.dk>
Date: Thu, 3 Mar 2016 09:16:03 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Specify range and distribution of accesses
Message-ID: <20160303161603.GB22164@kernel.dk>
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Feb 26 2016, Jeff Furlong wrote:
> Hi All,
> I'm looking for a method to distribute access to certain ranges of a
> block device.  For example, the JESD219 workload
> (http://www.jedec.org/sites/default/files/docs/JESD219.pdf) specifies 
> 
> The workload shall be distributed across the SSD such that the following is achieved:
> 1) 50% of accesses to first 5% of user LBA space (LBA group a)
> 2) 30% of accesses to next 15% of user LBA space (LBA group b)
> 3) 20% of accesses to remainder of user LBA space (LBA group c)
> 
> I do not currently see any fio options to allow such usage.  Perhaps
> if --size or --iosize is updated to allow ranges/distributions, it may
> be possible?
> 
> The JESD219 workload also specifies a distribution of block sizes,
> which can already be accomplished in fio with --bssplit, such as
> --bssplit=4k/10:64k/50:32k/40.  Perhaps extending that usage to --size
> or --iosize may solve the issue?
> 
> The above link for the JESD219 workload includes a vdbench script to
> produce the desired workload, but I'm hesitant to think that vdbench
> does something that fio cannot.  Has anyone been able to specify
> ranges and distributions of accesses in any other way?  Thanks.

There's no straight forward way to do that, I'm afraid. Might be
possible to do with a somewhat convoluted use of the existing
options. Would be a useful addition, however, to be able to do this in a
logical manner. I'll think about it a bit, would require some
abstraction around zoning of a fio_file.

-- 
Jens Axboe


