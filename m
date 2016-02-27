Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34403 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbcB0JOf convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 27 Feb 2016 04:14:35 -0500
Received: by mail-lf0-f54.google.com with SMTP id j78so66234101lfb.1
        for <fio@vger.kernel.org>; Sat, 27 Feb 2016 01:14:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sat, 27 Feb 2016 12:14:14 +0300
Message-ID: <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com>
Subject: Re: Specify range and distribution of accesses
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Feb 26, 2016 at 11:53 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote:
> Hi All,
> I'm looking for a method to distribute access to certain ranges of a block device.  For example, the JESD219 workload (http://www.jedec.org/sites/default/files/docs/JESD219.pdf) specifies
>
> The workload shall be distributed across the SSD such that the following is achieved:
> 1) 50% of accesses to first 5% of user LBA space (LBA group a)
> 2) 30% of accesses to next 15% of user LBA space (LBA group b)
> 3) 20% of accesses to remainder of user LBA space (LBA group c)
>
> I do not currently see any fio options to allow such usage.  Perhaps if --size or --iosize is updated to allow ranges/distributions, it may be possible?
>
> The JESD219 workload also specifies a distribution of block sizes, which can already be accomplished in fio with --bssplit, such as --bssplit=4k/10:64k/50:32k/40.  Perhaps extending that usage to --size or --iosize may solve the issue?
>
> The above link for the JESD219 workload includes a vdbench script to produce the desired workload, but I'm hesitant to think that vdbench does something that fio cannot.  Has anyone been able to specify ranges and distributions of accesses in any other way?  Thanks.
>

To model skewed workloads, fio provides Zipf and Pareto offset
distributions, although neither solves exactly your problem. At the
same time, a specific feature you're looking for should be pretty
straightforward to add. You might want to add a new sub-option under
random_distribution to specify frequency/capacity percentage list,
similar to the 'bssplit' block size frequency option, and code it
following the example of the bssplit, with uniform distribution within
the range chosen based on the frequency table yielding the actual
offset.

Regards,
Andrey

> Regards,
> Jeff
>
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
