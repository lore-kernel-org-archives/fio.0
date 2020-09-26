Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200829203456.GA18156@dione.lan> <5cef0533-4e2c-fc1e-7293-401523848a6d@kernel.dk>
In-Reply-To: <5cef0533-4e2c-fc1e-7293-401523848a6d@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 26 Sep 2020 14:51:09 +0100
Message-ID: <CALjAwxgGct=qcQX_DdbgEC5BYEwLwggJ4tP9q_-eF=Dgx6RSFg@mail.gmail.com>
Subject: Re: [PATCH] Make fill_device to stop writing on EDQUOT
Content-Type: text/plain; charset="UTF-8"
To: Martin Bukatovic <martin.bukatovic@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

(Just a quick ping to Martin on this one because hopefully the changes
requested were doable)


On Sat, 29 Aug 2020 at 22:19, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/29/20 2:34 PM, Martin Bukatovic wrote:
> > diff --git a/filesetup.c b/filesetup.c
> > index d382fa24..39a17521 100644
> > --- a/filesetup.c
> > +++ b/filesetup.c
> > @@ -233,6 +233,10 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
> >                                                "file, stopping\n");
> >                                       break;
> >                               }
> > +                             if (__e == EDQUOT) {
> > +                                     if (td->o.fill_device)
> > +                                             break;
> > +                             }
> >                               td_verror(td, errno, "write");
> >                       } else
> >                               td_verror(td, EIO, "write");
>
> This should just extent the previous ENOSPC check, and modify the
> print statement as well.
>
> --
> Jens Axboe
>


--
Sitsofe | http://sucs.org/~sits/

