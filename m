Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36308 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbeGPUe5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Jul 2018 16:34:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9-v6so33138016wro.3
        for <fio@vger.kernel.org>; Mon, 16 Jul 2018 13:05:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169D3DCF6AFA23203ABAD89AB5D0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1531732006-11136-1-git-send-email-dev.madaari@gmail.com>
 <1531732006-11136-2-git-send-email-dev.madaari@gmail.com> <AT5PR8401MB1169D3DCF6AFA23203ABAD89AB5D0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Udit agarwal <dev.madaari@gmail.com>
Date: Tue, 17 Jul 2018 01:35:57 +0530
Message-ID: <CAM0bxh-b2u42fqm6y2HNZTfTG8xe_qvky0N9T5hT+HropnJVeQ@mail.gmail.com>
Subject: Re: [PATCH] Fio's initial RTEMS port
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,
On Mon, Jul 16, 2018 at 11:38 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of dev.madaari@gmail.com
> > Sent: Monday, July 16, 2018 4:07 AM
> > To: fio@vger.kernel.org
> > Cc: Udit kumar agarwal <dev.madaari@gmail.com>
> > Subject: [PATCH] Fio's initial RTEMS port
> >
> > From: Udit kumar agarwal <dev.madaari@gmail.com>
> >
> ...
> > diff --git a/os/rtems/rtems-fio-wrap.h b/os/rtems/rtems-fio-wrap.h
> > new file mode 100644
> > index 0000000..2c639cb
> > --- /dev/null
> > +++ b/os/rtems/rtems-fio-wrap.h
> > @@ -0,0 +1,54 @@
> > +/* RTEMS specific wrapper for explicitly calling constructors and
> > + * destructors */
> > +
> > +void act_register(void);
> > +void tiobench_register(void);
> > +void fio_syncio_register(void);
> > +void fio_filecreate_register(void);
> > +void fio_null_register(void);
> > +void prio_tree_init(void);
> > +void fio_syncio_register_ft(void);
> > +void fio_client_hash_init(void);
> > +void fio_syncio_unregister(void);
> > +void tiobench_unregister(void);
> > +void fio_filecreate_unregister(void);
> > +void fio_null_unregister(void);
> > +void act_unregister(void);
> > +void fio_syncio_unregister_ft(void);
> > +
>
> This new wrapper for fio's main():
>
> > +static int
> > +mainwrapper(int argc, char *argv[])
> > +{
> > +     int err=0;
> > +
> > +     /* Constructors */
> > +     act_register();
> > +     tiobench_register();
> > +     fio_syncio_register();
> > +     fio_filecreate_register();
> > +     fio_null_register();
> > +     prio_tree_init();
> > +     fio_syncio_register_ft();
> > +     fio_client_hash_init();
> > +
> > +     err = main(argc, argv, (char *)NULL);
> > +
> > +     /* Destructors */
> > +     fio_syncio_unregister();
> > +     tiobench_unregister();
> > +     fio_filecreate_unregister();
> > +     fio_null_unregister();
> > +     act_unregister();
> > +     fio_syncio_unregister_ft();
> > +
> > +     return err;
> > +}
> > +
>
> and a bunch of these changes to the profile and engine source code
> exposing the register and unregister functions so the wrapper can
> call them:
>
> > -static void fio_init act_register(void)
> > +#ifdef __rtems__
> > +void
> > +#else /* __rtems__ */
> > +static void fio_init
> > +#endif /* __rtems__ */
> > +act_register(void)
>
> are a bit awkward.
>
> fio's main() calls initialize_fio() which calls arch_init() and
> other functions, and add_job() initializes the profiles and
> engines needed by the job.  Any reason that flow doesn't work
> in the RTEMS environment?
>
Actually, RTEMS is an RTOS for embedded systems and here every
application has to be linked statically.
So, We have to manually call constructors before an application
starts(as compiler wouldn't know where to put them).
Application start is like boot up for us.

So, these changes includes calling up the constructors(functions with
fio_init attribute) and destructors(the ones with fio_exit attr)
like normal routines through the mainwrapper function. After that the
regular flow of Fio routines works flawlessly.

>
> ---
> Robert Elliott, HPE Persistent Memory
>
>



-- 
Regards,
Udit kumar agarwal
http://uditagarwal.in/
