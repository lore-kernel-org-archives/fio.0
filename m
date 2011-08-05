Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55405 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1HEOdx (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Aug 2011 10:33:53 -0400
Received: from merkaba.localnet (ppp-88-217-114-117.dynamic.mnet-online.de [88.217.114.117])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 3E014C3
	for <fio@vger.kernel.org>; Fri,  5 Aug 2011 16:33:52 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: [PATCH] fio_generate_plots with setable resolution
Date: Fri, 5 Aug 2011 16:33:33 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2172023.78Z6sRytII";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201108051633.47905.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--nextPart2172023.78Z6sRytII
Content-Type: multipart/mixed;
  boundary="Boundary-01=_98/OOxZzt01JPDN"
Content-Transfer-Encoding: 7bit


--Boundary-01=_98/OOxZzt01JPDN
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!

Use

fio_generate_plots somename 1600 1200

or something like that.

Just quit and dirty ATM. On interest I can make up a patch for inclusion=20
in fio package *after* I finished my article ;).

=46onts tend to get small on hi resolutions. It seems gnuplot takes them as=
=20
pixel not points/dots (related to some dots per inch).

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-01=_98/OOxZzt01JPDN
Content-Type: text/x-patch;
  charset="UTF-8";
  name="fio_generate_plots_resolution.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fio_generate_plots_resolution.diff"

=2D-- /usr/bin/fio_generate_plots	2011-08-03 14:30:09.000000000 +0200
+++ fio_generate_plots	2011-08-05 16:28:37.966057883 +0200
@@ -15,6 +15,15 @@
=20
 TITLE=3D$1
=20
+# set resolution
+if [ "$2"x !=3D "x" -a "$3"x !=3D "x" ]; then
+	XRES=3D"$2"
+	YRES=3D"$3"
+else
+	XRES=3D800
+	YRES=3D600
+fi
+
 PLOT_LINE=3D""
 for i in *bw.log; do
 	if [ ! -r $i ]; then
@@ -30,7 +39,7 @@
=20
 if [ "$PLOT_LINE"x !=3D "x" ]; then
 	echo Making bw logs
=2D	echo "set title 'Bandwidth - $TITLE'; set xlabel 'time (msec)'; set yla=
bel 'KB/sec'; set terminal png; set output '$TITLE-bw.png'; plot " $PLOT_LI=
NE | $GNUPLOT -
+	echo "set title 'Bandwidth - $TITLE'; set xlabel 'time (msec)'; set ylabe=
l 'KB/sec'; set terminal png size $XRES,$YRES; set output '$TITLE-bw.png'; =
plot " $PLOT_LINE | $GNUPLOT -
 fi
=20
 PLOT_LINE=3D""
@@ -48,7 +57,7 @@
=20
 if [ "$PLOT_LINE"x !=3D "x" ]; then
 	echo Making slat logs $PLOT_LINE
=2D	echo "set title 'Submission latency - $TITLE'; set xlabel 'time (msec)'=
; set ylabel 'latency (msec)'; set terminal png; set output '$TITLE-slat.pn=
g'; plot " $PLOT_LINE | $GNUPLOT -
+	echo "set title 'Submission latency - $TITLE'; set xlabel 'time (msec)'; =
set ylabel 'latency (msec)'; set terminal png size $XRES,$YRES; set output =
'$TITLE-slat.png'; plot " $PLOT_LINE | $GNUPLOT -
 fi
=20
 PLOT_LINE=3D""
@@ -66,7 +75,7 @@
=20
 if [ "$PLOT_LINE"x !=3D "x" ]; then
 	echo Making clat logs $PLOT_LINE
=2D	echo "set title 'Completion latency - $TITLE'; set xlabel 'time (msec)'=
; set ylabel 'latency (msec)'; set terminal png; set output '$TITLE-clat.pn=
g'; plot " $PLOT_LINE | $GNUPLOT -
+	echo "set title 'Completion latency - $TITLE'; set xlabel 'time (msec)'; =
set ylabel 'latency (msec)'; set terminal png size $XRES,$YRES; set output =
'$TITLE-clat.png'; plot " $PLOT_LINE | $GNUPLOT -
 fi
=20
 PLOT_LINE=3D""
@@ -84,5 +93,5 @@
=20
 if [ "$PLOT_LINE"x !=3D "x" ]; then
 	echo Making lat logs $PLOT_LINE
=2D	echo "set title 'Latency - $TITLE'; set xlabel 'time (msec)'; set ylabe=
l 'latency (msec)'; set terminal png; set output '$TITLE-lat.png'; plot " $=
PLOT_LINE | $GNUPLOT -
+	echo "set title 'Latency - $TITLE'; set xlabel 'time (msec)'; set ylabel =
'latency (msec)'; set terminal png size $XRES,$YRES; set output '$TITLE-lat=
=2Epng'; plot " $PLOT_LINE | $GNUPLOT -
 fi

--Boundary-01=_98/OOxZzt01JPDN--

--nextPart2172023.78Z6sRytII
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk47/z0ACgkQmRvqrKWZhMcxRwCglmHNhX04cShQhW43KxtiPkjW
icMAnjBvTbwHcrp3DZRyV+sA/0MA8pP4
=i3YR
-----END PGP SIGNATURE-----

--nextPart2172023.78Z6sRytII--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


