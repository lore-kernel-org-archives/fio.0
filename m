Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 19 Feb 2021 19:42:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] fio: simplify parse_is_percent()
Message-ID: <YC/qXrjE51Bs03eL@localhost.localdomain>
References: <YCl2l6N+4NFMngAu@localhost.localdomain>
 <MN2PR04MB5951D995704B93FC20A20EE9E1889@MN2PR04MB5951.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MN2PR04MB5951D995704B93FC20A20EE9E1889@MN2PR04MB5951.namprd04.prod.outlook.com>
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Feb 15, 2021 at 03:40:59AM +0000, Dmitry Fomichev wrote:
> > -----Original Message-----
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > Sent: Sunday, February 14, 2021 2:15 PM
> > To: axboe@kernel.dk
> > Cc: fio@vger.kernel.org
> > Subject: [PATCH] fio: simplify parse_is_percent()
> 
> fio: -> parse:?
> 
> > 
> > Check like this
> > 
> > 	unsigned long long val <= -1ULL
> > 
> > is tautologically true because of how type conversions work.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  parse.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/parse.h
> > +++ b/parse.h
> > @@ -131,7 +131,7 @@ static inline void *td_var(void *to, const struct
> > fio_option *o,
> > 
> >  static inline int parse_is_percent(unsigned long long val)
> >  {
> > -	return val <= -1ULL && val >= (-1ULL - 100ULL);
> > +	return val >= -101;
> 
> Nice cleanup, but wouldn't that be better to keep the ULL suffix
> for the sake of clarity?

ULL is unnecessary here. fio has lots of unnecessary ULLs :-\

> >  }
> > 
> >  #define ZONE_BASE_VAL ((-1ULL >> 1) + 1)
> 
> This patch is based on your earlier patch
> "zbd: support 'z' suffix for zone granularity" that is still in review,
> why not to combine these two in a series?

Yes, this one should go first.

