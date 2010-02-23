Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41624 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab0BWN7o (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Feb 2010 08:59:44 -0500
Date: Tue, 23 Feb 2010 14:59:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Verification failures with mixed read/write case
Message-ID: <20100223135942.GD1025@kernel.dk>
References: <1266456009.19149.72.camel@cfslap.wizy.org> <20100223092849.GP1025@kernel.dk> <20100223093610.GQ1025@kernel.dk> <1266932889.3379.19.camel@cfslap.wizy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266932889.3379.19.camel@cfslap.wizy.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Cc: fio@vger.kernel.org

On Tue, Feb 23 2010, Ricardo M. Correia wrote:
> Yup, that seems to have worked.
> 
> Thanks :)

No problem, apparently sha256 verifies aren't that widely used :-)

> 
> On Ter, 2010-02-23 at 10:36 +0100, Jens Axboe wrote:
> > OK, so this seems to be just a bug in sha256, it's working as expected
> > here. Can you try the below patch?
> > 
> > diff --git a/verify.c b/verify.c
> > index 59f1ddf..c894b60 100644
> > --- a/verify.c
> > +++ b/verify.c
> > @@ -212,7 +212,7 @@ static int verify_io_u_sha256(struct verify_header *hdr, struct io_u *io_u,
> >  {
> >  	void *p = io_u_verify_off(hdr, io_u, header_num);
> >  	struct vhdr_sha256 *vh = hdr_priv(hdr);
> > -	uint8_t sha256[128];
> > +	uint8_t sha256[64];
> >  	struct sha256_ctx sha256_ctx = {
> >  		.buf = sha256,
> >  	};
> > diff --git a/verify.h b/verify.h
> > index c12bc7d..be98c54 100644
> > --- a/verify.h
> > +++ b/verify.h
> > @@ -37,7 +37,7 @@ struct vhdr_sha512 {
> >  	uint8_t sha512[128];
> >  };
> >  struct vhdr_sha256 {
> > -	uint8_t sha256[128];
> > +	uint8_t sha256[64];
> >  };
> >  struct vhdr_sha1 {
> >  	uint32_t sha1[5];
> > 
> 
> 

-- 
Jens Axboe

