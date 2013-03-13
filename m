Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:51739 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3CMBTv (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 21:19:51 -0400
Received: by mail-vb0-f48.google.com with SMTP id fc21so213230vbb.21
        for <fio@vger.kernel.org>; Tue, 12 Mar 2013 18:19:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKCZDgmZkiTEtw178EZjqaWgrGyXUnD7kKbNM4ymZATeyHow2w@mail.gmail.com>
References: <1363072013-7562-1-git-send-email-olegmatcovsky@gmail.com>
	<CAKCZDgmZkiTEtw178EZjqaWgrGyXUnD7kKbNM4ymZATeyHow2w@mail.gmail.com>
Date: Wed, 13 Mar 2013 12:19:50 +1100
Message-ID: <CAKCZDgnkXszwD_Mv6B7kqSfc+icuA3AL3BXp76UCEZYz4DY_Dg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Conditionally include <sys/shm.h> based on OS
 support. Define missing MAP_HUGETLB for Android.
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: multipart/mixed; boundary=089e0118455cdfd78904d7c433c1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: olegmatcovsky@gmail.com
Cc: fio@vger.kernel.org

--089e0118455cdfd78904d7c433c1
Content-Type: text/plain; charset=ISO-8859-1

On 13 March 2013 12:15, Aaron Carroll <xaaronc@gmail.com> wrote:
> diff --git a/configure b/configure
> index d1f277d..1827e02 100755
> --- a/configure
> +++ b/configure
> @@ -234,7 +234,7 @@ Android)
>    output_sym "CONFIG_CLOCK_GETTIME"
>    output_sym "CONFIG_CLOCK_MONOTONIC"
>    echo "CC=$cc" >> $config_host_mak
> -  echo "EXTFLAGS=$CFLAGS -include config-host.h -DFIO_NO_HAVE_SHM_H
> -D_GNU_SOURCE" >> $config_host_mak
> +  echo "EXTFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >>
> $config_host_mak
>    exit 0
>  esac

And gmail has mangled my diff.  Correct version attached.


  -- Aaron

--089e0118455cdfd78904d7c433c1
Content-Type: application/octet-stream; name="no-have-shm.patch"
Content-Disposition: attachment; filename="no-have-shm.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_he7sw6hl0

ZGlmZiAtLWdpdCBhL2NvbmZpZ3VyZSBiL2NvbmZpZ3VyZQppbmRleCBkMWYyNzdkLi4xODI3ZTAy
IDEwMDc1NQotLS0gYS9jb25maWd1cmUKKysrIGIvY29uZmlndXJlCkBAIC0yMzQsNyArMjM0LDcg
QEAgQW5kcm9pZCkKICAgb3V0cHV0X3N5bSAiQ09ORklHX0NMT0NLX0dFVFRJTUUiCiAgIG91dHB1
dF9zeW0gIkNPTkZJR19DTE9DS19NT05PVE9OSUMiCiAgIGVjaG8gIkNDPSRjYyIgPj4gJGNvbmZp
Z19ob3N0X21hawotICBlY2hvICJFWFRGTEFHUz0kQ0ZMQUdTIC1pbmNsdWRlIGNvbmZpZy1ob3N0
LmggLURGSU9fTk9fSEFWRV9TSE1fSCAtRF9HTlVfU09VUkNFIiA+PiAkY29uZmlnX2hvc3RfbWFr
CisgIGVjaG8gIkVYVEZMQUdTPSRDRkxBR1MgLWluY2x1ZGUgY29uZmlnLWhvc3QuaCAtRF9HTlVf
U09VUkNFIiA+PiAkY29uZmlnX2hvc3RfbWFrCiAgIGV4aXQgMAogZXNhYwogCg==
--089e0118455cdfd78904d7c433c1--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


