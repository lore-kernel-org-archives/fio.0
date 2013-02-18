Return-Path: <gschoenberger@thomas-krenn.com>
Date: Mon, 18 Feb 2013 09:37:50 +0100 (CET)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>
Message-ID: <617220590.349712.1361176670900.JavaMail.root@thomas-krenn.com>
In-Reply-To: <20130218080829.GC6003@kernel.dk>
Subject: Re: How to get IOPS when using terse output
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Peter Xu <xzpeter@gmail.com>
List-ID: <fio@vger.kernel.org>

----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "Peter Xu" <xzpeter@gmail.com>
> Cc: fio@vger.kernel.org
> Sent: Monday, 18 February, 2013 9:08:29 AM
> Subject: Re: How to get IOPS when using terse output
> 
> On Wed, Feb 13 2013, Peter Xu wrote:
> > Hi, all,
> > 
> > I failed to find IOPS results for read/write under terse mode (with
> > --minimal param when invoking fio program), while IOPS does exist
> > in normal
> > output without --minimal param.
> > 
> > It seems that I even cannot calculate it out only with the tersed
> > output
> > (since I don't know the total number of IO). Then, how should I get
> > IOPS
> > results when using terse output?
> 
> As Carl mentions, the IOPS are there. But let me make a suggestion to
> move over to the json format instead. It's easy to parse by computers
> and humans, and new performance metrics can be added without causing
> breakage in existing setups. The minimal/csv format is somewhat
> fragile
> for that.
> 
> That said, IOPS is there in the minimal output :-)
> 
> --
> Jens Axboe
> 
Maybe you consider that version 3 of the terse output is only used since Fio version 2.0.3!
Before that I think that IOPS are not in the terse output (http://freecode.com/projects/fio/releases/341331).
In the current Debian (http://packages.debian.org/squeeze/fio) and Ubuntu LTS releases (http://packages.ubuntu.com/precise/fio) the Fio version is before 2.0.3 and therefore the terse output is not of version 3.

As Jens said, you can also switch to JSON format instead.
So maybe you are stuck to use Fio from the git repo to have a newer version.

Regards, Georg


