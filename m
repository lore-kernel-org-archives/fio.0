Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728860AbgHURHL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Aug 2020 13:07:11 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C372C061573
        for <fio@vger.kernel.org>; Fri, 21 Aug 2020 10:07:11 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id ba10so2042037edb.3
        for <fio@vger.kernel.org>; Fri, 21 Aug 2020 10:07:11 -0700 (PDT)
Date: Fri, 21 Aug 2020 20:07:07 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: remove reset_zone flag from fio_zone_info
Message-ID: <20200821170707.GA1443825@localhost.localdomain>
References: <20200819125609.GA278226@localhost.localdomain>
 <MN2PR04MB5951788306F08D671035B797E15D0@MN2PR04MB5951.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MN2PR04MB5951788306F08D671035B797E15D0@MN2PR04MB5951.namprd04.prod.outlook.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Aug 19, 2020 at 07:35:03PM +0000, Dmitry Fomichev wrote:
> 
> 
> > -----Original Message-----
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > Sent: Wednesday, August 19, 2020 8:56 AM
> > To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
> > Cc: fio@vger.kernel.org
> > Subject: Re: [PATCH] zbd: remove reset_zone flag from fio_zone_info
> > 
> > > The reset_zone flag that is defined in fio_zone_info structure is
> > > only referenced in zbd_adjust_block() function. Convert this flag
> > > to a local variable and save some room in zbd_info array which can
> > > be pretty large when running fio against high capacity zoned devices.
> > 
> > This flag should be kept.
> > 
> > Test can crash or be interrupted leaving hw in indeterminate state,
> > it must be restarted from clean state. Or test can be precondition and
> > zone should not be reset.
> 
> This is beyond the scope of fio. Any preconditioning of zones is done
> by external scripts that have no access to this flag. Tools like blkzone,
> libzbc or nvme-cli are typically used to precondition zones before
> testing and to analyze zone state after test runs.

If it is a matter of policy that fio doesn't do preconditioning,
then the patch is OK.

We do preconditioning in fio, it is neat:
* don't need external programs
* everything inside one job file
* not a lot of code to add

But to do this, flag must live in "struct fio_zone_info".

	[zra]
	zone_reset_all=1
	zone_finish_all=1
	rw=write

	[pre]
	stonewall
	zone_reset_all=0
	zone_finish_all=0
	job_max_open_zones=...
	rw=write
		...

	[j]
	stonewall
	zone_reset_all=0
	zone_finish_all=0
	rw=randread
		...

