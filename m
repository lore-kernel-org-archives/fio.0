Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:17320 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbeGPSh2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Jul 2018 14:37:28 -0400
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 3CC49600AF
        for <fio@vger.kernel.org>; Mon, 16 Jul 2018 18:08:54 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] Fio's initial RTEMS port
Date: Mon, 16 Jul 2018 18:08:52 +0000
Message-ID: <AT5PR8401MB1169D3DCF6AFA23203ABAD89AB5D0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1531732006-11136-1-git-send-email-dev.madaari@gmail.com>
 <1531732006-11136-2-git-send-email-dev.madaari@gmail.com>
In-Reply-To: <1531732006-11136-2-git-send-email-dev.madaari@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'dev.madaari@gmail.com'" <dev.madaari@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of dev.madaari@gmail.com
> Sent: Monday, July 16, 2018 4:07 AM
> To: fio@vger.kernel.org
> Cc: Udit kumar agarwal <dev.madaari@gmail.com>
> Subject: [PATCH] Fio's initial RTEMS port
> 
> From: Udit kumar agarwal <dev.madaari@gmail.com>
> 
...
> diff --git a/os/rtems/rtems-fio-wrap.h b/os/rtems/rtems-fio-wrap.h
> new file mode 100644
> index 0000000..2c639cb
> --- /dev/null
> +++ b/os/rtems/rtems-fio-wrap.h
> @@ -0,0 +1,54 @@
> +/* RTEMS specific wrapper for explicitly calling constructors and
> + * destructors */
> +
> +void act_register(void);
> +void tiobench_register(void);
> +void fio_syncio_register(void);
> +void fio_filecreate_register(void);
> +void fio_null_register(void);
> +void prio_tree_init(void);
> +void fio_syncio_register_ft(void);
> +void fio_client_hash_init(void);
> +void fio_syncio_unregister(void);
> +void tiobench_unregister(void);
> +void fio_filecreate_unregister(void);
> +void fio_null_unregister(void);
> +void act_unregister(void);
> +void fio_syncio_unregister_ft(void);
> +

This new wrapper for fio's main():

> +static int
> +mainwrapper(int argc, char *argv[])
> +{
> +	int err=0;
> +
> +	/* Constructors */
> +	act_register();
> +	tiobench_register();
> +	fio_syncio_register();
> +	fio_filecreate_register();
> +	fio_null_register();
> +	prio_tree_init();
> +	fio_syncio_register_ft();
> +	fio_client_hash_init();
> +
> +	err = main(argc, argv, (char *)NULL);
> +
> +	/* Destructors */
> +	fio_syncio_unregister();
> +	tiobench_unregister();
> +	fio_filecreate_unregister();
> +	fio_null_unregister();
> +	act_unregister();
> +	fio_syncio_unregister_ft();
> +
> +	return err;
> +}
> +

and a bunch of these changes to the profile and engine source code
exposing the register and unregister functions so the wrapper can
call them:

> -static void fio_init act_register(void)
> +#ifdef __rtems__
> +void
> +#else /* __rtems__ */
> +static void fio_init
> +#endif /* __rtems__ */
> +act_register(void)

are a bit awkward.

fio's main() calls initialize_fio() which calls arch_init() and
other functions, and add_job() initializes the profiles and
engines needed by the job.  Any reason that flow doesn't work
in the RTEMS environment?


---
Robert Elliott, HPE Persistent Memory


