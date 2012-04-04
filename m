Return-Path: <fio-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2DDGjU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Apr 2012 02:39:20 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 8B8048FC93
	for <fio@vger.kernel.org>; Wed,  4 Apr 2012 08:39:19 +0200 (CEST)
Message-ID: <4F7BEC92.8000100@suse.de>
Date: Wed, 04 Apr 2012 08:39:14 +0200
From: Danny Kukawka <dkukawka@suse.de>
MIME-Version: 1.0
Subject: fio problems
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD22675F780EB0CCAD4FC8BA4"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD22675F780EB0CCAD4FC8BA4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

we try to run fio against raw RBD devices on a ceph cluster. Here are
the parameter we use to run fio:

[test]
filename=3D/dev/rbd0
time_based
runtime=3D3h
rw=3Drandrw
rwmixread=3D80
rwmixwrite=3D20
blocksize_range=3D4k-1024k
ioengine=3Dlibaio
iodepth=3D64
direct=3D1
verify=3Dcrc32c-intel
verify_fatal=3D1
verify_async=3D16
lockfile=3Dexclusive

We see some problems:

1) fio reports higher READ speeds than the used 1Gbit network interface
could provide (the interface isn't even working to capacity in this
situation). That happens if we use --rwmixread/rwmixwrite:

 READ: io=3D91560MB, aggrb=3D156206KB/s, minb=3D159955KB/s,
        maxb=3D159955KB/s, mint=3D600216msec, maxt=3D600216msec
 WRITE: io=3D22944MB, aggrb=3D39143KB/s, minb=3D40083KB/s, maxb=3D40083KB=
/s,
        mint=3D600216msec, maxt=3D600216msec

2) fio 2.0.6 and also the current git tends to fail with this error:

   fio 2.0.6
   Starting 1 process
   fio: iolog.c:242: log_io_piece: Assertion `ipo->len =3D=3D __ipo->len'=

   failed.:08m:31s]

It seems that we can prevent it when we use the --size parameter, but we
would like to prevent the usage of the parameter, if possible

3) fio always reports minb =3D=3D maxb and aggrb < minb as you can see
above. From my understanding this would be false info.

4) If we define rw=3Drandrw, rwmixread=3D80, rwmixwrite=3D20 and the veri=
fy
options, what does the READ process if there isn't enough data written
out yet? Which data does READ read and verify?

Thanks and Regards,

Danny
--=20
Danny Kukawka
 SUSE LINUX Products GmbH
  Maxfeldstrasse 5, D-90409 Nuremberg, Germany
  GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCrnber=
g)


--------------enigD22675F780EB0CCAD4FC8BA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iJwEAQECAAYFAk977JYACgkQ9DHLX79LmTICsAP+NlRfROqGmiQ8jqGpOzTSyZci
hS3s0WtLaRWiUOfgPevgFF57qabZisQjge41yp2dO5jWyKr0VSK1OE+XxohG/xP5
FXWrMdLB2Uwl9Q+rz/DcAJXH+68lrGTItxHr5Chdy7H1wIbu0qJ7tVF9aA5CzGo/
3QCU1Y1TFdc2XiXc95Q=
=s5dC
-----END PGP SIGNATURE-----

--------------enigD22675F780EB0CCAD4FC8BA4--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


