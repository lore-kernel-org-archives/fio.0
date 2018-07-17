Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:19554 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731574AbeGQOvb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Jul 2018 10:51:31 -0400
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 9F8F0609AB
        for <fio@vger.kernel.org>; Tue, 17 Jul 2018 14:18:38 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] idle-prof: append output cpu idleness data to terse log
Date: Tue, 17 Jul 2018 14:18:35 +0000
Message-ID: <AT5PR8401MB116995DF0FE7729E290EEAB5AB5C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <925A83423110DA4D836092D40AC7A7E8084E0DEE@APYOKXMS108.ap.sony.com>
In-Reply-To: <925A83423110DA4D836092D40AC7A7E8084E0DEE@APYOKXMS108.ap.sony.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "No.Tanaka@sony.com" <No.Tanaka@sony.com>, "Hajime.Tomura@sony.com" <Hajime.Tomura@sony.com>



> -----Original Message-----
> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
> Of Friendy.Su@sony.com
> Sent: Tuesday, July 17, 2018 2:46 AM
> To: fio@vger.kernel.org
> Cc: No.Tanaka@sony.com; Hajime.Tomura@sony.com; Friendy.Su@sony.com
> Subject: [PATCH] idle-prof: append output cpu idleness data to terse
> log
> 
> cpu idleness data only output to normal and json log,
> also output to terse log.
> 
> Signed-off-by: friendy-su <friendy.su@sony.com>
> ---
>  HOWTO      |  4 +++-
>  idletime.c | 19 +++++++++++++++++++
>  stat.c     |  2 ++
>  3 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/HOWTO b/HOWTO
> index 70eed280..497e8cb1 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -3564,8 +3564,10 @@ will be a disk utilization section.
>  Below is a single line containing short names for each of the fields
> in the
>  minimal output v3, separated by semicolons::
> 
> -
> terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwi
...
> +
> terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwi
...

Since the terse format is not self-describing, new fields require
a version bump (see -terse-version).

Maybe one of the versions should print out the field names as the first
line, so it becomes self-describing.  I guess the json format already
provides that functionality, so it might not be necessary.

---
Robert Elliott, HPE Persistent Memory


