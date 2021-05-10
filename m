Return-Path: <martin.bukatovic@gmail.com>
Return-Path: <martin.bukatovic@gmail.com>
Date: Tue, 11 May 2021 00:46:30 +0200
From: Martin Bukatovic <martin.bukatovic@gmail.com>
Subject: Re: [PATCH] Make fill_device to stop writing on EDQUOT
Message-ID: <YJm3xio2Etyyk+2o@dione.lan>
References: <20200829203456.GA18156@dione.lan>
 <5cef0533-4e2c-fc1e-7293-401523848a6d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5cef0533-4e2c-fc1e-7293-401523848a6d@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sat, Aug 29, 2020 at 03:17:39PM -0600, Jens Axboe wrote:
> On 8/29/20 2:34 PM, Martin Bukatovic wrote:
> > diff --git a/filesetup.c b/filesetup.c
> > index d382fa24..39a17521 100644
> > --- a/filesetup.c
> > +++ b/filesetup.c
> > @@ -233,6 +233,10 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
> >  						 "file, stopping\n");
> >  					break;
> >  				}
> > +				if (__e == EDQUOT) {
> > +					if (td->o.fill_device)
> > +						break;
> > +				}
> >  				td_verror(td, errno, "write");
> >  			} else
> >  				td_verror(td, EIO, "write");
> 
> This should just extent the previous ENOSPC check, and modify the
> print statement as well.

Fixed in v2 of the patch.

-- 
Martin Bukatovič

