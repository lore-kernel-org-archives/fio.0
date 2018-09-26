Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:38899 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbeIZWGE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Sep 2018 18:06:04 -0400
Received: from JUNENHP640W7 ([76.30.173.5]) by mrelay.perfora.net (mreueus002
 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Lwpo6-1fgtz31bE8-016SGr for
 <fio@vger.kernel.org>; Wed, 26 Sep 2018 17:52:29 +0200
From: <eliezer@integritech.solutions>
Subject: Resending:  fio testing on S3 object storage
Date: Wed, 26 Sep 2018 10:52:28 -0500
Message-ID: <003301d455b0$eda7a8e0$c8f6faa0$@integritech.solutions>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Greetings,

First of all, my apologies for re-sending this email.  I've now sent it to
the correct maillist this time and in the proper mail format.

How does one run fio against an S3 object storage device?

Here=EF=BF=BDs the fio parameters I=EF=BF=BDm using but I=EF=BF=BDm getting=
 the below error message:

# fio --ioengine=3Dhttp --iodepth=3D1 --http_mode=3Ds3 --http_s3_region=3Du=
s-geo
--http_s3_key=3D123mYkEyInfo --http_s3_keyid=3D123mYkEyiDinfO --bs=3D16k
--size=3D100MB --http_host=3Ds3-api.us-geo.objectstorage.inthecloud.net
--https=3Don --http_verbose=3D2
fio: engine https not loadable
fio: failed to load engine

Am I missing a kernel module required by fio =EF=BF=BDor am I missing a few=
 more fio
parameters from the command line?=EF=BF=BD=EF=BF=BD If so, what do I need t=
o do to enable
that module?

Here=EF=BF=BDs my server info:

# cat /etc/redhat-release
Red Hat Enterprise Linux Server release 7.5 (Maipo)

# fio --version
fio-3.1

# uname -a
Linux mytestserver.testfio.com 3.10.0-862.11.6.el7.x86_64 #1 SMP Fri Aug 10
16:55:11 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

Many thanks in advance for your attention and your response(s).

Regards,
Eliezer


