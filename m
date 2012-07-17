Return-Path: <fio-owner@vger.kernel.org>
Received: from nougat.ucs.ed.ac.uk ([129.215.13.205]:39280 "EHLO
	nougat.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab2GQQCu (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 Jul 2012 12:02:50 -0400
Received: from lmtp1.ucs.ed.ac.uk (lmtp1.ucs.ed.ac.uk [129.215.149.64])
	by nougat.ucs.ed.ac.uk (8.13.8/8.13.4) with ESMTP id q6HFJHT0020597
	for <fio@vger.kernel.org>; Tue, 17 Jul 2012 16:19:22 +0100 (BST)
Received: from [129.215.183.3] (pcw3047.see.ed.ac.uk [129.215.183.3])
	(authenticated user=mrichar1 mech=PLAIN bits=0)
	by lmtp1.ucs.ed.ac.uk (8.13.8/8.13.7) with ESMTP id q6HFJHnM008682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Tue, 17 Jul 2012 16:19:17 +0100 (BST)
Message-ID: <50058274.2070006@ed.ac.uk>
Date: Tue, 17 Jul 2012 16:19:16 +0100
From: Matthew Richardson <m.richardson@ed.ac.uk>
MIME-Version: 1.0
Subject: Filenames on 'server' jobs to shared filesystems
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE53A1B8E3AD1D5ED359C3112"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE53A1B8E3AD1D5ED359C3112
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I'm currently using fio to simulate user reads and writes to a NAS
service, and am testing the performance of different shared filesystems
(NFS, Samba, Glusterfs etc).

In order to properly load the box I'm using a pool of clients to connect
to the fs (fio --server) and then launching the same job on multiple
clients. (fio --client=3Da --client=3Db job.fio)

The resulting jobs on the different servers all seem to use the same
file - the filename seems to be <name>.<thread>.<fileno> - in this case
'job.1.0':

[global]
directory=3D/mnt/gluster
rw=3Drandrw
size=3D10M
ioengine=3Dlibaio

[job]


Is there any way to have the server include some personal identifier
(such as hostname) in the filename so that there isn't this conflict?

Thanks,

Matthew

--=20
The University of Edinburgh is a charitable body, registered in
Scotland, with registration number SC005336.



--------------enigE53A1B8E3AD1D5ED359C3112
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlAFgnUACgkQRWpi1WYCQdJqhgCfQtU/yywry1NKglxD59LiAesK
PrsAn1TrAVGT5PzFQVoV3PsL/mw12n6H
=g4RQ
-----END PGP SIGNATURE-----

--------------enigE53A1B8E3AD1D5ED359C3112--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


