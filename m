Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88746C433F5
	for <fio@archiver.kernel.org>; Wed,  2 Mar 2022 15:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiCBPYX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbiCBPYW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Mar 2022 10:24:22 -0500
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68C5C6822
        for <fio@vger.kernel.org>; Wed,  2 Mar 2022 07:23:36 -0800 (PST)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220302152331usoutp0296cded9f7b9219c217192585dc3882df~Ymag1oRcN2593925939usoutp02x;
        Wed,  2 Mar 2022 15:23:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220302152331usoutp0296cded9f7b9219c217192585dc3882df~Ymag1oRcN2593925939usoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646234611;
        bh=BtXjzvz7VS705Q8ISUDIICcWZdpr1YzpysHZm8f8ubc=;
        h=From:To:CC:Subject:Date:References:From;
        b=JqBTjXoio63M/lpeZssGvHSosPa7Y9OzkUt08r8TCWNWYuZKgGx+45mAZIK/0wHgB
         iHVWraxrsHD3bxgTHGvkmczwTRIQLC8/AmBWW/zYL8IvjWdW3Cmk4QBctxE/yxkMGz
         DZHZyNivlCDFOA3AOZKB8GI8WvnO4n8zukSoE4gE=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220302152331uscas1p1b377b8661720a226bfa54b7cd9f4c299~YmagueCyu1170211702uscas1p1D;
        Wed,  2 Mar 2022 15:23:31 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id F3.31.09687.3FB8F126; Wed, 
        2 Mar 2022 10:23:31 -0500 (EST)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220302152331uscas1p297d64e27b29db799fd64d494ad584860~YmagcYpdh2377423774uscas1p2R;
        Wed,  2 Mar 2022 15:23:31 +0000 (GMT)
X-AuditID: cbfec370-9c5ff700000025d7-3d-621f8bf3c16c
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 43.C5.10042.3FB8F126; Wed, 
        2 Mar 2022 10:23:31 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Wed, 2 Mar 2022 07:22:28 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Wed, 2 Mar 2022 07:22:28 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.steigerwald@proact.de" <martin.steigerwald@proact.de>,
        "sandeen@redhat.com" <sandeen@redhat.com>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH] docs: generate manpage from README and HOWTO
Thread-Topic: [PATCH] docs: generate manpage from README and HOWTO
Thread-Index: AQHYLklUIgBa7/P1o0S8kmRIpYZxRQ==
Date:   Wed, 2 Mar 2022 15:22:28 +0000
Message-ID: <20220302152122.64596-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42LZduzred3P3fJJBs8fiVqsvtvPZvFx1gtm
        i0NHe1kspm9xdGDxuHy21OPUr4/sHu/3XWXz+LxJLoAlissmJTUnsyy1SN8ugSvj/68exoJe
        mYrHRxezNTDuEO9i5OSQEDCROPLsMDuILSSwklFiygu5LkYuILuVSWLp8V5GmKIl966xQyTW
        Mkqc+3aABcL5wCjx5cchVghnP5Cz/jKQw8HBJqAp8XZ/AUhcROAQo8S97cvYQEYxC6hLHNu4
        AcwWFrCVaPuxnxXEFhFwknj2+w0bhK0ncfjLFzaQOSwCKhJr9viAmLwC1hJrpzGDVDAKiEl8
        P7WGCWKiuMStJ/OZIA4VlFg0ew8zhC0m8W/XQzYIW1Hi/veX7BD1ehI3pk6BukZbYtnC12D1
        vEC9J2c+YYGol5Q4uOIG2I8SAhM5JE6+OgI1yEXizuGz0FCRlvh7dxkTRNFkRomv2+6zQTir
        GSVeLrgEVWUt8a/zGtRqPom/vx4xgnwjIcAr0dEmNIFRaRaSJ2YhOXAWkgNnITlwASPLKkbx
        0uLi3PTUYuO81HK94sTc4tK8dL3k/NxNjMDUcvrf4YIdjLdufdQ7xMjEwQgMfg5mJRFecWv5
        JCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8yzI3JAoJpCeWpGanphakFsFkmTg4pRqY9MNNpzFy
        yx45F9jcGxe5TvmM8t5k2R+3lf86y6SyP9xXLh0aPKPm64PFz+urWGs5nd403RHQjrS9E/fZ
        7MqBTU9mr3507by7kspN7u2nuHewz2lfyPL7MZvE3HNpOrwB/JoHH/DwT1oon3n2ueOyuM2b
        ZNnrD2u8WZp9wvnU1SksG6/YGsmF/47wyqmxebB0+ow5k+/80TVns567ev6F+PmKBc7q7of4
        mItf+L4L9l63I5PByuqOdn6134rJXuerlqrlMf/wvB2QM2mSfljjnDd83i5ZLv4SlsuVYyLn
        vzNujWrm0lBcqNw8Lf3ztGNHxI3q7FyMlx73WexjlrTC6Hnll8DOy2sWcThd2vxRiaU4I9FQ
        i7moOBEAMO35T5wDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LJbGCaqPu5Wz7J4M5bfYvVd/vZLD7OesFs
        cehoL4vF9C2ODiwel8+Wepz69ZHd4/2+q2wenzfJBbBEcdmkpOZklqUW6dslcGX8/9XDWNAr
        U/H46GK2BsYd4l2MnBwSAiYSS+5dY+9i5OIQEljNKDHtfSsTSEJI4AOjxMY5vhCJ/YwS918t
        YOti5OBgE9CUeLu/ACQuInCIUeLe9mVsIA3MAuoSxzZuALOFBWwl2n7sZwWxRQScJJ79fsMG
        YetJHP7yBWwOi4CKxJo9PiAmr4C1xNppzCAVjAJiEt9PrWGCmCgucevJfCaIOwUkluw5zwxh
        i0q8fPyPFcJWlLj//SU7RL2exI2pU6Cu0ZZYtvA1WD2vgKDEyZlPWCDqJSUOrrjBMoFRdBaS
        FbOQtM9C0j4LSfsCRpZVjOKlxcW56RXFRnmp5XrFibnFpXnpesn5uZsYgbF0+t/h6B2Mt299
        1DvEyMTBCAwcDmYlEV5xa/kkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwvoybGCwmkJ5akZqem
        FqQWwWSZODilGpi2N/UZGdfLJoY9+3vnl9IT1jM3jq+KtMk4Ij5ZRP+OWyJvH1vIx6MayVnV
        jhWflx3/3Lf14JtfTW6b2L6/3LJjyaovkpLF787qHZ15ef+2ov9vm0peN6l3ilyNZWxw5598
        20dWWz+/U/Vdrrbdn+jfGx1jNv6dtmpxr9VcWwntvrY9Nvx+TicSg3Zz+3+6nLntwKmfcU+e
        K+mEKOkULff8uiNqXlCk9kNpVqYt+elyX1sar3pb/qr/73SbP940sy5R4IDmmXqV6N2RL/vs
        RRb9/m2wpPDW00rhgijdnuJvDSHdiwWOS5+7tev/jE2pWuvv3a8POFLOOm+RnKOUklrK2il/
        3kzqz9W383hj8kSJpTgj0VCLuag4EQBfDVi8FAMAAA==
X-CMS-MailID: 20220302152331uscas1p297d64e27b29db799fd64d494ad584860
CMS-TYPE: 301P
X-CMS-RootMailID: 20220302152331uscas1p297d64e27b29db799fd64d494ad584860
References: <CGME20220302152331uscas1p297d64e27b29db799fd64d494ad584860@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

We have a longstanding problem where fio documentation updates must be
made to both the HOWTO and manpage.

Here is a solution that generates a manpage from the README and HOWTO
using Sphinx.

The downside to being able to maintain only one version of the
documentation is that this will cause a bit of trouble for those who
package fio and users building fio without Sphinx support will no longer
have a manpage.

Does this seem like a reasonable tradeoff? If so, I will follow up with
patches to remove the original manpage and update the Sphinx-generated
manpage to have the standard NAME, SYNOPSIS, DESCRIPTION, etc layout.

----
Sphinx can generate a manpage from our README.rst and HOWTO.rst. Use
this facility so that we don't have to maintain both the HOWTO and
a seprate, mostly identical manpage.

Use the Sphinx-built manpage for make install. For environments where
Sphinx is unavailable there will be no manpage.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 Makefile  | 14 +++++++++++---
 configure | 11 +++++++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 0ab4f82c..9799fe46 100644
--- a/Makefile
+++ b/Makefile
@@ -650,8 +650,14 @@ cscope:
 tools/plot/fio2gnuplot.1:
 	@cat tools/plot/fio2gnuplot.manpage | txt2man -t fio2gnuplot >  tools/plo=
t/fio2gnuplot.1
=20
+FIO_MANPAGE =3D $(SRCDIR)/doc/output/man/fio.1
+manpage: HOWTO.rst README.rst
+ifdef CONFIG_SPHINX
+	$(MAKE) -C doc man
+endif
+
 doc: tools/plot/fio2gnuplot.1
-	@man -t ./fio.1 | ps2pdf - fio.pdf
+	@man -t $(FIO_MANPAGE) | ps2pdf - fio.pdf
 	@man -t tools/fio_generate_plots.1 | ps2pdf - fio_generate_plots.pdf
 	@man -t tools/plot/fio2gnuplot.1 | ps2pdf - fio2gnuplot.pdf
 	@man -t tools/hist/fiologparser_hist.py.1 | ps2pdf - fiologparser_hist.pd=
f
@@ -675,7 +681,7 @@ fulltest:
 		sudo t/zbd/run-tests-against-nullb -s 4;	 	\
 	fi
=20
-install: $(PROGS) $(SCRIPTS) $(ENGS_OBJS) tools/plot/fio2gnuplot.1 FORCE
+install: $(PROGS) $(SCRIPTS) $(ENGS_OBJS) tools/plot/fio2gnuplot.1 manpage=
 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
 ifdef CONFIG_DYNAMIC_ENGINES
@@ -683,7 +689,9 @@ ifdef CONFIG_DYNAMIC_ENGINES
 	$(INSTALL) -m 755 $(SRCDIR)/engines/*.so $(DESTDIR)$(libdir)
 endif
 	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
-	$(INSTALL) -m 644 $(SRCDIR)/fio.1 $(DESTDIR)$(mandir)/man1
+ifdef CONFIG_SPHINX
+	$(INSTALL) -m 644 $(FIO_MANPAGE) $(DESTDIR)$(mandir)/man1
+endif
 	$(INSTALL) -m 644 $(SRCDIR)/tools/fio_generate_plots.1 $(DESTDIR)$(mandir=
)/man1
 	$(INSTALL) -m 644 $(SRCDIR)/tools/plot/fio2gnuplot.1 $(DESTDIR)$(mandir)/=
man1
 	$(INSTALL) -m 644 $(SRCDIR)/tools/hist/fiologparser_hist.py.1 $(DESTDIR)$=
(mandir)/man1
diff --git a/configure b/configure
index be4605f9..6849bd9e 100755
--- a/configure
+++ b/configure
@@ -2847,6 +2847,14 @@ EOF
 fi
 print_config "timerfd_create" "$timerfd_create"
=20
+##########################################
+# check for sphinx support
+sphinx=3D"no"
+if has "sphinx-build" ; then
+  sphinx=3D"yes"
+fi
+print_config "sphinx" "$sphinx"
+
 ##########################################################################=
###
=20
 if test "$wordsize" =3D "64" ; then
@@ -3196,6 +3204,9 @@ fi
 if test "$fcntl_sync" =3D "yes" ; then
   output_sym "CONFIG_FCNTL_SYNC"
 fi
+if test "$sphinx" =3D "yes"; then
+  output_sym "CONFIG_SPHINX"
+fi
=20
 print_config "Lib-based ioengines dynamic" "$dynamic_engines"
 cat > $TMPC << EOF
--=20
2.25.1
