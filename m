Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgIBMtP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Sep 2020 08:49:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA22C061245
        for <fio@vger.kernel.org>; Wed,  2 Sep 2020 05:49:12 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c19so3102740wmd.1
        for <fio@vger.kernel.org>; Wed, 02 Sep 2020 05:49:12 -0700 (PDT)
Date: Wed, 2 Sep 2020 15:49:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: remove reset_zone flag from fio_zone_info
Message-ID: <20200902124908.GA884094@localhost.localdomain>
References: <20200819125609.GA278226@localhost.localdomain>
 <MN2PR04MB5951788306F08D671035B797E15D0@MN2PR04MB5951.namprd04.prod.outlook.com>
 <20200821170707.GA1443825@localhost.localdomain>
 <MN2PR04MB5951A6A974917E280DF3E262E1550@MN2PR04MB5951.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MN2PR04MB5951A6A974917E280DF3E262E1550@MN2PR04MB5951.namprd04.prod.outlook.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Aug 27, 2020 at 07:18:07PM +0000, Dmitry Fomichev wrote:
> 
> 
> > -----Original Message-----
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > Sent: Friday, August 21, 2020 1:07 PM
> > To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
> > Cc: fio@vger.kernel.org
> > Subject: Re: [PATCH] zbd: remove reset_zone flag from fio_zone_info
> > 
> > On Wed, Aug 19, 2020 at 07:35:03PM +0000, Dmitry Fomichev wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Alexey Dobriyan <adobriyan@gmail.com>
> > > > Sent: Wednesday, August 19, 2020 8:56 AM
> > > > To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
> > > > Cc: fio@vger.kernel.org
> > > > Subject: Re: [PATCH] zbd: remove reset_zone flag from fio_zone_info
> > > >
> > > > > The reset_zone flag that is defined in fio_zone_info structure is
> > > > > only referenced in zbd_adjust_block() function. Convert this flag
> > > > > to a local variable and save some room in zbd_info array which can
> > > > > be pretty large when running fio against high capacity zoned devices.
> > > >
> > > > This flag should be kept.
> > > >
> > > > Test can crash or be interrupted leaving hw in indeterminate state,
> > > > it must be restarted from clean state. Or test can be precondition and
> > > > zone should not be reset.
> > >
> > > This is beyond the scope of fio. Any preconditioning of zones is done
> > > by external scripts that have no access to this flag. Tools like blkzone,
> > > libzbc or nvme-cli are typically used to precondition zones before
> > > testing and to analyze zone state after test runs.
> > 
> > If it is a matter of policy that fio doesn't do preconditioning,
> > then the patch is OK.
> > 
> > We do preconditioning in fio, it is neat:
> > * don't need external programs
> > * everything inside one job file
> > * not a lot of code to add
> > 
> > But to do this, flag must live in "struct fio_zone_info".
> > 
> > 	[zra]
> > 	zone_reset_all=1
> 
> The way I understand this, this option makes ZBD code to set the reset_zone
> flag for all zones during init. This will force zone reset before the first write
> to a zone. This indeed is a neat idea and this feature looks to be pretty 
> lightweight as you said.
> 
> > 	zone_finish_all=1
> 
> How does this option work? Seems like you have added a new
> finish_zone flag and you finish every zone for which the flag is set
> instead of performing the first write to the zone...

Sorry for delay.

ZRA marks every zone in [->min_zone, ->max_zone) for reset,
forcing Zone Reset before first write.

ZFA sends Finish Zone with "all" flag set synchronously.

Some job orchestration is required but once it is done, jobs run reliably.

> > 	rw=write
> > 
> > 	[pre]
> > 	stonewall
> > 	zone_reset_all=0
> > 	zone_finish_all=0
> > 	job_max_open_zones=...
> > 	rw=write
> > 		...
> > 
> > 	[j]
> > 	stonewall
> > 	zone_reset_all=0
> > 	zone_finish_all=0
> > 	rw=randread
> > 		...
> 
> I guess we can hold off with removing the reset_zone flag if you are planning
> to send the patch for this.

Thanks, I'll try to extract something mainlineable.

