Return-Path: <martin.bukatovic@gmail.com>
Return-Path: <martin.bukatovic@gmail.com>
Date: Sat, 29 Aug 2020 22:34:17 +0200
From: Martin Bukatovic <martin.bukatovic@gmail.com>
Subject: Re: [PATCH] Add fill_quota option
Message-ID: <20200829203417.GA18208@dione.lan>
References: <20200811194445.GA152146@dione.lan>
 <d3b41f1b-5bd7-a9f2-5511-7a6062aaa5bf@kernel.dk>
 <20200829190131.GA8262@dione.lan>
 <3e8f33c3-6d57-8932-b84e-374c0afd4779@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e8f33c3-6d57-8932-b84e-374c0afd4779@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sat, Aug 29, 2020 at 01:44:07PM -0600, Jens Axboe wrote:
> On 8/29/20 1:01 PM, Martin Bukatovic wrote:
> > On Fri, Aug 28, 2020 at 05:53:34PM -0600, Jens Axboe wrote:
> >> Might be easier and saner to just accept EDQUOT by default, instead of
> >> adding an option for it?
> > 
> > I proposed a new option to avoid changing behaviour of fill_device
> > option. But if that is not necessary, I agree that making fill_device to
> > stop on both ENOSPC and EDQUOT makes more sense.
> 
> I don't think that's necessary, the option is really "stop writing when
> we're full", and there's no way to reach ENOSPC before EDQUOT vs
> the other way around.
> 
> Hence I think it's totally fine to just include EDQUOT in the "stop
> successfully" part of the fill_device behavior.

Ok, I'm sending new version of the patch "Make fill_device to stop
writing on EDQUOT".

-- 
Martin Bukatovič

