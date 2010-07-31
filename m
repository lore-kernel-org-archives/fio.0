Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Sender: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>
Date: Sat, 31 Jul 2010 01:24:18 -0600
Subject: Re: fio crash after running an I/O stress test for about half an  hour
Message-ID: <AANLkTikqWuQUMVbqbJn4T9Y12LE2-efW8r2FngFKgmCm@mail.gmail.com>
References: <AANLkTimztvyqQPY3dF14awaKKQSm=RMe0Hc6J55O_CAd@mail.gmail.com>
	<4C51425D.2010507@fusionio.com>
In-Reply-To: <4C51425D.2010507@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Jul 29, 2010 at 10:57 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> On 07/26/2010 04:17 PM, Bart Van Assche wrote:
> > Hello,
> >
> > When I run the fio command below, fio triggers a segmentation fault
> > after about half an hour. Is this a known issue ?
>
> [snip]
>
> OK, took a quick look. It's an artifact of using norandommap with a
> short job like yours, when it finds an alias in the rbtree it only
> removes it. So it sticks around in memory and will never get cleaned.
> So 10 loops would get you 600k of lost memory, 1000000 would bump you
> way into the OOM territory.
>
> The below should fix it, I have committed that fix.
>
> diff --git a/log.c b/log.c
> index 5fc8f64..80d3742 100644
> --- a/log.c
> +++ b/log.c
> @@ -231,6 +231,7 @@ restart:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0assert(ipo->len =3D=3D __i=
po->len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0td->io_hist_len--;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rb_erase(parent, &td->io_h=
ist_tree);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(__ipo);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto restart;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}

The latest git version works fine now. Thanks !

Bart.

