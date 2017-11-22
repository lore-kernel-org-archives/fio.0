Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:44986 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbdKVXgu (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Nov 2017 18:36:50 -0500
Received: by mail-vk0-f52.google.com with SMTP id s197so10834629vkh.11
        for <fio@vger.kernel.org>; Wed, 22 Nov 2017 15:36:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145791EDDCE1E1F98FB2D4CD8F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CAPqbHXh=+CXA1+Y0mmHbDmJauu53h6AmFNWW8ASWViP-LxKiEw@mail.gmail.com>
 <BN3PR0401MB145791EDDCE1E1F98FB2D4CD8F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 22 Nov 2017 23:36:18 +0000
Message-ID: <CALjAwxgNq6RkgDo_0y0bSPCDsGNpn8kRTzh43e+JF=iSomNOxw@mail.gmail.com>
Subject: Re: Running for a specific number of IOs
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Prabhakaran <prabhugce@gmail.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Prabhu,

As Jeff mentioned you weren't specific as to exactly what went wrong.
Additionally - did you read all the text for the number_ios option
over on http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-number-ios
especially the following: "Note that this does not extend the amount
of I/O that will be done".

On 22 November 2017 at 23:06, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> What parameters are you using?  Here is a counterexample from a previous post that shows number_ios running and then the job terminating:
>
> fio --name=test_job --ioengine=libaio --direct=1 --rw=read --iodepth=1 --size=100% --bs=4k --filename=/dev/nvme1n1 --number_ios=8
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Prabhakaran
> Sent: Wednesday, November 22, 2017 2:47 PM
> To: fio@vger.kernel.org
> Subject: Running for a specific number of IOs
>
> Hi,
>
> Is there a parameter in FIO that can be used to run for a specific number of IOs? I thought 'number_ios' might to this, but actually it does fill 1x of the drive usable space and exits.
>
> Thanks,
> Prabhu

-- 
Sitsofe | http://sucs.org/~sits/
