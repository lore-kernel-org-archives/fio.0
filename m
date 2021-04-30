Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhD3Wjy (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Apr 2021 18:39:54 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C78C06174A
        for <fio@vger.kernel.org>; Fri, 30 Apr 2021 15:39:04 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id t24so14128773oic.10
        for <fio@vger.kernel.org>; Fri, 30 Apr 2021 15:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <BL0PR11MB31394F526D7FF390F9551496905E9@BL0PR11MB3139.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB31394F526D7FF390F9551496905E9@BL0PR11MB3139.namprd11.prod.outlook.com>
From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Date: Fri, 30 Apr 2021 15:38:53 -0700
Message-ID: <CAFCYAsfqGJH_-wMP+QC-z04senzAgLmyrM_aJ-AgwBaYQP-a8w@mail.gmail.com>
Subject: Re: FIO Frontend Development
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: "Johnson, Glen" <glen.johnson@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

How does this differ from the Fio Visualizer project, also done by
Intel, a few years ago.

https://github.com/intel/fiovisualizer


On Fri, Apr 30, 2021 at 11:38 AM Johnson, Glen <glen.johnson@intel.com> wro=
te:
>
> Hi all,
>
> I am part of a development team who is creating a GUI frontend for FIO wh=
ich is currently in Alpha status. This frontend is written in Python and us=
es QT5. We are planning to release this as its own repository on GitHub.  W=
e are looking to see if there is interest in the FIO community in hosting t=
he project. We can provide screenshots of the code if it is in interest. On=
e of the main benefits of this tool is that it allows for the creation of F=
IO job files with custom FIO workloads. We also added a custom 'idle' job t=
hat lets the drive idle for a set amount of time (selected in the frontend)=
 during the runs. In addition we also support the looping of jobs. The tool=
 also parses the output of FIO and separates the values for log files, as w=
ell as drawing graphs for the IOPS, Bandwidth, and Latency. We see that thi=
s tool could be very beneficial to FIO users and are planning to keep suppo=
rting this tool, and adding more features to it. We are very excited about =
this project and are looking forward to hearing your response!
>
> -- Glen Johnson

